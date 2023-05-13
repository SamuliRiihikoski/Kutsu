import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomsProvider extends ChangeNotifier {
  Future<String> createRoom(String dateID, friendID) async {
    final roomRef = await FirebaseFirestore.instance
        .collection('rooms')
        .add(<String, dynamic>{
      "userID": FirebaseAuth.instance.currentUser!.uid,
      "friendID": friendID,
      "messages": []
    });

    final updateUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"created.${dateID}": roomRef.id});

    final updateFriend = await FirebaseFirestore.instance
        .collection('users')
        .doc(friendID)
        .update({"likes.${dateID}": roomRef.id});

    return roomRef.id;
  }

  Future<void> deleteRoom(String roomID) async {
    print('DEleteing RoomID: ${roomID}');
    await FirebaseFirestore.instance.collection('rooms').doc(roomID).delete();
  }

  Future<List<Map<String, dynamic>>> getRoomMessages(
      String roomID, int startIndex) async {
    final roomRef =
        await FirebaseFirestore.instance.collection('rooms').doc(roomID).get();

    List<Map<String, dynamic>> list = List.from(roomRef['messages']);
    return list;
  }

  Future<void> addMessage(String roomID, String message) async {
    await FirebaseFirestore.instance.collection('rooms').doc(roomID).update({
      'messages': FieldValue.arrayUnion([
        {FirebaseAuth.instance.currentUser!.uid: message}
      ])
    });
  }
}
