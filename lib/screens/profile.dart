

// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/shared/Colors.dart';

class Profile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final uiddd;
  const Profile({super.key, required this.uiddd});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isFollow = false;
  Map userData = {};
  bool isloading = true;
  int followers = 0;
  int following = 0;
  late int postsCount = 0;
  getData() async {
    setState(() {
      isloading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('usersss')
          .doc(widget.uiddd)
          .get();
      userData = snapshot.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      isFollow =
          userData['followers'].contain(FirebaseAuth.instance.currentUser!.uid);
      var snapshotPosts = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uiddd)
          .get();
      setState(() {
        postsCount = snapshotPosts.docs.length;
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return isloading
        ? Scaffold(
            backgroundColor:
                widthScreen > 600 ? webBackgroundColor : mobileBackgroundColor,
            body: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            backgroundColor:
                widthScreen > 600 ? webBackgroundColor : mobileBackgroundColor,
            appBar: widthScreen > 600
                ? null
                : AppBar(
                    backgroundColor: mobileBackgroundColor,
                    title: Text(
                      userData['name'],
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
            body: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: widthScreen > 600 ? widthScreen / 7 : 0,
                  vertical: 12),
              // width: widthScreen/4,
              decoration: BoxDecoration(
                  color: mobileBackgroundColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(userData['profileImage']),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(postsCount.toString()),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Posts",
                                      style: TextStyle(color: Colors.white70),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  children: [
                                    Text(followers.toString()),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Followers",
                                      style: TextStyle(color: Colors.white70),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  children: [
                                    Text(following.toString()),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "following",
                                      style: TextStyle(color: Colors.white70),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                    width: double.infinity,
                    child: Text(
                      userData['bio'],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  widget.uiddd == FirebaseAuth.instance.currentUser!.uid
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.only(left: 65, right: 65)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(170, 68, 67, 67))),
                              onPressed: () {},
                              child: const Text("Edit Profile"),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.only(left: 65, right: 65)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(170, 68, 67, 67))),
                              onPressed: () {},
                              child: const Text("Logout"),
                            ),
                          ],
                        )
                      : isFollow
                          ? ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.only(left: 65, right: 65)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(170, 68, 67, 67))),
                              onPressed: () {
                                followers--;

                                setState(() {
                                  isFollow = false;
                                });
                                FirebaseFirestore.instance
                                    .collection('usersss')
                                    .doc(widget.uiddd)
                                    .update({
                                  'followers': FieldValue.arrayRemove(
                                      [FirebaseAuth.instance.currentUser!.uid])
                                });

                                FirebaseFirestore.instance
                                    .collection('usersss')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  'following':
                                      FieldValue.arrayRemove([widget.uiddd])
                                });
                              },
                              child: const Text(
                                'unfollow',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ))
                          : ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.only(left: 65, right: 65)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue)),
                              onPressed: () {
                                followers++;

                                setState(() {
                                  isFollow = true;
                                });
                                FirebaseFirestore.instance
                                    .collection('usersss')
                                    .doc(widget.uiddd)
                                    .update({
                                  'followers': FieldValue.arrayUnion(
                                      [FirebaseAuth.instance.currentUser!.uid])
                                });

                                FirebaseFirestore.instance
                                    .collection('usersss')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  'following':
                                      FieldValue.arrayUnion([widget.uiddd])
                                });
                              },
                              child: const Text(
                                'Follow',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                  const SizedBox(
                    height: 30,
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uiddd)
                        .get(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        return Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 3,
                                    childAspectRatio: 3 / 2,
                                    mainAxisSpacing: 3),
                            itemBuilder: (BuildContext context, int index) {
                              return GridTile(
                                  child: Image.network(
                                      snapshot.data!.docs[index]["imgPost"],
                                      fit: BoxFit.cover, loadingBuilder:
                                          (context, child, progress) {
                                return progress == null
                                    ? child
                                    : const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      );
                              }));
                            },
                            itemCount: snapshot.data!.docs.length,
                          ),
                        );
                      }

                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
                    },
                  )
                ]),
              ),
            ),
          );
  }
}
