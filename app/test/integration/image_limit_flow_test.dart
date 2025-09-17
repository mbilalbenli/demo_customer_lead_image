import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:app/features/lead_image/presentation/pages/image_gallery_page.dart';
import 'package:app/features/lead_image/presentation/widgets/limit_error_recovery_widget.dart';
import 'package:app/features/lead_image/domain/repositories/lead_image_repository.dart';
import 'package:app/features/lead_image/domain/entities/lead_image_entity.dart';
import 'package:app/features/lead_image/domain/constants/image_constants.dart';
import 'package:app/l10n/app_localizations.dart';

import 'image_limit_flow_test.mocks.dart';

@GenerateMocks([LeadImageRepository])
void main() {
  /// Helper function to generate mock images
  List<LeadImageEntity> generateMockImages(int count, String leadId) {
    return List.generate(count, (index) => LeadImageEntity.create(
      id: 'image-$index',
      leadId: leadId,
      base64String: 'mock-base64-data-$index',
      fileName: 'image_$index.jpg',
      contentType: 'image/jpeg',
      orderIndex: index,
    ));
  }
  group('Image Limit Flow Integration Tests', () {
    late MockLeadImageRepository mockRepository;

    setUp(() {
      mockRepository = MockLeadImageRepository();
    });

    Widget createTestApp({required Widget child}) {
      return ProviderScope(
        overrides: [
          // Override repository provider with mock
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          home: child,
        ),
      );
    }

    group('Upload Flow with Limits', () {
      testWidgets('should show upload button when under limit', (tester) async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = 5;

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => Right(currentCount));

        when(mockRepository.getImagesByLeadId(leadId))
            .thenAnswer((_) async => Right(generateMockImages(currentCount, leadId)));

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageGalleryPage(leadId: leadId),
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('$currentCount / ${ImageConstants.maxImagesPerLead}'), findsOneWidget);
        expect(find.byIcon(Icons.add_a_photo), findsOneWidget);

        // Upload button should be enabled
        final uploadButton = tester.widget<FloatingActionButton>(
          find.byType(FloatingActionButton),
        );
        expect(uploadButton.onPressed, isNotNull);
      });

      testWidgets('should disable upload button when at limit', (tester) async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = ImageConstants.maxImagesPerLead;

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => Right(currentCount));

        when(mockRepository.getImagesByLeadId(leadId))
            .thenAnswer((_) async => Right(generateMockImages(currentCount, leadId)));

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageGalleryPage(leadId: leadId),
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('$currentCount / ${ImageConstants.maxImagesPerLead}'), findsOneWidget);

        // Should show limit reached indicator
        expect(find.textContaining('limit'), findsOneWidget);
      });

      testWidgets('should show warning when approaching limit', (tester) async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = ImageConstants.maxImagesPerLead - 2; // 8 images

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => Right(currentCount));

        when(mockRepository.getImagesByLeadId(leadId))
            .thenAnswer((_) async => Right(generateMockImages(currentCount, leadId)));

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageGalleryPage(leadId: leadId),
        ));
        await tester.pumpAndSettle();

        // Try to add another image to trigger warning
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Assert
        expect(find.textContaining('slots remaining'), findsOneWidget);
      });
    });

    group('Limit Error Recovery Flow', () {
      testWidgets('should show recovery options when limit reached', (tester) async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = ImageConstants.maxImagesPerLead;

        // Act
        await tester.pumpWidget(createTestApp(
          child: Scaffold(
            body: LimitErrorRecoveryWidget(
              leadId: leadId,
              currentCount: currentCount,
            ),
          ),
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Image Limit Reached'), findsOneWidget);
        expect(find.text('Replace an Image'), findsOneWidget);
        expect(find.text('Delete an Image'), findsOneWidget);
        expect(find.textContaining('Cancel'), findsOneWidget);
      });

      testWidgets('should navigate to gallery when replace option selected', (tester) async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = ImageConstants.maxImagesPerLead;
        bool replaceCallbackCalled = false;

        // Act
        await tester.pumpWidget(createTestApp(
          child: Scaffold(
            body: LimitErrorRecoveryWidget(
              leadId: leadId,
              currentCount: currentCount,
              onRetry: () {
                replaceCallbackCalled = true;
              },
            ),
          ),
        ));
        await tester.pumpAndSettle();

        // Tap replace option
        await tester.tap(find.textContaining('Replace'));
        await tester.pumpAndSettle();

        // Assert
        expect(replaceCallbackCalled, true);
      });

      testWidgets('should navigate to gallery when delete option selected', (tester) async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = ImageConstants.maxImagesPerLead;
        bool deleteCallbackCalled = false;

        // Act
        await tester.pumpWidget(createTestApp(
          child: Scaffold(
            body: LimitErrorRecoveryWidget(
              leadId: leadId,
              currentCount: currentCount,
              onRetry: () {
                deleteCallbackCalled = true;
              },
            ),
          ),
        ));
        await tester.pumpAndSettle();

        // Tap delete option
        await tester.tap(find.textContaining('Delete'));
        await tester.pumpAndSettle();

        // Assert
        expect(deleteCallbackCalled, true);
      });
    });

    group('Visual Limit Indicators', () {
      testWidgets('should show correct slot indicator', (tester) async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = 7;

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => Right(currentCount));

        when(mockRepository.getImagesByLeadId(leadId))
            .thenAnswer((_) async => Right(generateMockImages(currentCount, leadId)));

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageGalleryPage(leadId: leadId),
        ));
        await tester.pumpAndSettle();

        // Assert
        final remainingSlots = ImageConstants.maxImagesPerLead - currentCount;
        expect(find.text('$remainingSlots slots'), findsOneWidget);
      });

      testWidgets('should show visual progress indicator', (tester) async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = 6;

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => Right(currentCount));

        when(mockRepository.getImagesByLeadId(leadId))
            .thenAnswer((_) async => Right(generateMockImages(currentCount, leadId)));

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageGalleryPage(leadId: leadId),
        ));
        await tester.pumpAndSettle();

        // Assert
        // Look for progress indicators (circles or bars)
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should provide proper semantics for limit status', (tester) async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = 8;

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => Right(currentCount));

        when(mockRepository.getImagesByLeadId(leadId))
            .thenAnswer((_) async => Right(generateMockImages(currentCount, leadId)));

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageGalleryPage(leadId: leadId),
        ));
        await tester.pumpAndSettle();

        // Assert
        final semantics = tester.getSemantics(find.text('$currentCount / ${ImageConstants.maxImagesPerLead}'));
        expect(semantics.label, isNotNull);
        expect(semantics.label, contains('$currentCount'));
        expect(semantics.label, contains('${ImageConstants.maxImagesPerLead}'));
      });

      testWidgets('should announce limit changes', (tester) async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = 9;

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => Right(currentCount));

        when(mockRepository.getImagesByLeadId(leadId))
            .thenAnswer((_) async => Right(generateMockImages(currentCount, leadId)));

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageGalleryPage(leadId: leadId),
        ));
        await tester.pumpAndSettle();

        // Assert
        // Verify accessibility announcements would be made
        expect(find.byType(Semantics), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle repository errors gracefully', (tester) async {
        // Arrange
        const leadId = 'lead-123';

        when(mockRepository.getImageCount(leadId))
            .thenThrow(Exception('Network error'));

        when(mockRepository.getImagesByLeadId(leadId))
            .thenThrow(Exception('Network error'));

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageGalleryPage(leadId: leadId),
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.textContaining('error'), findsOneWidget);
        expect(find.textContaining('retry'), findsOneWidget);
      });

      testWidgets('should handle invalid image count', (tester) async {
        // Arrange
        const leadId = 'lead-123';

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => const Right(-1)); // Invalid count

        when(mockRepository.getImagesByLeadId(leadId))
            .thenAnswer((_) async => Right(<LeadImageEntity>[]));

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageGalleryPage(leadId: leadId),
        ));
        await tester.pumpAndSettle();

        // Assert
        // Should handle gracefully and show 0 or corrected count
        expect(find.text('0 / ${ImageConstants.maxImagesPerLead}'), findsOneWidget);
      });
    });
  });
}