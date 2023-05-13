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

enum LoginView { phone, pin }

class DeleteProfileScreen extends StatefulWidget {
  DeleteProfileScreen({super.key});

  bool? newUser;
  LoginView currentView = LoginView.phone;
  String id = "";
  String errorText = "";
  String errorCode = "";

  @override
  State<DeleteProfileScreen> createState() => _DeleteProfileScreenState();
}

class _DeleteProfileScreenState extends State<DeleteProfileScreen> {
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
          if (widget.currentView == LoginView.phone) ...[
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Tilin poisto tapahtuu vahvalla tunnistautumisella. Syötä puhelinnumerosi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ] else ...[
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Syötä 6-numeroinen koodi sms viestistä poistaaksesi profiilisi',
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
          if (widget.currentView == LoginView.phone) ...[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Text(
                      '+358',
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          focusNode: focusNode,
                          controller: phoneInputController,
                          maxLength: 10,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            errorText: widget.errorText,
                            errorStyle: TextStyle(fontSize: 18),
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: "Syötä Puhelinnumero",
                          ),
                          onChanged: (value) {
                            if (int.tryParse(value) == null &&
                                value.isNotEmpty) {
                              widget.errorText = "Numero on virheellinen";
                            } else {
                              widget.errorText = "";
                            }
                            setState(() {});
                          },
                          onFieldSubmitted: (value) async {
                            if (widget.errorText != "") return;

                            focusNode.unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                            Application()
                                .addLoadingMessage("Lähetetään tekstiviestiä");
                            await verifyUserPhoneNumber(
                                context, phoneInputController.value.text);
                          },
                        ),
                      ),
                    )
                  ],
                )),
          ] else ...[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                widget.errorCode,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
            PinPanel(
              callback: (code) async {
                FocusManager.instance.primaryFocus?.unfocus();
                Application().addLoadingMessage("Vahvistetaan koodia");
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.id, smsCode: code);

                try {
                  await FirebaseAuth.instance.currentUser!
                      .reauthenticateWithCredential(credential);
                  await UsersProvider()
                      .removeUser(context.read<ListBloc>().state.created);
                  context.go('/');
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    widget.errorCode = "Tapahtui virhe. Tarkista koodi.";
                  });
                }

                Application().stopLoading();
              },
            ),
          ],
          const Spacer(),
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(40),
              child: Text('Palaa profiilin', style: TextStyle(fontSize: 20)),
            ),
            onTap: () {
              print('info page');
              context.pop();
            },
          )
        ],
      ),
    ));
  }
}
