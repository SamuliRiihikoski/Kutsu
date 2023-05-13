import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Application {
  static final Application _singleton = Application._internal();

  factory Application() {
    return _singleton;
  }

  Application._internal();

  int changeTabIndex = 0;
  bool newUserLogged = false;
  late PhoneAuthCredential credential;
  StreamController<String> loadingController = StreamController<String>();

  void addLoadingMessage(String message) {
    loadingController.add(message);
  }

  void stopLoading() {
    loadingController.add("");
  }
}
