import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/app/app.dart';

void main() {
  testWidgets('App opens correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
  });
}