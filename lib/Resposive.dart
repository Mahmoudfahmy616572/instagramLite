// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:instagram/user_provider.dart';
import 'package:provider/provider.dart';

class Resposive extends StatefulWidget {
  final mywebScreen;
  final myAppscreen;
  const Resposive(
      {super.key, required this.mywebScreen, required this.myAppscreen});

  @override
  State<Resposive> createState() => _ResposiveState();
}

class _ResposiveState extends State<Resposive> {
  getDataFromDB() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  void initState() {
    super.initState();
    getDataFromDB();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
    return LayoutBuilder(builder: ( BuildContext, Boxcnstraints) {
      if (Boxcnstraints.maxWidth > 600) {
        return widget.mywebScreen;
      } else {
        return widget.myAppscreen;
      }
    });
  }
}
