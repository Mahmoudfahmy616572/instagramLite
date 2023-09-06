
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/firebase_services/fireStore.dart';
import 'package:instagram/shared/Colors.dart';
import 'package:instagram/shared/snackbar.dart';
import 'package:instagram/user_provider.dart';
import 'package:provider/provider.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final description = TextEditingController();

  uploadImage(ImageSource choosedPhoto) async {
    final XFile? pickedImg =
        await ImagePicker().pickImage(source: choosedPhoto);
    try {
      if (pickedImg != null) {
        imgPath = await pickedImg.readAsBytes();

        setState(() {
          int random = Random().nextInt(9999999);
          imageName = "$random$imageName";
        });
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, "NO img selected");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, "Error => $e");
    }
  }

  Uint8List? imgPath;
  String? imageName;
  bool isPosted = false;

  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;
    return imgPath == null
        ? Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0))),
                              builder: (BuildContext context) {
                                return Container(
                                  padding: const EdgeInsets.all(22),
                                  color: const Color.fromARGB(255, 104, 104, 104),
                                  height: 200,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue[500]),
                                            child: IconButton(
                                                onPressed: () {
                                                  uploadImage(
                                                      ImageSource.gallery);

                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                    Icons.add_photo_alternate)),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "Gallary",
                                            style: TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 22,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue[500]),
                                            child: IconButton(
                                                onPressed: () async {
                                                  await uploadImage(
                                                      ImageSource.camera);
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(Icons
                                                    .add_a_photo_outlined)),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "Camera",
                                            style: TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              isScrollControlled: true);
                        },
                        icon: const Icon(
                          Icons.upload,
                          color: Colors.white,
                          size: 40,
                        ))
                  ]),
            ),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: IconButton(
                onPressed: () {
                  setState(() {
                    imgPath = null;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            isPosted = true;
                          });
                          await FirestoreMethods().uploadPost(
                              context: context,
                              description: description.text,
                              imgName: imageName,
                              profileImg: allDataFromDB!.profileImage,
                              imgPath: imgPath,
                              username: allDataFromDB.username);
                          setState(() {
                            isPosted = false;
                            imgPath = null;
                          });
                        },
                        child: const Text(
                          "Post",
                          style: TextStyle(color: Colors.blue, fontSize: 22),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                isPosted
                    ? const LinearProgressIndicator(
                        color: Colors.blue,
                      )
                    : const Divider(
                        height: 30,
                        thickness: 1,
                      ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(allDataFromDB!.profileImage)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          controller: description,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "write a\ncaption.. ",
                          ),
                        ),
                      ),
                      Container(
                        width: 66,
                        height: 74,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(imgPath!),
                                fit: BoxFit.cover)),
                      )
                    ]),
              ],
            ),
          );
  }
}
