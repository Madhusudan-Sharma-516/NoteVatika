import 'package:flutter_test/flutter_test.dart';
import 'package:learn_app/app.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NoteVatikaApp());
    // Verify the splash screen renders
    await tester.pump();
  });
}
