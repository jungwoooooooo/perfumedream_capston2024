// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class IdRecoveryScreen extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController emailController = TextEditingController();
//
//     return Scaffold(
//       appBar: AppBar(title: Text('아이디 찾기')),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('가입 시 등록한 이메일 주소를 입력하세요.'),
//             SizedBox(height: 20),
//             TextField(
//               controller: emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: '이메일',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   String email = emailController.text.trim();
//                   await _auth.sendPasswordResetEmail(email: email);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('이메일을 확인하여 아이디를 찾으세요.'),
//                     ),
//                   );
//                 } catch (e) {
//                   print("Failed to send reset email: $e");
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('이메일 전송에 실패했습니다.'),
//                     ),
//                   );
//                 }
//               },
//               child: Text('이메일 전송'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
