import 'package:flutter_test/flutter_test.dart';
import 'package:kutsu/src/features/login/login_screen.dart';

void main() {
  test('Testing valid phonenumber', () {
    final loginScreen = LoginScreen();
    bool isValid = loginScreen.isValidNumber("044.1234567");
    expect(isValid, false);
    isValid = loginScreen.isValidNumber("044");
    expect(isValid, false);
    isValid = loginScreen.isValidNumber("0441234567");
    expect(isValid, true);
  });
}
