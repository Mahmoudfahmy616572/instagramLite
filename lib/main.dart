

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Resposive.dart';
import 'package:instagram/appScreen.dart';
import 'package:instagram/screens/Login.dart';
import 'package:instagram/shared/snackbar.dart';
import 'package:instagram/user_provider.dart';
import 'package:instagram/webScreen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return UserProvider();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              } else if (snapshot.hasError) {
                return showSnackBar(context, "Something went wrong");
              } else if (snapshot.hasData) {
                return const Resposive(
                    mywebScreen: WebScreen(), myAppscreen: AppScreen());
              } else {
                return const Login();
              }
            },
          ),
        ));
  }
}
