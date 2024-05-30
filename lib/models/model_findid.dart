import 'package:flutter/material.dart';

class FindIdModel extends ChangeNotifier {
  String name = "";
  String email = "";

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }
}