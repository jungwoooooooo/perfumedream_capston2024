import 'dart:convert';
import 'package:http/http.dart' as http;

class PasswordCheckService {

  Future<void> findPasswordWithIdAndNameAndPhone(String id, String name,String phone) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8080/member/find-password"), // 실제 서버의 엔드포인트 URL로 변경
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id':id,'name': name, 'phone': phone}),
      );
      if (response.statusCode == 200) {
        // 요청이 성공적으로 처리됨
        var jsonResponse = jsonDecode(response.body);
        // 서버로부터 받은 응답 처리
        print(jsonResponse);
        // 응답을 어떻게 처리할지에 따라 적절한 로직을 구현하세요.
      } else {
        // 요청이 실패함
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      // 오류 발생
      print('Error sending request: $e');
    }
  }
}
