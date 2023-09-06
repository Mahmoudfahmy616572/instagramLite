import 'package:flutter/widgets.dart';
import 'package:instagram/firebase_services/Auth.dart';
import 'package:instagram/models/user.dart';

class UserProvider with ChangeNotifier {
  UserData? _userData;
  UserData? get getUser => _userData;

  refreshUser() async {
    UserData userData = await AuthMethod().getUserDetails();
    _userData = userData;

    notifyListeners();
  }
}
