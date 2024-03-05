import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_chat/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
//user list method

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firebase.collection('Users').snapshots().map((event) {
      return event.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverId, message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

//construct chat room id for the user (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //sor the ids (this ensure the chatroomId is the same for any 2 people )
    String chatRoomId = ids.join('_');

//add new message to firebase
    await _firebase
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String userId, otherUserId) {
    // construct a chatroom Id for the two users
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    log(chatRoomId);

    return _firebase
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        //The ids.join('_') method concatenates the sorted user
        //IDs into a single string with an underscore (_) as a separator,
        .orderBy('timestamp', descending: false)
        // This implies that the oldest messages will appear first,
        // and newer messages will appear later in the result set.
        .snapshots();
  }
}
