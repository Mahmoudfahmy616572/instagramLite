// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/firebase_services/storage.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/shared/snackbar.dart';

class AuthMethod {
  registeration({
    required email,
    required password,
    required username,
    required bio,
    required context,
    required imageName,
    required imgPath,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String myUrl = await getImageUrl(
          imageName: imageName, imgPath: imgPath, folderName: "profileImge");

      CollectionReference users =
          FirebaseFirestore.instance.collection('usersss');
      UserData userData = UserData(
          email: email,
          password: password,
          username: username,
          bio: bio,
          profileImage: myUrl,
          uid: credential.user!.uid,
          followers: [],
          following: []);
      users
          .doc(credential.user!.uid)
          .set(userData.convert2Map())
          .then((value) => showSnackBar(context, 'user added'))
          .catchError(
              (error) => showSnackBar(context, 'Failed to merge data: $error'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'Weak Password');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email');
      }
    } catch (e) {
      print(e);
    }
  }

  loginCode(
      {required emailController,
      required passwordController,
      required context}) async {
    try {
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Wrong password provided for that user.');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<UserData> getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('usersss')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return UserData.convertSnap2Model(snap);
  }
}
