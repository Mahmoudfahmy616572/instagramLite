// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/firebase_services/fireStore.dart';
import 'package:instagram/shared/Colors.dart';
import 'package:instagram/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final Map data;
  const CommentScreen({super.key, required this.data});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool showmore = false;
  bool isFavourite = false;
  final commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text(
            "Comment",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.data['postId'])
              .collection('comments')
              .orderBy('commentDate', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.white,
              );
            }

            return Expanded(
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(data['profileImg']),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data['userName'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  DateFormat.yMMMd()
                                      .add_jm()
                                      .format(data['commentDate'].toDate()),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 80, top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    data['CommentText'],
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isFavourite = !isFavourite;
                                });
                              },
                              icon: Icon(isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border)),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10, bottom: 20),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userData!.profileImage),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: "comment for ${widget.data['username']}",
                    hintStyle:
                        const TextStyle(color: Color.fromARGB(255, 114, 114, 114)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        await FirestoreMethods().getCommentData(
                          mycommentController: commentController.text,
                          mywidget: widget.data['postId'],
                          myUserDataProfileimg: userData.profileImage,
                          myUserDataUid: userData.uid,
                          myUserDataUsername: userData.username,
                        );
                        commentController.clear();
                      },
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }
}


  // if (commentController.text.isNotEmpty) {
  //                         String commentId = const Uuid().v1();
  //                         await FirebaseFirestore.instance
  //                             .collection('posts')
  //                             .doc(widget.data['postId'])
  //                             .collection('comments')
  //                             .doc('commentId')
  //                             .set({
  //                           'profileImg': userData.profileImage,
  //                           'userName': userData.username,
  //                           'CommentText': commentController.text,
  //                           'commentDate': DateTime.now(),
  //                           'uid': userData.uid,
  //                           'commentId': commentId
  //                         });
  //                         commentController.clear();
  //                       } else {
  //                         print("empty");
  //                       }