import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String username;
  String email;
  String password;
  String profileImage;
  String bio;
  String uid;
  List followers = [];
  List following = [];
  UserData({
    required this.username,
    required this.email,
    required this.password,
    required this.profileImage,
    required this.uid,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> convert2Map() {
    return {
      'name': username,
      'email': email,
      'password': password,
      'profileImage': profileImage,
      'bio': bio,
      'uid': uid,
      'following': [],
      'followers': [],
    };
  }

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
      email: snapshot['email'],
      password: snapshot['password'],
      username: snapshot['name'],
      bio: snapshot['bio'],
      following: snapshot['following'],
      followers: snapshot['followers'],
      profileImage: snapshot['profileImage'],
      uid: snapshot['uid'],
    );
  }
}
