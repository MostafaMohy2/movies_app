import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MoviesApp());
    expect(find.text('Movies App Foundation Ready'), findsOneWidget);
  });
}
