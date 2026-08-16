import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scam_inc/app/app.dart';
import 'package:scam_inc/data/storage/local_storage_adapter.dart';
import 'package:scam_inc/data/providers/repository_providers.dart';

void main() {
  testWidgets('MainDashboard 5-tab navigation switches screens properly', (
    WidgetTester tester,
  ) async {
    final storage = InMemoryStorageAdapter();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [localStorageAdapterProvider.overrideWithValue(storage)],
        child: const ScamIncApp(),
      ),
    );

    // Initial state is HQ tab
    expect(find.text('TOTAL REVENUE'), findsOneWidget);
    expect(find.text('LAUNCH CAMPAIGN'), findsOneWidget);

    // Tap Schemes Tab
    await tester.tap(find.text('Schemes'));
    await tester.pumpAndSettle();
    expect(find.text('Digital Schemes'), findsOneWidget);
    expect(find.text('All Tiers'), findsOneWidget);

    // Tap Events Tab
    await tester.tap(find.text('Events'));
    await tester.pumpAndSettle();
    expect(find.text('Live Narrative Incidents'), findsOneWidget);
    expect(find.text('SUSPICIOUS CHAT TRAINING'), findsOneWidget);

    // Tap Prestige Tab
    await tester.tap(find.text('Prestige'));
    await tester.pumpAndSettle();
    expect(find.text('Offshore Syndicate'), findsOneWidget);
    expect(find.text('LAUNDERED CASH BALANCE'), findsOneWidget);

    // Tap Settings Tab
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings & Statistics'), findsOneWidget);
    expect(find.text('Dark Mode (Karanlık Tema)'), findsOneWidget);
    expect(find.text('SHRED ALL EVIDENCE'), findsOneWidget);
  });
}
