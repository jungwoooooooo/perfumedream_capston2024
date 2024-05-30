// screens/index_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PerfumeDream/screens/screen_basket_page.dart';
import 'package:PerfumeDream/screens/screen_item_list_page.dart';

import '../tabs/tab_like.dart';
import '../tabs/tab_profile.dart';

class IndexScreen extends StatefulWidget {

  @override
  _IndexScreenState createState() {
    return _IndexScreenState();
  }
}

class _IndexScreenState extends State<IndexScreen> {

  int _currentIndex = 0;

  final List<Widget> tabs = [
    //HomeScreen(),
    ItemListPage(),
    ItemBasketPage(),
    //TabSearch(),
    LikedItemListPage(),
    //TabCart(),
    TabProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 10),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 12),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          //Navigator.pushNamed(context, '/search');
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '', activeIcon: Icon(Icons.home)),
          //BottomNavigationBarItem(icon: Icon(Icons.search), label: '', activeIcon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: '', activeIcon: Icon(Icons.shopping_cart)),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: '', activeIcon: Icon(Icons.star)),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '', activeIcon: Icon(Icons.person)),
        ],
      ),
      body: tabs[_currentIndex],
    );
  }
}