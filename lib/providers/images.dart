import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'dart:io';

class ImagesProvider extends ChangeNotifier {
  Map<String, String> cache = {};

  void init() {}

  Future<String> getProfileImage(String userID) async {
    if (cache.keys.contains(userID) &&
        FirebaseAuth.instance.currentUser!.uid != userID) {
      return cache[userID].toString();
    }

    final storageRef = FirebaseStorage.instance.ref();
    String imageURL = "";

    try {
      imageURL = await storageRef.child("images/$userID").getDownloadURL();
    } on FirebaseException catch (e) {
      return "";
    }

    cache[userID] = imageURL;
    return imageURL;
  }

  Future<String> setProfileImage(File path) async {
    final compressedImage = await compressImage(path);
    final storageRef = FirebaseStorage.instance.ref();
    final userRef =
        storageRef.child('images/${FirebaseAuth.instance.currentUser!.uid}');

    try {
      final result = await userRef.putFile(
          compressedImage, SettableMetadata(contentType: "image/jpeg"));
      return result.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print('error: $e');
    }

    return "";
  }

  Future<File> compressImage(File path) async {
    final compressedFile =
        await FlutterNativeImage.compressImage(path.path, quality: 50);

    return compressedFile;
  }

  Future<void> deleteProfileImage() async {
    try {
      await FirebaseStorage.instance
          .ref('images/${FirebaseAuth.instance.currentUser!.uid}')
          .delete();
    } on FirebaseException catch (e) {}
  }
}
