// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/shared/post_design.dart';


import '../shared/Colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    final double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor:
            widthScreen > 600 ? webBackgroundColor : mobileBackgroundColor,
        appBar: widthScreen > 600
            ? null
            : AppBar(
                backgroundColor: mobileBackgroundColor,
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.chat_outlined)),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(Icons.logout)),
                  ),
                ],
                title: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: SvgPicture.asset(
                      'assets/images/instagram-text-icon.svg',
                      height: 32,
                      color: primaryColor),
                ),
              ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return PostDesign(data: data);
              }).toList(),
            );
          },
        ));
  }
}
