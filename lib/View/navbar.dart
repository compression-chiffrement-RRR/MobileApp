import 'package:flutter/material.dart';
import 'package:mobileappflutter/View/files.dart';
import 'package:mobileappflutter/View/friends.dart';
import 'package:mobileappflutter/View/home.dart';
import 'dart:convert' show json, base64, ascii;
import 'dart:convert';
import 'account.dart';

class Navbar extends StatefulWidget {
  Navbar(this.jwt, this.payload);

  factory Navbar.fromBase64(String jwt) =>
      Navbar(
          jwt,
          json.decode(
              ascii.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          )
      );

  final String jwt;
  final Map<String, dynamic> payload;


  @override
  _NavbarState createState() => _NavbarState(jwt, payload);
}

class _NavbarState extends State<Navbar>{

  _NavbarState(this.jwt, this.payload);
  factory _NavbarState.fromBase64(String jwt) =>
      _NavbarState(
          jwt,
          json.decode(
              ascii.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          )
      );

  final String jwt;
  final Map<String, dynamic> payload;

  int _currentIndex = 0;
  final statefulWidgetBuilder = [
    FilesPage(),
    FriendPage(),
    AccountPage(),
    HomePage(),
  ];

  final topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
  );

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
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
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
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
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