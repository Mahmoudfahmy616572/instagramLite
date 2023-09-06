import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

getImageUrl(
    {required String imageName,
    required Uint8List imgPath,
    required String folderName}) async {
  final storageRef = FirebaseStorage.instance.ref('$folderName/$imageName');
  UploadTask uploadTask = storageRef.putData(imgPath);
  TaskSnapshot snap = await uploadTask;

  String imageUrl = await snap.ref.getDownloadURL();
  return imageUrl;
}
