// models/model_register.dart
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  String email = "";
  String password = "";
  String verifyPassword = "";
  String id = "";
  String name = "";
  String phone = "";

  String age = "";
  String detailAddr = "";
  String jibunAddr = "";
  String roadAddr = "";
  String zipcode = "";

  void setZipcode(String zipcode) {
    this.zipcode = zipcode;
    notifyListeners();
  }

  void setRoadAddr(String roadAddr) {
    this.roadAddr = roadAddr;
    notifyListeners();
  }

  void setJibunAddr(String jibunAddr) {
    this.jibunAddr = jibunAddr;
    notifyListeners();
  }

  void setDetailAddr(String detailAddr) {
    this.detailAddr = detailAddr;
    notifyListeners();
  }

  void setAge(String age) {
    this.age = age;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setPhoneNumber(String phone) {
    this.phone = phone;
    notifyListeners();
  }

  void setId(String memberId) {
    this.id = memberId;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setVerifyPassword(String verifyPassword) {
    this.verifyPassword = verifyPassword;
    notifyListeners();
  }
}