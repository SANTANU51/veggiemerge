import 'package:flutter_test/flutter_test.dart';
import 'package:veggie_merge/app.dart';

void main() {
  testWidgets('Placeholder screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VeggieMergeApp());
    expect(find.text('Veggie Merge'), findsOneWidget);
  });
}