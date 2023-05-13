import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:kutsu/singletons/activeuser.dart';
import 'package:kutsu/src/features/lists/lists.dart';
import 'package:kutsu/src/features/loading/views/views.dart';
import 'package:kutsu/src/features/login/login_screen.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingLayout(
              child: LoginScreen(),
            );
          }
          return LoadingLayout(
            child: HomeLayout(),
          );
        });
  }
}
