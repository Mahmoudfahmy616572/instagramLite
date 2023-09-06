// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/screens/Home.dart';
import 'package:instagram/screens/add.dart';
import 'package:instagram/screens/favourite.dart';
import 'package:instagram/screens/profile.dart';
import 'package:instagram/screens/search.dart';
import 'package:instagram/shared/Colors.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  final PageController _pageController = PageController();
  int isIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          actions: [
            IconButton(
                onPressed: () {
                  _pageController.jumpToPage(0);
                },
                icon: Icon(
                  Icons.home,
                  color: isIndex == 0 ? primaryColor : secondaryColor,
                )),
            IconButton(
                onPressed: () {
                  _pageController.jumpToPage(1);
                },
                icon: Icon(
                  Icons.search,
                  color: isIndex == 1 ? primaryColor : secondaryColor,
                )),
            IconButton(
                onPressed: () {
                  _pageController.jumpToPage(0);
                },
                icon: Icon(
                  Icons.add_a_photo,
                  color: isIndex == 2 ? primaryColor : secondaryColor,
                )),
            IconButton(
                onPressed: () {
                  _pageController.jumpToPage(3);
                },
                icon: Icon(
                  Icons.favorite_outline,
                  color: isIndex == 3 ? primaryColor : secondaryColor,
                )),
            IconButton(
                onPressed: () {
                  _pageController.jumpToPage(4);
                },
                icon: Icon(
                  Icons.person,
                  color: isIndex == 4 ? primaryColor : secondaryColor,
                )),
          ],
          title: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: SvgPicture.asset('assets/images/instagram-text-icon.svg',
                height: 32, color: primaryColor),
          ),
        ),
        body: PageView(
          onPageChanged: (index) {
            setState(() {
              isIndex = index;
            });
          },
          controller: _pageController,
          children: [
            const Home(),
            const Search(),
            const Add(),
            const Favourite(),
            Profile(
              uiddd: FirebaseAuth.instance.currentUser!.uid,
            )
          ],
        ));
  }
}
