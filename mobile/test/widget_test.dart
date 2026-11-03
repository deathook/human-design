import 'package:flutter_test/flutter_test.dart';
import 'package:human_design_app/main.dart';

void main() {
  testWidgets('HumanDesignApp builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(const HumanDesignApp());
    expect(find.byType(HumanDesignApp), findsOneWidget);
  });
}
