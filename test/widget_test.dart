import 'package:flutter_test/flutter_test.dart';
import 'package:casestudy1_app/main.dart';

void main() {
  testWidgets('ExpenseManagerApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ExpenseManagerApp());

    // Verify that the title exists.
    expect(find.text('Quản lý thu chi'), findsOneWidget);
  });
}
