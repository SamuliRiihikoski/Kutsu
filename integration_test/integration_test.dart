import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kutsu/src/features/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:kutsu/main.dart' as app;

final loginScreen = LoginScreen();

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('testing authentication with phone number', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Kirjaudu'), findsOneWidget);
  });
}
