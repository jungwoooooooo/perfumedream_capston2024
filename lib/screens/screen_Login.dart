import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/model_Login.dart';
import '../models/model_auth.dart';
import '../models/user_model/user_login_model.dart';
import '../service/LoginService.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(title: Text('Sign In',
          style: TextStyle(
          fontWeight: FontWeight.bold, // 더 두껍게 만들기
        ),),),
        body: SingleChildScrollView( // Wrap with SingleChildScrollView
          child: Column(
            children: [
              EmailInput(),
              PasswordInput(),
              LoginButton(),
              RegisterButton(),
              Padding(
                padding: EdgeInsets.all(10),
                child: Divider(
                  thickness: 1,
                ),
              ),
              // 아이디 찾기 버튼
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/id_recovery');
                },
                child: Text(
                  'Forget ID?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              // 비밀번호 찾기 버튼
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/password_recovery');
                },
                child: Text(
                  'Forget Password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class IdInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final login = Provider.of<LoginModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        onChanged: (id) {
          login.setId(id);
        },
        decoration: InputDecoration(
          labelText: '아이디',
          helperText: '',
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final login = Provider.of<LoginModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        onChanged: (email) {
          login.setEmail(email);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'ID',
          helperText: '',
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final login = Provider.of<LoginModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        onChanged: (password) {
          login.setPassword(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          helperText: '',
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient =
    Provider.of<FirebaseAuthProvider>(context, listen: false);
    final login = Provider.of<LoginModel>(context, listen: false);

    LoginService loginService = LoginService();

    TextEditingController id = TextEditingController();
    TextEditingController password = TextEditingController();

    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ), backgroundColor: Colors.black, // 배경색을 검은색으로 설정
        ),
        onPressed: () async {
          id.text = login.id;
          password.text = login.password;

          await authClient
              .loginWithEmail(login.email, login.password)
              .then((loginStatus) {
            if (loginStatus == AuthStatus.loginSuccess) {
              loginService.saveMember(User(
                id: id.text,
                password: password.text,
              ));

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content:
                    Text('환영합니다 ! ' + authClient.user!.email! + ' ')));
              Navigator.pushReplacementNamed(context, '/index');
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('로그인 실패 !!')));
            }
          });
        },
        child: Text(
          'Sing In',
          style: TextStyle(color: Colors.white), // 글씨색을 흰색으로 설정
        ),
      ),
    );
  }
}


class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0), // 버튼 위에 10.0만큼 간격 추가
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.blue), // 테두리 파란색으로 설정
            ), backgroundColor: Colors.white, // 배경색을 흰색으로 설정
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/register');
          },
          child: Text(
            '회원가입 하러 가기',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}



