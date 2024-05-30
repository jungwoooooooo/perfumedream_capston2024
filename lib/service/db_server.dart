import 'dart:convert';
import '../screens/screen_index.dart';
import 'user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<void> saveUser(User user) async {
  try {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8080/member"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to send data");
    } else {
      print("User Data sent successfully");
      Get.to(IndexScreen());
    }
  } catch (e) {
    print("Failed to send user data: ${e}");
  }
}