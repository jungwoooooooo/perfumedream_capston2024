import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mysql1/mysql1.dart';

class FindService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final smtpServer = gmail('cyjjw2@gmail.com', 'cyjbest!1');

  // MySQL 데이터베이스 연결 설정
  // Future<void> dbConnector() async {
  //   print("Connecting to mysql server...");
  //
  //   // MySQL 접속 설정
  //   final conn = await MySqlConnection.connect(ConnectionSettings(
  //     host: '10.0.2.2',
  //     port: 3306,
  //     user: 'root',
  //     password: '1234',
  //     db: 'testKING',
  //   ));
  //
  //   print("Connected");
  //
  // }

  // 이메일로 등록된 아이디 찾기
  Future<String?> findIdWithEmail(String email, String name) async {
    try {
      var result = await _auth.fetchSignInMethodsForEmail(email);
      if (result.isNotEmpty) {
        return result.first;
      } else {
        return null;
      }
    } catch (e) {
      print('아이디 찾기 오류: $e');
      return null;
    }
  }

  // 데이터베이스에서 사용자 정보를 가져와 이메일로 전송
  Future<bool> sendUserInfoByEmail(String email, String name) async {
    try {
      // 데이터베이스 연결 설정
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'root',
        password: '1234',
        db: 'testKING',
      ));

      // 데이터베이스에서 사용자 정보를 검색
      var results = await conn.query('SELECT * FROM users WHERE name = ?', [name]);

      await conn.close();

      if (results.isNotEmpty) {
        // 사용자 정보를 이메일로 전송
        var userInfo = results.first.fields; // 사용자 정보를 필드로 가져옴

        // 이메일 내용 설정
        final message = Message()
          ..from = Address('your_email@gmail.com', 'Your Name')
          ..recipients.add(email)
          ..subject = 'User Information'
          ..text = 'Here is the user information: $userInfo';

        // 이메일 전송
        final sendReport = await send(message, smtpServer);
        print('이메일 전송 결과: $sendReport');

        return true;
      } else {
        print('사용자를 찾을 수 없습니다.');
        return false;
      }
    } catch (e) {
      print('이메일 전송 오류: $e');
      return false;
    }
  }

  // 비밀번호 찾기 및 이메일로 비밀번호 전송
  Future<bool> sendPasswordByEmail(String email, String name, String phone) async {
    try {
      // 데이터베이스 연결 설정
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'root',
        password: '1234',
        db: 'testKING',
      ));

      // 데이터베이스에서 사용자의 비밀번호를 가져옴
      var results = await conn.query('SELECT password FROM users WHERE name = ?', [name]);

      await conn.close();

      if (results.isNotEmpty) {
        // 사용자의 비밀번호를 이메일로 전송
        var password = results.first[0]; // 사용자의 비밀번호
        final message = Message()
          ..from = Address('your_email@gmail.com', 'Your Name')
          ..recipients.add(email)
          ..subject = 'Your Password'
          ..text = 'Your password is: $password'; // 비밀번호를 평문으로 이메일로 전송
        final sendReport = await send(message, smtpServer);
        print('이메일로 비밀번호를 전송했습니다.');
        return true;
      } else {
        print('사용자를 찾을 수 없습니다.');
        return false;
      }
    } catch (e) {
      print('이메일 전송 오류: $e');
      return false;
    }
  }
}
