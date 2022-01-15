import 'package:chattingapp/helperfunctions/sharedpref_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
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

  Stream<QuerySnapshot> getUserByName(String username) {
    Stream<QuerySnapshot> user = FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
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

  Future<QuerySnapshot> getUserInfoforsettings(String? name) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .get();
  }

  //for the signup button
  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  //image storgae here

  // Reference? _storagerefernce;

  // Future<String>? uploadImageToStorage(XFile image) async {
  //   _storagerefernce =
  //       storage.ref().child('${DateTime.now().millisecondsSinceEpoch}');

  //   UploadTask _storgaeuploadtask =
  //       _storagerefernce!.putFile(i.File(image.path));

  //   var url;

  //   _storgaeuploadtask.whenComplete(() => {
  //         url = _storagerefernce?.getDownloadURL(),
  //       });
  //   return url;
  // }

  // void setImageMsg(String url, String receiverId, String senderId) async {
  //   Message _message;

  //   _message = Message.

  // }

//   void uploadImage(XFile image, String receiverid, String senderId) async {
//     String? url = await uploadImageToStorage(image);
//   }
// }
}
