// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/Home.dart';
import 'package:instagram/screens/add.dart';
import 'package:instagram/screens/favourite.dart';
import 'package:instagram/screens/profile.dart';
import 'package:instagram/screens/search.dart';

import 'shared/Colors.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int isIndex = 0;

  // @override
  // void initState() {
  //   _pageController.dispose();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CupertinoTabBar(
            backgroundColor: mobileBackgroundColor,
            onTap: (index) {
              _pageController.jumpToPage(index);
              setState(() {
                isIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: isIndex == 0 ? primaryColor : secondaryColor,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: isIndex == 1 ? primaryColor : secondaryColor,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_box_outlined,
                  color: isIndex == 2 ? primaryColor : secondaryColor,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_outline_outlined,
                  color: isIndex == 3 ? primaryColor : secondaryColor,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: isIndex == 4 ? primaryColor : secondaryColor,
                ),
              ),
            ]),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            isIndex = index;
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
