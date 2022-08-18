import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  final String profileImg;
  final String username;
  final String description;
  final String imgPost;
  final String uid;
  final String postId;
  final DateTime datePublished;
  final List likes;

  PostData(
      {required this.profileImg,
      required this.username,
      required this.description,
      required this.imgPost,
      required this.uid,
      required this.postId,
      required this.datePublished,
      required this.likes});

// To convert the UserData(Data type) to   Map<String, Object>
  Map<String, dynamic> convert2Map() {
    return {
      "profileImg": profileImg,
      "username": username,
      "description": description,
      "imgPost": imgPost,
      "uid": uid,
      "postId": postId,
      "datePublished": datePublished,
      "likes": likes,
 
    };
  }

  // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostData(
      profileImg: snapshot["profileImg"],
      username: snapshot["username"],
      description: snapshot["description"],
      imgPost: snapshot["imgPost"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      likes: snapshot["likes"],
 
    );
  }
}
