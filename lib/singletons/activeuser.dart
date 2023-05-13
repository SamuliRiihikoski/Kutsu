import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import 'package:kutsu/src/classes/filters.dart';
import 'package:location/location.dart';

class ActiveUser {
  static final ActiveUser _singleton = ActiveUser._internal();
  DocumentSnapshot? documentSnapshot;
  app.User? user;
  app.User? widgetUser;

  factory ActiveUser() {
    return _singleton;
  }

  Future<void> initUser() async {
    user = await currentUserFromServer();
    widgetUser = app.User(
        userID: user!.userID,
        name: user!.name,
        age: user!.age,
        text: user!.text,
        gender: user!.gender,
        location: app.Location(
            latitude: user!.location.latitude,
            longitude: user!.location.longitude),
        filters: Filters(
            gender: user!.filters.gender,
            age: user!.filters.age,
            distance: user!.filters.distance));
  }

  Future<app.User> getUser() async {
    return widgetUser!;
  }

  Future<app.User> currentUserFromServer() async {
    final userRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final data = userRef.data() as Map<String, dynamic>;

    app.User user = app.User(
        userID: FirebaseAuth.instance.currentUser!.uid,
        name: data['name'],
        age: data['age'],
        gender: data['gender'],
        text: data['text'],
        location: app.Location(
            latitude: data['location']['latitude'],
            longitude: data['location']['longitude']),
        filters: app.Filters(
            age: data['filters']['age'],
            distance: data['filters']['distance'],
            gender: data['filters']['gender']));

    return user;
  }

  void updateWidgetUser(app.User us) {
    widgetUser = us;
    widgetUser!.filters.age = us.filters.age;
    widgetUser!.filters.distance = us.filters.distance;
    widgetUser!.filters.gender = us.filters.gender;
  }

  bool compareProfiles() {
    if (widgetUser!.name != ActiveUser().user!.name) return false;
    if (widgetUser!.age != ActiveUser().user!.age) return false;
    if (widgetUser!.gender != ActiveUser().user!.gender) return false;
    if (widgetUser!.text != ActiveUser().user!.text) return false;

    return true;
  }

  bool compareFilteres() {
    if (widgetUser!.filters.age != ActiveUser().user!.filters.age) return false;
    if (widgetUser!.filters.gender != ActiveUser().user!.filters.gender) {
      return false;
    }
    if (widgetUser!.filters.distance != ActiveUser().user!.filters.distance) {
      return false;
    }

    return true;
  }

  Future<void> setProfile() async {
    final location = await getLocation();

    if (location == null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "name": widgetUser!.name,
        "age": widgetUser!.age,
        "gender": widgetUser!.gender,
        "text": widgetUser!.text,
        "filters.age": widgetUser!.filters.age,
        "filters.gender": widgetUser!.filters.gender,
        "filters.distance": widgetUser!.filters.distance
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "name": widgetUser!.name,
        "age": widgetUser!.age,
        "gender": widgetUser!.gender,
        "text": widgetUser!.text,
        "filters.age": widgetUser!.filters.age,
        "filters.gender": widgetUser!.filters.gender,
        "filters.distance": widgetUser!.filters.distance,
        "location.latitude": location.latitude,
        "location.longitude": location.longitude
      });
    }

    ActiveUser().user!.name = widgetUser!.name;
    ActiveUser().user!.age = widgetUser!.age;
    ActiveUser().user!.gender = widgetUser!.gender;
    ActiveUser().user!.text = widgetUser!.text;
    ActiveUser().user!.filters.age = widgetUser!.filters.age;
    ActiveUser().user!.filters.gender = widgetUser!.filters.gender;
    ActiveUser().user!.filters.distance = widgetUser!.filters.distance;
    ActiveUser().user!.location.latitude = location!.latitude!;
    ActiveUser().user!.location.longitude = location.longitude!;
  }

  Future<LocationData?> getLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  bool userInDistance(double latitude, double longitude) {
    print('user.lati ${user!.location.latitude}');
    print('user.long ${user!.location.longitude}');

    double distance = user!.filters.distance * 0.00111;

    if (user!.location.latitude > (latitude + distance)) return false;
    if (user!.location.latitude < (latitude - distance)) return false;
    if (user!.location.longitude < (longitude - distance)) return false;
    if (user!.location.longitude > (longitude + distance)) return false;

    return true;
  }

  ActiveUser._internal();
}
