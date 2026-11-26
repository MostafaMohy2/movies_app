import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  testWidgets('Onboarding moves forward, backward and finishes', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const OnboardingPage(),
      routes: {'/login': (_) => const Scaffold(body: Text('Login'))},
    ));

    expect(find.text('Find Your Next\nFavorite Movie Here'), findsOneWidget);
    await tester.tap(find.text('Explore Now'));
    await tester.pumpAndSettle();
    expect(find.text('Discover Movies'), findsOneWidget);
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Find Your Next\nFavorite Movie Here'), findsOneWidget);

    await tester.tap(find.text('Explore Now'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Start Watching Now'), findsOneWidget);
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
  });
}
