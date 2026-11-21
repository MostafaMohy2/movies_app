import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/core/common_ui/movie_card/movie_card.dart';
import 'package:movies_app/core/entities/movie_entity.dart';

void main() {
  const testMovie = MovieEntity(
    id: 1,
    image: 'https://example.com/poster.jpg',
    rating: 7.7,
  );

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 140, height: 210, child: child)),
      ),
    );
  }

  group('MovieEntity', () {
    test('instantiates with correct values', () {
      expect(testMovie.id, 1);
      expect(testMovie.image, 'https://example.com/poster.jpg');
      expect(testMovie.rating, 7.7);
    });
  });

  group('MovieCard Widget Test', () {
    testWidgets('renders rating badge and handles tap callback', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        makeTestableWidget(
          MovieCard(
            movie: testMovie,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      expect(find.text('7.7'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);

      await tester.tap(find.byType(MovieCard));
      expect(tapped, true);
    });
  });
}
