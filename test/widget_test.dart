import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scam_inc/app/app.dart';

void main() {
  testWidgets('SCAM INC. bootstrap app launches and registers tap', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ScamIncApp()));

    // Verify initial branding and state
    expect(find.text('SCAM INC.'), findsOneWidget);
    expect(find.text('\$0'), findsOneWidget);
    expect(find.text('LAUNCH CAMPAIGN'), findsOneWidget);

    // Tap the campaign button
    await tester.tap(find.text('LAUNCH CAMPAIGN'));
    await tester.pump();

    // Verify revenue increment
    expect(find.text('\$1'), findsOneWidget);
  });
}
