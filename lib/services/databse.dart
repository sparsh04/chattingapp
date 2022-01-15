import 'package:chattingapp/helperfunctions/sharedpref_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import "dart:core";
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:image_picker/image_picker.dart';
//import 'dart:io' as i;
//import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  addUserInfoToDb(String userId, Map<String, dynamic> userinfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userinfoMap);
  }

  getUserData() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  submitthebug(String userid, Map<String, dynamic> bugmap) async {
    return FirebaseFirestore.instance
        .collection("bugs")
        .doc(userid)
        .set(bugmap);
  }

  submittheFeedback(String userid, Map<String, dynamic> feedbackmap) async {
    return FirebaseFirestore.instance
        .collection("Feedback")
        .doc(userid)
        .set(feedbackmap);
  }

  updatestatus(String status, String userid) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .update({"status": status});
  }

  updateimage(String img, String currentuser) async {
    updateuserimage(img);

    return FirebaseFirestore.instance
        .collection("users")
        .doc(currentuser)
        .update({"imgUrl": img});
  }

  updateuserimage(String img) async {
    User? currentuser = _auth.currentUser;
    currentuser!.updatePhotoURL(img);
  }

  updateusercredentials(
      String name, String img, String email, String password) async {
    User? currentuser = _auth.currentUser;
    currentuser!.updatePhotoURL(img);
    currentuser.updateDisplayName(name);
    currentuser.updateEmail(email);
    currentuser.updatePassword(password);
  }

  Stream<QuerySnapshot> getUserByName(String username) {
    Stream<QuerySnapshot> user = FirebaseFirestore.instance
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: username)
        .snapshots();
    return user;
  }

//for getting the uid of the paticular user

  Future addMessage(String? chatRoomId, String? messageId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfo) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfo);
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapshot.exists) {
      return true;
      //it means the chatroom exits and there is no need to create another one
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRoomImages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .where("type", isEqualTo: "img")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String? myUsername = await SharedPreferncehelper().getUSerName();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastmessagets", descending: true)
        .where("users", arrayContains: myUsername)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String? username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  // Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getUserInfosnap(String? username) async {
  //   return  FirebaseFirestore.instance
  //       .collection("users")
  //       .where("username", isEqualTo: username)
  //       .snapshots();
  // }

  Stream<QuerySnapshot> getUserInfosnap(String username) {
    Stream<QuerySnapshot> user = FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
    return user;
  }

  Future<QuerySnapshot> getUserInfoforsettings(String? name) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .get();
  }

  //for the signup button
  uploadUserInfo(userMap) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .set(userMap);
    // return await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(_auth.currentUser!.uid)
    //     .update({'uid': _auth.currentUser!.uid});
  }
}
