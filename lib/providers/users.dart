import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:kutsu/singletons/application.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import 'package:kutsu/src/classes/filters.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UsersProvider {
  static final UsersProvider _singleton = UsersProvider._internal();
  Map<String, app.User> cache = {};

  Future<void> createUser() async {
    /// Location is missing
    final newUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(<String, dynamic>{
      "name": "nimi?",
      "age": 18,
      "gender": "male",
      "text": "",
      "id": FirebaseAuth.instance.currentUser!.uid,
      "created": {},
      "likes": {},
      "filters": {"age": 10, "gender": "female", "distance": 100},
      "location": {"latitude": 0.0, "longitude": 0.0}
    });
  }

  Future<app.User?> getUser(String refId) async {
    if (cache.keys.contains(refId)) {
      return cache[refId];
    }

    final userRef =
        await FirebaseFirestore.instance.collection('users').doc(refId).get();

    final data = userRef.data() as Map<String, dynamic>;
    app.User user = app.User(
        userID: refId,
        name: data['name'],
        age: data['age'],
        gender: data['gender'],
        text: data['text'],
        location: app.Location(latitude: 0, longitude: 0),
        filters: Filters(gender: "male", age: 18, distance: 100));

    cache[refId] = user;

    return user;
  }

  Future<void> removeUser(Map<String, String> list) async {
    if (list.isNotEmpty) {
      list.forEach(
        (key, value) async {
          try {
            await FirebaseFirestore.instance
                .collection('dates')
                .doc(key)
                .delete();
          } on FirebaseException catch (e) {
            print('date error: $e');
          }

          try {
            if (value != "") {
              await FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(value)
                  .delete();
            }
          } on FirebaseException catch (e) {
            print('room error: $e');
          }
        },
      );
    }

    try {
      await FirebaseStorage.instance
          .ref('images/${FirebaseAuth.instance.currentUser!.uid}')
          .delete();
    } on FirebaseException catch (e) {}

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
    } on FirebaseException catch (e) {
      print('user error: $e');
    }

    await FirebaseAuth.instance.currentUser!.delete();
  }

  Future<List<String>> getDateLikesList(String dateID) async {
    List<String> list = [];
    final userRef =
        await FirebaseFirestore.instance.collection('dates').doc(dateID).get();

    final userList = userRef.data() as Map<String, dynamic>;
    list = List.from(userList['likes']);

    return list;
  }

  factory UsersProvider() {
    return _singleton;
  }

  UsersProvider._internal();
}
