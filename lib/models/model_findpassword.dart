// model/model_login.dart
import 'package:flutter/material.dart';

class FindPasswordModel extends ChangeNotifier {
  String id = "";
  String name = "";
  String phone = "";

  void setId(String id) {
    this.id = id;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setPhone(String phone) {
    this.phone = phone;
    notifyListeners();
  }

}