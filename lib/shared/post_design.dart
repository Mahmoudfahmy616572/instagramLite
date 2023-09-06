

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/firebase_services/fireStore.dart';
import 'package:instagram/screens/commentScreen.dart';
import 'package:instagram/shared/Colors.dart';
import 'package:instagram/shared/LikeAnimation.dart';
import 'package:intl/intl.dart';

class PostDesign extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const PostDesign({super.key, required this.data});

  @override
  State<PostDesign> createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
  bool isLikeAnimating = false;
  bool toggleHeart = false;
  int commentcount = 0;
  getCommentCount() async {
    try {
      QuerySnapshot commentData = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.data['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentcount = commentData.docs.length;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  showmodel() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              FirebaseAuth.instance.currentUser!.uid == widget.data['uid']
                  ? SimpleDialogOption(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.data['postId'])
                            .delete();
                      },
                      child: const Text('Delete post'),
                    )
                  : const SimpleDialogOption(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Can not delete this post ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getCommentCount();
  }

  @override
  Widget build(BuildContext context) {

    final double widthScreen = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: widthScreen > 600 ? widthScreen / 4 : 0, vertical: 12),
      // width: widthScreen/4,
      decoration: BoxDecoration(
          color: mobileBackgroundColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(widget.data['profileImg']),
                      ),
                    ),
                    Text(
                      widget.data['username'],
                      style: const TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    showmodel();
                  },
                  icon: const Icon(Icons.more_vert))
            ],
          ),
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLikeAnimating = true;
              });

              await FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.data['postId'])
                  .update({
                'likes': FieldValue.arrayUnion(
                    [FirebaseAuth.instance.currentUser!.uid])
              });
            },
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Image.network(
                  widget.data['imgPost'],
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.45,

                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                  },
                  // fit: BoxFit.cover,
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 111,
                    ),
                  ),
                ),
                toggleHeart
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 110,
                      )
                    : const Text('')
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 10, bottom: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeAnimation(
                      isAnimating: widget.data['likes']
                          .contains(FirebaseAuth.instance.currentUser!.uid),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          FirestoreMethods().toggeleLike(
                              mywidgetLikes: widget.data['likes'],
                              mywidgetPostId: widget.data['postId']);
                        },
                        icon: widget.data['likes'].contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                        data: widget.data,
                                      )));
                        },
                        icon: const Icon(Icons.chat_outlined)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.send_sharp)),
                  ],
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.bookmark_outline)),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              width: double.infinity,
              child: Text(
                'Liked by  ${widget.data['likes'].length}  person',
                style: const TextStyle(color: Colors.grey),
              )),
          Container(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              width: double.infinity,
              child: Text(
                "${widget.data['username']}   ${widget.data["description"]}",
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(208, 255, 255, 255)),
              )),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommentScreen(data: widget.data)));
            },
            child: Container(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                width: double.infinity,
                child: Text(
                  "view all $commentcount comments",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                )),
          ),
          Container(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              width: double.infinity,
              child: Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              )),
        ],
      ),
    );
  }
}
