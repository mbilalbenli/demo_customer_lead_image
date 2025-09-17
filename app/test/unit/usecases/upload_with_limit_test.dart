import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:app/features/lead_image/application/use_cases/upload_image_use_case.dart';
import 'package:app/features/lead_image/domain/entities/lead_image_entity.dart';
import 'package:app/features/lead_image/domain/repositories/lead_image_repository.dart';
import 'package:app/features/lead_image/domain/constants/image_constants.dart';
import 'package:app/core/error/error_handler.dart';

import 'upload_with_limit_test.mocks.dart';

@GenerateMocks([LeadImageRepository])
void main() {
  group('Upload Image Use Case - Limit Tests', () {
    late MockLeadImageRepository mockRepository;
    late UploadImageUseCase useCase;

    setUp(() {
      mockRepository = MockLeadImageRepository();
      useCase = UploadImageUseCase(mockRepository);
    });

    group('Limit Enforcement', () {
      test('should allow upload when under limit', () async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = 5;
        const mockImageData = 'base64-encoded-image-data';

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => const Right(currentCount));

        when(mockRepository.uploadImage(
              leadId: leadId,
              base64Data: mockImageData,
              fileName: 'test.jpg',
              contentType: 'image/jpeg',
            ))
            .thenAnswer((_) async => Right(LeadImageEntity.create(
              id: 'image-123',
              leadId: leadId,
              base64String: mockImageData,
              fileName: 'test.jpg',
              contentType: 'image/jpeg',
              orderIndex: 0,
            )));

        // Act
        final result = await useCase.execute(
          leadId: leadId,
          base64Data: mockImageData,
          fileName: 'test.jpg',
          contentType: 'image/jpeg',
        );

        // Assert
        expect(result.isRight(), true);
        verify(mockRepository.getImageCount(leadId)).called(1);
        verify(mockRepository.uploadImage(
          leadId: leadId,
          base64Data: mockImageData,
          fileName: 'test.jpg',
          contentType: 'image/jpeg',
        )).called(1);
      });

      test('should reject upload when at limit', () async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = ImageConstants.maxImagesPerLead;
        const mockImageData = 'base64-encoded-image-data';

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => const Right(currentCount));

        // Act
        final result = await useCase.execute(
          leadId: leadId,
          base64Data: mockImageData,
          fileName: 'test.jpg',
          contentType: 'image/jpeg',
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (error) => expect(error, isA<ImageLimitException>()),
          (success) => fail('Expected an error but got success'),
        );
        verify(mockRepository.getImageCount(leadId)).called(1);
        verifyNever(mockRepository.uploadImage(
          leadId: anyNamed('leadId'),
          base64Data: anyNamed('base64Data'),
          fileName: anyNamed('fileName'),
          contentType: anyNamed('contentType'),
        ));
      });

      test('should reject upload when exceeding limit', () async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = ImageConstants.maxImagesPerLead + 1;
        const mockImageData = 'base64-encoded-image-data';

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => const Right(currentCount));

        // Act
        final result = await useCase.execute(
          leadId: leadId,
          base64Data: mockImageData,
          fileName: 'test.jpg',
          contentType: 'image/jpeg',
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (error) => expect(error, isA<ImageLimitException>()),
          (success) => fail('Expected an error but got success'),
        );
        verify(mockRepository.getImageCount(leadId)).called(1);
        verifyNever(mockRepository.uploadImage(
          leadId: anyNamed('leadId'),
          base64Data: anyNamed('base64Data'),
          fileName: anyNamed('fileName'),
          contentType: anyNamed('contentType'),
        ));
      });

      test('should allow upload at exactly limit minus one', () async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = ImageConstants.maxImagesPerLead - 1;
        const mockImageData = 'base64-encoded-image-data';

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => const Right(currentCount));

        when(mockRepository.uploadImage(
              leadId: leadId,
              base64Data: mockImageData,
              fileName: 'test.jpg',
              contentType: 'image/jpeg',
            ))
            .thenAnswer((_) async => Right(LeadImageEntity.create(
              id: 'image-123',
              leadId: leadId,
              base64String: mockImageData,
              fileName: 'test.jpg',
              contentType: 'image/jpeg',
              orderIndex: 0,
            )));

        // Act
        final result = await useCase.execute(
          leadId: leadId,
          base64Data: mockImageData,
          fileName: 'test.jpg',
          contentType: 'image/jpeg',
        );

        // Assert
        expect(result.isRight(), true);
        verify(mockRepository.getImageCount(leadId)).called(1);
        verify(mockRepository.uploadImage(
          leadId: leadId,
          base64Data: mockImageData,
          fileName: 'test.jpg',
          contentType: 'image/jpeg',
        )).called(1);
      });
    });

    group('Batch Upload Limits', () {
      test('should reject batch upload when total exceeds limit', () async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = 8;
        final mockImages = List.generate(5, (index) => 'base64-data-$index');

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => const Right(currentCount));

        // Act
        final results = <dynamic>[];
        for (int i = 0; i < mockImages.length; i++) {
          final result = await useCase.execute(
            leadId: leadId,
            base64Data: mockImages[i],
            fileName: 'test$i.jpg',
            contentType: 'image/jpeg',
          );
          results.add(result);

          // Update mock count for subsequent calls
          when(mockRepository.getImageCount(leadId))
              .thenAnswer((_) async => Right(currentCount + i + 1));
        }

        // Assert
        expect(results[0].isRight(), true); // 9th image - should succeed
        expect(results[1].isRight(), true); // 10th image - should succeed
        expect(results[2].isLeft(), true); // 11th image - should fail
        expect(results[3].isLeft(), true); // 12th image - should fail
        expect(results[4].isLeft(), true); // 13th image - should fail
      });
    });

    group('Edge Cases', () {
      test('should handle repository errors gracefully', () async {
        // Arrange
        const leadId = 'lead-123';
        const mockImageData = 'base64-encoded-image-data';

        when(mockRepository.getImageCount(leadId))
            .thenThrow(Exception('Database connection failed'));

        // Act
        final result = await useCase.execute(
          leadId: leadId,
          base64Data: mockImageData,
          fileName: 'test.jpg',
          contentType: 'image/jpeg',
        );

        // Assert
        expect(result.isLeft(), true);
        verify(mockRepository.getImageCount(leadId)).called(1);
        verifyNever(mockRepository.uploadImage(
          leadId: anyNamed('leadId'),
          base64Data: anyNamed('base64Data'),
          fileName: anyNamed('fileName'),
          contentType: anyNamed('contentType'),
        ));
      });

      test('should handle negative image count', () async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = -1;
        const mockImageData = 'base64-encoded-image-data';

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => const Right(currentCount));

        when(mockRepository.uploadImage(
              leadId: leadId,
              base64Data: mockImageData,
              fileName: 'test.jpg',
              contentType: 'image/jpeg',
            ))
            .thenAnswer((_) async => Right(LeadImageEntity.create(
              id: 'image-123',
              leadId: leadId,
              base64String: mockImageData,
              fileName: 'test.jpg',
              contentType: 'image/jpeg',
              orderIndex: 0,
            )));

        // Act
        final result = await useCase.execute(
          leadId: leadId,
          base64Data: mockImageData,
          fileName: 'test.jpg',
          contentType: 'image/jpeg',
        );

        // Assert
        expect(result.isRight(), true); // Negative count treated as 0
        verify(mockRepository.getImageCount(leadId)).called(1);
        verify(mockRepository.uploadImage(
          leadId: leadId,
          base64Data: mockImageData,
          fileName: 'test.jpg',
          contentType: 'image/jpeg',
        )).called(1);
      });

      test('should handle zero image count', () async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = 0;
        const mockImageData = 'base64-encoded-image-data';

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => const Right(currentCount));

        when(mockRepository.uploadImage(
              leadId: leadId,
              base64Data: mockImageData,
              fileName: 'test.jpg',
              contentType: 'image/jpeg',
            ))
            .thenAnswer((_) async => Right(LeadImageEntity.create(
              id: 'image-123',
              leadId: leadId,
              base64String: mockImageData,
              fileName: 'test.jpg',
              contentType: 'image/jpeg',
              orderIndex: 0,
            )));

        // Act
        final result = await useCase.execute(
          leadId: leadId,
          base64Data: mockImageData,
          fileName: 'test.jpg',
          contentType: 'image/jpeg',
        );

        // Assert
        expect(result.isRight(), true);
        verify(mockRepository.getImageCount(leadId)).called(1);
        verify(mockRepository.uploadImage(
          leadId: leadId,
          base64Data: mockImageData,
          fileName: 'test.jpg',
          contentType: 'image/jpeg',
        )).called(1);
      });
    });

    group('Performance Tests', () {
      test('should handle multiple concurrent upload attempts', () async {
        // Arrange
        const leadId = 'lead-123';
        const currentCount = ImageConstants.maxImagesPerLead - 1;
        final futures = <Future>[];

        when(mockRepository.getImageCount(leadId))
            .thenAnswer((_) async => const Right(currentCount));

        // Act - Simulate multiple concurrent uploads
        for (int i = 0; i < 5; i++) {
          final future = useCase.execute(
            leadId: leadId,
            base64Data: 'base64-data-$i',
            fileName: 'test$i.jpg',
            contentType: 'image/jpeg',
          );
          futures.add(future);
        }

        final results = await Future.wait(futures);

        // Assert - Only one should succeed due to limit
        final successCount = results.where((r) => r.isRight()).length;
        final failureCount = results.where((r) => r.isLeft()).length;

        expect(successCount, 1);
        expect(failureCount, 4);
      });
    });
  });
}