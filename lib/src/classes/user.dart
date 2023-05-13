import 'package:equatable/equatable.dart';
import 'date.dart';
import 'dart:io';
import 'dart:typed_data';
import 'filters.dart';

class User {
  User(
      {required this.userID,
      required this.name,
      required this.age,
      required this.text,
      required this.gender,
      required this.filters,
      required this.location}) {}

  User.empty()
      : name = "name",
        age = 18,
        gender = "male",
        text = "",
        userID = "",
        filters = Filters(gender: "male", age: 18, distance: 100),
        location = Location(latitude: 0, longitude: 0);

  copy({required User user}) {
    User copy = User(
        userID: user.userID,
        name: user.name,
        age: user.age,
        text: user.text,
        gender: user.gender,
        filters: user.filters,
        location: user.location);

    copy.filters = Filters(
        gender: user.filters.gender,
        age: user.filters.age,
        distance: user.filters.distance);

    return copy;
  }

  String userID;
  String name;
  int age;
  String text;
  String gender;
  Filters filters;
  Location location;
}

class Location {
  Location({required this.latitude, required this.longitude});
  double latitude;
  double longitude;
}
