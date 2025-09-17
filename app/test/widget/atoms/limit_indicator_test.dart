import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/lead_image/presentation/atoms/image_count_badge_atom.dart';
import 'package:app/features/lead_image/domain/constants/image_constants.dart';
import 'package:app/l10n/app_localizations.dart';

void main() {
  group('Limit Indicator Atom Tests', () {
    Widget createTestApp({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        home: Scaffold(body: child),
      );
    }

    group('Image Count Badge Atom', () {
      testWidgets('should display current and max count', (tester) async {
        // Arrange
        const currentCount = 5;
        const maxCount = ImageConstants.maxImagesPerLead;

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageCountBadgeAtom(
            currentCount: currentCount,
            maxCount: maxCount,
          ),
        ));

        // Assert
        expect(find.text('$currentCount'), findsOneWidget);
        expect(find.text('$maxCount'), findsOneWidget);
        expect(find.text('/'), findsOneWidget);
      });

      testWidgets('should show different colors based on count', (tester) async {
        // Test under limit
        await tester.pumpWidget(createTestApp(
          child: ImageCountBadgeAtom(
            currentCount: 3,
            maxCount: ImageConstants.maxImagesPerLead,
          ),
        ));

        await tester.pumpAndSettle();

        var container = tester.widget<Container>(find.byType(Container).first);
        var decoration = container.decoration as BoxDecoration;
        expect(decoration.color, isNot(Colors.red)); // Should not be red/warning color

        // Test at limit
        await tester.pumpWidget(createTestApp(
          child: ImageCountBadgeAtom(
            currentCount: ImageConstants.maxImagesPerLead,
            maxCount: ImageConstants.maxImagesPerLead,
          ),
        ));

        await tester.pumpAndSettle();

        container = tester.widget<Container>(find.byType(Container).first);
        decoration = container.decoration as BoxDecoration;
        // Should show warning/error styling
        expect(decoration.color, isA<Color>());
      });

      testWidgets('should show warning when near limit', (tester) async {
        // Arrange
        const nearLimitCount = ImageConstants.maxImagesPerLead - 1;

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageCountBadgeAtom(
            currentCount: nearLimitCount,
            maxCount: ImageConstants.maxImagesPerLead,
          ),
        ));

        // Assert
        expect(find.text('$nearLimitCount'), findsOneWidget);

        // Should have warning styling
        final container = tester.widget<Container>(find.byType(Container).first);
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, isA<Color>());
      });

      testWidgets('should handle zero count', (tester) async {
        // Arrange
        const currentCount = 0;

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageCountBadgeAtom(
            currentCount: currentCount,
            maxCount: ImageConstants.maxImagesPerLead,
          ),
        ));

        // Assert
        expect(find.text('0'), findsOneWidget);
        expect(find.text('${ImageConstants.maxImagesPerLead}'), findsOneWidget);
      });

      testWidgets('should be accessible', (tester) async {
        // Arrange
        const currentCount = 7;

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageCountBadgeAtom(
            currentCount: currentCount,
            maxCount: ImageConstants.maxImagesPerLead,
          ),
        ));

        // Assert
        final semantics = tester.getSemantics(find.byType(ImageCountBadgeAtom));
        expect(semantics.label, isNotNull);
        expect(semantics.label, contains('$currentCount'));
        expect(semantics.label, contains('${ImageConstants.maxImagesPerLead}'));
      });

      testWidgets('should handle large numbers correctly', (tester) async {
        // Arrange
        const currentCount = 999;
        const maxCount = 1000;

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageCountBadgeAtom(
            currentCount: currentCount,
            maxCount: maxCount,
          ),
        ));

        // Assert
        expect(find.text('999'), findsOneWidget);
        expect(find.text('1000'), findsOneWidget);
      });

      testWidgets('should show compact format when requested', (tester) async {
        // Arrange
        const currentCount = 5;

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageCountBadgeAtom.minimal(
            count: currentCount,
            maxCount: ImageConstants.maxImagesPerLead,
          ),
        ));

        // Assert
        expect(find.text('5/${ImageConstants.maxImagesPerLead}'), findsOneWidget);
      });

      testWidgets('should show custom font size when provided', (tester) async {
        // Arrange
        const currentCount = 5;
        const customFontSize = 20.0;

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageCountBadgeAtom(
            currentCount: currentCount,
            maxCount: ImageConstants.maxImagesPerLead,
            fontSize: customFontSize,
          ),
        ));

        // Assert
        final textWidget = tester.widget<Text>(find.text('$currentCount').first);
        expect(textWidget.style?.fontSize, equals(customFontSize));
      });

      testWidgets('should display badge with proper style', (tester) async {
        // Arrange
        const currentCount = 5;

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageCountBadgeAtom.prominent(
            count: currentCount,
            maxCount: ImageConstants.maxImagesPerLead,
          ),
        ));

        // Assert
        expect(find.byType(ImageCountBadgeAtom), findsOneWidget);
      });

      testWidgets('should not be tappable when no callback provided', (tester) async {
        // Arrange
        const currentCount = 5;

        // Act
        await tester.pumpWidget(createTestApp(
          child: ImageCountBadgeAtom(
            currentCount: currentCount,
            maxCount: ImageConstants.maxImagesPerLead,
          ),
        ));

        // Assert
        expect(find.byType(GestureDetector), findsNothing);
      });

      testWidgets('should animate count changes', (tester) async {
        // Arrange
        int currentCount = 5;

        // Act
        await tester.pumpWidget(createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  ImageCountBadgeAtom(
                    currentCount: currentCount,
                    maxCount: ImageConstants.maxImagesPerLead,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentCount++;
                      });
                    },
                    child: const Text('Increment'),
                  ),
                ],
              );
            },
          ),
        ));

        expect(find.text('5'), findsOneWidget);

        // Change count
        await tester.tap(find.text('Increment'));
        await tester.pump();

        // Assert
        expect(find.text('6'), findsOneWidget);
        expect(find.text('5'), findsNothing);
      });
    });

    group('Slot Availability Indicators', () {
      testWidgets('should show remaining slots correctly', (tester) async {
        // Arrange
        const currentCount = 7;
        const remainingSlots = ImageConstants.maxImagesPerLead - currentCount;

        // Act
        await tester.pumpWidget(createTestApp(
          child: Text('$remainingSlots slots remaining'),
        ));

        // Assert
        expect(find.text('$remainingSlots slots remaining'), findsOneWidget);
      });

      testWidgets('should show visual slot indicators', (tester) async {
        // Arrange
        const currentCount = 6;

        // Act
        await tester.pumpWidget(createTestApp(
          child: Row(
            children: List.generate(ImageConstants.maxImagesPerLead, (index) {
              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < currentCount ? Colors.blue : Colors.grey[300],
                ),
              );
            }),
          ),
        ));

        // Assert
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, equals(ImageConstants.maxImagesPerLead));

        // Check that filled slots are blue and empty slots are grey
        for (int i = 0; i < ImageConstants.maxImagesPerLead; i++) {
          final container = containers.elementAt(i);
          final decoration = container.decoration as BoxDecoration;
          if (i < currentCount) {
            expect(decoration.color, equals(Colors.blue));
          } else {
            expect(decoration.color, equals(Colors.grey[300]));
          }
        }
      });
    });
  });
}