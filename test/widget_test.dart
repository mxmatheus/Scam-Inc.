import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scam_inc/app/app.dart';
import 'package:scam_inc/data/storage/local_storage_adapter.dart';
import 'package:scam_inc/data/providers/repository_providers.dart';

void main() {
  testWidgets('SCAM INC. bootstrap app launches and registers tap', (
    WidgetTester tester,
  ) async {
    final fakeStorage = InMemoryStorageAdapter();

    // Build our app with injected storage provider
    await tester.pumpWidget(
      ProviderScope(
        overrides: [localStorageAdapterProvider.overrideWithValue(fakeStorage)],
        child: const ScamIncApp(),
      ),
    );

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
