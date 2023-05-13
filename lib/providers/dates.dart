import 'dart:convert';

import 'package:collection/src/iterable_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import 'package:flutter/material.dart';
import 'package:kutsu/providers/providers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatesProvider extends ChangeNotifier {
  DatesProvider() {}

  late final _directory;
  int _cacheIndex = 0;
  int _userIndex = 0;
  List<app.Date> _cache = List<app.Date>.filled(1000, app.Date.empty());

  void init() async {
    _directory = await getApplicationDocumentsDirectory();
  }

  Future<app.Date?> getDate(String refId) async {
    if (_cacheIndex >= 1000) _cacheIndex = 0;

    app.Date? date = _cache.firstWhereOrNull(
      (element) => element.refId == refId,
    );

    if (date == null) {
      final userRef =
          await FirebaseFirestore.instance.collection('dates').doc(refId).get();

      final data = userRef.data() as Map<String, dynamic>;
      date = app.Date(
          refId: refId,
          userId: data['userId'],
          label: data['label'],
          text: data['text']);
      storeDate(_cacheIndex, date);

      _cache[_cacheIndex] = date;
      _cacheIndex++;
    }

    return date;
  }

  Future<void> storeDate(int cacheIndex, app.Date date) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final file = await File('${appDocumentsDir.path}/dates/$cacheIndex.json')
        .create(recursive: true);
    await file.writeAsString(jsonEncode(date.toJson()));
  }

  Future<void> initCache() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final Directory dateDir = Directory(appDocumentsDir.path + '/dates');
    await dateDir.create(recursive: true);

    dateDir.list(recursive: true).forEach(
      (element) {
        File file = File(element.path);
        file.readAsString().then(
              (str) => {
                _cache[_cacheIndex++] = app.Date.fromJson(jsonDecode(str)),
              },
            );
      },
    );
  }

/*
  Future<void> initCache() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final Directory dateDir = Directory(appDocumentsDir.path + '/dates');
    dateDir.delete(recursive: true);
  }
  */

  Future<app.Date> addDate({String? label, String? text}) async {
    Map<String, dynamic> newDate = {
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "label": label,
      "text": text,
      "likes": []
    };

    final dateRef =
        await FirebaseFirestore.instance.collection('dates').add(newDate);
    final userRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"created.${dateRef.id}": ""});

    newDate['refId'] = dateRef.id;
    return app.Date.fromJson(newDate);
  }

  Future<void> removeDate(app.Date date, bool serverRemove) async {
    if (serverRemove) {
      await FirebaseFirestore.instance
          .collection('dates')
          .doc(date.refId)
          .delete();
    }

    final userRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final user = userRef.data() as Map<String, dynamic>;

    final created = {};

    if (FirebaseAuth.instance.currentUser!.uid == date.userId) {
      user['created'].forEach((key, value) {
        (key == date.refId) ? null : created[key] = value;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"created": created});
    } else {
      user['likes'].forEach((key, value) {
        (key == date.refId) ? null : created[key] = value;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"likes": created});
    }
  }

  Future<void> addLike(app.Date date) async {
    bool errorFlag = false;
    await FirebaseFirestore.instance.collection('dates').doc(date.refId).update(
      {
        "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      },
    ).onError((error, stackTrace) {
      print('error $error');
      errorFlag = true;
    });

    if (!errorFlag) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"likes.${date.refId}": ""});
    }
  }

  Future<void> removeLike(app.Date date) async {
    await FirebaseFirestore.instance
        .collection('dates')
        .doc(date.refId)
        .update({
      "likes": FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
    }).onError((error, stackTrace) {
      print('error: $error');
    });

    final userRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final liked = {};
    final user = userRef.data() as Map<String, dynamic>;

    user['likes'].forEach((key, value) {
      if (key != date.refId) {
        liked[key] = "";
      }
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"likes": liked});
  }
}
