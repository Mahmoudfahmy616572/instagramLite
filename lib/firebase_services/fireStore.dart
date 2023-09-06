// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/firebase_services/storage.dart';
import 'package:instagram/models/posts.dart';
import 'package:instagram/shared/snackbar.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  uploadPost(
      {required imgName,
      required imgPath,
      required description,
      required profileImg,
      required username,
      required context}) async {
    String message = "ERROR => Not starting the code";

    try {
// ______________________________________________________________________

      String urlll = await getImageUrl(
          imageName: imgName,
          imgPath: imgPath,
          folderName: 'PostsImage/${FirebaseAuth.instance.currentUser!.uid}');

// _______________________________________________________________________
// firebase firestore (Database)
      CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');
      String newId = const Uuid().v1();
      PostData postt = PostData(
          datePublished: DateTime.now(),
          description: description,
          imgPost: urlll,
          likes: [],
          profileImg: profileImg,
          postId: newId,
          uid: FirebaseAuth.instance.currentUser!.uid,
          username: username);

      message = "ERROR => erroe here";
      posts
          .doc(newId)
          .set(postt.convert2Map())
          .then((value) => print("done................"))
          .catchError((error) => print("Failed to post: $error"));

      message = " Posted successfully ♥ ♥";
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    }

    showSnackBar(context, message);
  }

  getCommentData(
      {required mycommentController,
      required mywidget,
      required myUserDataProfileimg,
      required myUserDataUsername,
      required myUserDataUid}) async {
    if (mycommentController.isNotEmpty) {
      String commentId = const Uuid().v1();
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(mywidget)
          .collection('comments')
          .doc(commentId)
          .set({
        'profileImg': myUserDataProfileimg,
        'userName': myUserDataUsername,
        'CommentText': mycommentController,
        'commentDate': DateTime.now(),
        'uid': myUserDataUid,
        'commentId': commentId
      });
    } else {}
  }

  toggeleLike({
    required mywidgetLikes,
    required mywidgetPostId,
  }) async {
    try {
      if (mywidgetLikes.contains(FirebaseAuth.instance.currentUser!.uid)) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(mywidgetPostId)
            .update({
          'likes':
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(mywidgetPostId)
            .update({
          'likes':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
