import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:kutsu/src/features/lists/bloc/lists_bloc.dart';
import 'package:kutsu/src/features/login/pin_panel.dart';
import 'package:kutsu/src/shared/ui/ui.dart';
import 'package:kutsu/singletons/application.dart';
import 'package:kutsu/providers/users.dart';

enum LoginView { main, phone, pin }

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  bool? newUser;
  LoginView currentView = LoginView.main;
  String id = "";
  String errorText = "";
  String errorCode = "";

  bool isValidNumber(String fieldValue) {
    if (int.tryParse(fieldValue) == null) return false;
    if (fieldValue.length != 9 && fieldValue.length != 10) return false;

    return true;
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode focusNode = FocusNode();
  TextEditingController phoneInputController = TextEditingController();

  Future<void> verifyUserPhoneNumber(
      BuildContext context, String phoneNumber) async {
    FirebaseAuth.instance.setLanguageCode("fi");
    print('phone: ${phoneNumber}');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+358' + phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        Application().stopLoading();
        print('PHONE AUTH SUCCESS');
      },
      verificationFailed: (FirebaseAuthException e) {
        Application().stopLoading();
        print('PHONE FAILED: $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        Application().stopLoading();

        setState(() {
          widget.id = verificationId;
          widget.currentView = LoginView.pin;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Application().stopLoading();
        print('TIMEOUT');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          if (widget.currentView == LoginView.main) ...[
            Image.asset(
              'assets/calendar.png',
              color: const Color.fromARGB(255, 10, 84, 33),
              height: 140,
              width: 100,
            ),
          ],
          Image.asset(
            'assets/dopicker.png',
            color: const Color.fromARGB(255, 0, 0, 0),
            height: 30,
            width: 140,
          ),
          const SizedBox(
            height: 20,
          ),
          if (widget.currentView == LoginView.main) ...[
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Lähetä kutsu sinua lähellä oleville ihmisille helposti ja vaivattomasti',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ] else if (widget.currentView == LoginView.phone) ...[
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Lähetämme 6-numeroisen vahvistuskoodin antamaasi puhelinnumeroon',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ] else ...[
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Syötä saamasi koodi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: 300,
              color: const Color.fromARGB(255, 193, 193, 193),
              height: 1,
            ),
          ),
          if (widget.currentView == LoginView.main) ...[
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color.fromARGB(255, 163, 163, 163), width: 1),
              ),
              child: GestureDetector(
                key: Key('phone_login'),
                behavior: HitTestBehavior.opaque,
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Kirjaudu puhelimella',
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    widget.currentView = LoginView.phone;
                  });
                },
              ),
            ),
          ] else if (widget.currentView == LoginView.phone) ...[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    const Text(
                      '+358',
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          focusNode: focusNode,
                          controller: phoneInputController,
                          maxLength: 10,
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            errorText: widget.errorText,
                            errorStyle: const TextStyle(fontSize: 18),
                            labelStyle: const TextStyle(fontSize: 18),
                            labelText: "Syötä Puhelinnumero",
                          ),
                          onFieldSubmitted: (value) async {
                            if (widget.isValidNumber(value) == true) {
                              focusNode.unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                              Application().addLoadingMessage(
                                  "Lähetetään tekstiviestiä");
                              await verifyUserPhoneNumber(
                                  context, phoneInputController.value.text);
                            } else {
                              widget.errorText =
                                  "Numero on virheellinen. Syötä vain numeroita.";
                            }
                          },
                        ),
                      ),
                    )
                  ],
                )),
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                widget.errorCode,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
            PinPanel(
              callback: (code) async {
                FocusManager.instance.primaryFocus?.unfocus();
                Application().addLoadingMessage("Vahvistetaan koodia");
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.id, smsCode: code);

                try {
                  final user = await FirebaseAuth.instance
                      .signInWithCredential(credential);
                  if (user.additionalUserInfo!.isNewUser) {
                    await UsersProvider().createUser();

                    Application().changeTabIndex = 3;
                    Application().newUserLogged = true;
                  }
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    widget.errorCode =
                        "Koodi on virheellinen. Tarkista ja yritä uudestaan";
                  });
                }

                Application().stopLoading();
              },
            ),
          ],
          const Spacer(),
          if (widget.currentView == LoginView.main) ...[
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(40),
                child: Text('Lue info', style: TextStyle(fontSize: 20)),
              ),
              onTap: () {
                print('info page');
                context.go('/sign/about');
              },
            )
          ],
        ],
      ),
    ));
  }
}
