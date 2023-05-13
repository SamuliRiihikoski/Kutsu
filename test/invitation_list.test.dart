import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:kutsu/src/features/lists/views/views.dart';
import 'package:kutsu/src/features/login/login_screen.dart';

Widget createScreen = MaterialApp(
  home: CreateDateScreen(),
);

void main() {
  testWidgets("Test buttons for creating new invitation", (tester) async {
    await tester.pumpWidget(createScreen);
    expect(find.byKey(key));
  });
}
