// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram/screens/Register.dart';
import 'package:instagram/screens/login2.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  File? imgPath;

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(196, 52, 20, 72),
        body: SingleChildScrollView(
          child: Padding(
            padding: widthScreen > 668
                ? EdgeInsets.symmetric(horizontal: widthScreen / 5, vertical: 0)
                : const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 10),
                      child: Image(
                        image: AssetImage(
                          "assets/images/instagram.png",
                        ),
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey),
                                  child: const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          AssetImage("assets/images/user.png"),
                                      radius: 80)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Mahmoud__Fahmy",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login2(),
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            )),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.08),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(22),
                            )),
                        child: const Text(
                          "log into anothor account",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                // --------------------------------------

                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()),
                            );
                          },
                          child: Row(
                            children: const [
                              Text("Have an account",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17)),
                              SizedBox(width: 10),
                              Text('signup',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                      fontSize: 18)),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
