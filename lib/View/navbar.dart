import 'package:flutter/material.dart';
import 'package:mobileappflutter/View/file_list.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'account.dart';
import 'friend_bar.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar>{
  int _currentIndex = 0;
  final statefulWidgetBuilder = [
    FileListPage(),
    FriendBar(),
    AccountPage()
  ];

  final topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: AppColor.mainColor,
  );

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.0),
        child: topAppBar,
      ),
      body: statefulWidgetBuilder[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColor.mainColor,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
          icon: Icon(Icons.folder_shared),
          title: Text('Files'),
        ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text('Friends'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Account'),
          )
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}