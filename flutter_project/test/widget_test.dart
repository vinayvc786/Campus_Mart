import 'package:flutter_test/flutter_test.dart';
import 'package:campus_mart/main.dart';

void main() {
  testWidgets('Campus Mart App smoke test', (WidgetTester tester) async {
    // Build CampusMartApp and trigger a frame.
    await tester.pumpWidget(const CampusMartApp());

    // Verify app title or core navigation bar items render
    expect(find.text('Campus Mart'), findsWidgets);
  });
}
