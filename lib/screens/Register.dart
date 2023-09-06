// ignore_for_file: use_build_context_synchronously, file_names
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Resposive.dart';
import 'package:instagram/appScreen.dart';
import 'package:instagram/firebase_services/Auth.dart';
import 'package:instagram/screens/Login.dart';
import 'package:instagram/shared/snackbar.dart';
import 'package:instagram/webScreen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isloading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  final bioController = TextEditingController();
  uploadImage(ImageSource choosedPhoto) async {
    final XFile? pickedImg =
        await ImagePicker().pickImage(source: choosedPhoto);
    try {
      if (pickedImg != null) {
        imgPath = await pickedImg.readAsBytes();

        setState(() {
          // imgPath = File(pickedImg.path);

          int random = Random().nextInt(9999999);
          imageName = "$random$imageName";
        });
      } else {
        showSnackBar(context, "NO img selected");
      }
    } catch (e) {
      showSnackBar(context, "Error => $e");
    }
  }

  Uint8List? imgPath;
  String? imageName;
  bool isVisibility = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 1, 16, 28),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: widthScreen > 600
                  ? EdgeInsets.symmetric(
                      horizontal: widthScreen / 5, vertical: 0)
                  : const EdgeInsets.all(0),
              child: Column(
                children: [
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
                                    shape: BoxShape.circle, color: Colors.grey),
                                child: imgPath == null
                                    ? const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage: AssetImage(
                                            "assets/images/user.png"),
                                        radius: 80)
                                    : CircleAvatar(
                                        backgroundImage: MemoryImage(imgPath!),
                                        radius: 80)),
                            Positioned(
                                top: 115,
                                left: 110,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green),
                                  child: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            25.0))),
                                            builder: (BuildContext context) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(22),
                                                color: const Color.fromARGB(
                                                    255, 4, 44, 76),
                                                height: 200,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                          .blue[
                                                                      500]),
                                                          child: IconButton(
                                                              onPressed: () {
                                                                uploadImage(
                                                                    ImageSource
                                                                        .gallery);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(Icons
                                                                  .add_photo_alternate)),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        const Text(
                                                          "Gallary",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 22,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                          .blue[
                                                                      500]),
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await uploadImage(
                                                                    ImageSource
                                                                        .camera);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(Icons
                                                                  .add_a_photo_outlined)),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        const Text(
                                                          "Camera",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            isScrollControlled: true);
                                      },
                                      color: Colors.white,
                                      icon:
                                          const Icon(Icons.add_a_photo_sharp)),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            return value!.isEmpty ? "can not be empty" : null;
                          },
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(9)),
                            labelText: "UserName",
                            labelStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(Icons.person),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(9)),
                          ),
                        ),
                        const SizedBox(
                          height: 33,
                        ),
                        TextFormField(
                          validator: (email) {
                            return email!.contains((RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")))
                                ? null
                                : "Enter a valid email";
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(9)),
                            labelText: "Email",
                            labelStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(Icons.email),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(9)),
                          ),
                        ),
                        const SizedBox(
                          height: 33,
                        ),
                        TextFormField(
                          onChanged: (password) {
                            // onPasswordChange(password);
                          },
                          validator: (value) {
                            return value!.length < 8
                                ? "Enter at least 8 characters"
                                : null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isVisibility ? true : false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(9)),
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisibility = !isVisibility;
                                      });
                                    },
                                    icon: isVisibility
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(9)),
                          ),
                        ),
                        const SizedBox(
                          height: 33,
                        ),
                        TextFormField(
                          validator: (value) {
                            return value!.isEmpty ? "can not be empty" : null;
                          },
                          controller: bioController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(9)),
                            labelText: "Bio",
                            labelStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(Icons.pentagon),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(9)),
                          ),
                        ),
                        const SizedBox(
                          height: 33,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              imgPath != null &&
                              imageName != null) {
                            setState(() {
                              isloading = true;
                            });
                            await AuthMethod().registeration(
                              email: emailController.text,
                              password: passwordController.text,
                              username: usernameController.text,
                              context: context,
                              imageName: imageName,
                              imgPath: imgPath,
                              bio: bioController.text,
                            );
                            setState(() {
                              isloading = false;
                            });
                            if (!mounted) return;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Resposive(
                                        mywebScreen: WebScreen(),
                                        myAppscreen: AppScreen())));
                          } else {
                            showSnackBar(context, "Add image first!");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            )),
                        child: isloading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "signup",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                              );
                            },
                            child: const Text('sign in',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontSize: 18))),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
