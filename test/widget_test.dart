import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_code_editor/app/app.dart';

void main() {
  testWidgets('CodeVerseApp launches and renders Home ', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const ProviderScope(
        child: CodeVerseApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Welcome back'), findsOneWidget);
    expect(find.textContaining('Quick Code Launcher'), findsOneWidget);
  });
}
