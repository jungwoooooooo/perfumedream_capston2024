import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../models/model_auth.dart';
import '../screens/screen_basket_page.dart';
import '../screens/screen_my_order_list_page.dart';

class TabProfile extends StatefulWidget {
  @override
  _TabProfileState createState() => _TabProfileState();
}

class _TabProfileState extends State<TabProfile> {
  String _name = "";
  String _email = "";
  File? _image; // 선택한 이미지를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? "";
      _email = prefs.getString('email') ?? "";
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        // 이미지를 저장하려면 SharedPreferences나 클라우드 스토리지 사용
      }
    } catch (e) {
      // 오류가 발생할 경우 처리
      print("Image picker error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: _image == null
                        ? Image.asset(
                      'images/images/logo.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                        : Image.file(
                      _image!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.2, -0.2),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      width: 50,
                      height: 30,

                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16, width: 16),
            Text(_name),  // 사용자의 이름 표시
            SizedBox(height: 8),
            Text("이메일 : "+_email),  // 사용자의 이메일 표시
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Changed to spaceEvenly for equal spacing
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyOrderListPage(),
                    ));
                  },
                  child: Column(
                    children: [
                      Icon(Icons.assignment),
                      Text('My Order'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ItemBasketPage(),
                    ));
                  },
                  child: Column(
                    children: [
                      Icon(Icons.shopping_basket),
                      Text('My Cart'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            LoginOutButton(), // Add the Logout Button here
          ],
        ),
      ),
    );
  }
}

class LoginOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient = Provider.of<FirebaseAuthProvider>(context, listen: false);
    return TextButton(
      onPressed: () async {
        await authClient.logout();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('로그아웃!')));
        Navigator.of(context).pushReplacementNamed('/login');
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.black, // 텍스트 색상을 검정색으로 설정합니다
      ),
      child: Text('로그아웃'),
    );
  }
}
