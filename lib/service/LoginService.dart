import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_model.dart';
import '../models/user_model/user_login_model.dart';
import '../screens/screen_item_list_page.dart';

class LoginService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveMember(User user) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8080/member/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Not-Using-Xquare-Auth': 'true',
        },
        body: jsonEncode(user.toJson()),
      );
      if (response.statusCode == 200) {
        print("User Data sent successfully");

        // 응답 헤더에서 토큰 추출
        String? authToken = response.headers['x-auth-token'];
        if (authToken != null) {
          print("Auth Token: $authToken");
          // 토큰을 안전하게 저장
          await _storage.write(key: 'authToken', value: authToken);

          Get.to(ItemListPage());
        } else {
          throw Exception("응답 헤더에서 Auth 토큰을 찾을 수 없음");
        }
      } else {
        throw Exception("데이터 전송 실패, 상태 코드: ${response.statusCode}");
      }
    } catch (e) {
      print("사용자 데이터 전송 실패: ${e}");
    }
  }
}
