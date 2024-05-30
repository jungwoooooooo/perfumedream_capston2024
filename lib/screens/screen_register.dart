import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/model_auth.dart';
import '../models/model_register.dart';
import '../models/user_model/user_model.dart';
import '../service/AuthService.dart';

class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up',
            style: TextStyle(
              fontWeight: FontWeight.bold, // 더 두껍게 만들기
            ),),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              IdInput(),
              NameInput(),
              EmailInput(),
              PhoneNumberInput(),
              PasswordInput(),
              VerifyPasswordInput(),
              RegistButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class AgeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(1),
      child: TextField(
        onChanged: (age) {
          register.setAge(age);
        },
        decoration: InputDecoration(
          labelText: '나이(숫자 기입)',
          helperText: '',
        ),
      ),
    );
  }
}

class DetailAddrInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(1),
      child: TextField(
        onChanged: (detailAddr) {
          register.setDetailAddr(detailAddr);
        },
        decoration: InputDecoration(
          labelText: '자세한 주소(ex 동, 호수)',
          helperText: '',
        ),
      ),
    );
  }
}

class JibunAddrInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(1),
      child: TextField(
        onChanged: (jibunAddr) {
          register.setJibunAddr(jibunAddr);
        },
        decoration: InputDecoration(
          labelText: '지번 주소',
          helperText: '',
        ),
      ),
    );
  }
}

class RoadAddrInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(1),
      child: TextField(
        onChanged: (roadAddr) {
          register.setRoadAddr(roadAddr);
        },
        decoration: InputDecoration(
          labelText: '도로명 주소',
          helperText: '',
        ),
      ),
    );
  }
}

class ZipcodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(1),
      child: TextField(
        onChanged: (zipcode) {
          register.setZipcode(zipcode);
        },
        decoration: InputDecoration(
          labelText: '우편번호',
          helperText: '',
        ),
      ),
    );
  }
}

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(1),
      child: TextField(
        onChanged: (name) {
          register.setName(name);
        },
        decoration: InputDecoration(
          labelText: 'Name',
          helperText: '',
        ),
      ),
    );
  }
}

class PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(1),
      child: TextField(
        onChanged: (phoneNumber) {
          register.setPhoneNumber(phoneNumber);
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          helperText: '',
        ),
      ),
    );
  }
}

class IdInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(1),
      child: TextField(
        onChanged: (id) {
          register.setId(id);
        },
        decoration: InputDecoration(
          labelText: 'ID',
          helperText: '',
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(1),
      child: TextField(
        onChanged: (email) {
          register.setEmail(email);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email Address',
          helperText: '',
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context);
    return Container(
      padding: EdgeInsets.all(1),
      child: TextField(
        onChanged: (password) {
          register.setPassword(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          helperText: '',
          errorText: register.password != register.verifyPassword
              ? 'Password incorrect'
              : null,
        ),
      ),
    );
  }
}

class VerifyPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(1),
      child: TextField(
        onChanged: (password) {
          register.setVerifyPassword(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          helperText: '',
        ),
      ),
    );
  }
}

class RegistButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient = Provider.of<FirebaseAuthProvider>(context, listen: false);
    final register = Provider.of<RegisterModel>(context);

    AuthService authService = AuthService();

    TextEditingController id = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController verifyPassword = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController phone = TextEditingController();

    TextEditingController age = TextEditingController();
    TextEditingController detail_addr = TextEditingController();
    TextEditingController jibun_addr = TextEditingController();
    TextEditingController road_addr = TextEditingController();
    TextEditingController zipcode = TextEditingController();

    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ), backgroundColor: Colors.black, // 버튼의 배경색을 검정으로 설정
        ),
        onPressed: (register.password != register.verifyPassword)
            ? null
            : () async {
          id.text = register.id; // register에서 id를 가져올 수 있어야 합니다.
          password.text = register.password;
          verifyPassword.text = register.verifyPassword;
          name.text = register.name;
          email.text = register.email;
          phone.text = register.phone;

          age.text = register.age;
          detail_addr.text = register.detailAddr;
          jibun_addr.text = register.jibunAddr;
          road_addr.text = register.roadAddr;
          zipcode.text = register.zipcode;

          await authClient
              .registerWithEmail(register.email, register.password)
              .then((registerStatus) {
            if (registerStatus == AuthStatus.registerSuccess) {
              authService.saveMember(Member(
                id: id.text,
                password: password.text,
                verifyPassword: verifyPassword.text,
                name: name.text,
                email: email.text,
                phone: phone.text,

                age: age.text,
                detailAddr: detail_addr.text,
                jibunAddr: jibun_addr.text,
                roadAddr: road_addr.text,
                zipcode: zipcode.text,
              ));

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('회원가입 성공크')),
                );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('회원가입 실패 ㅋㅋㅋ')),
                );
            }
          });
        },
        child: Text(
          'Create Account',
          style: TextStyle(color: Colors.white), // 버튼의 글씨색을 흰색으로 설정
        ),
      ),

    );
  }
}