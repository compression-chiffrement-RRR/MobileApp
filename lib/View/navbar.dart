import 'package:flutter/material.dart';
import 'package:mobileappflutter/View/files.dart';
import 'package:mobileappflutter/View/friends.dart';
import 'package:mobileappflutter/View/home.dart';
import 'dart:convert' show json, base64, ascii;
import 'dart:convert';
import 'upload.dart';

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

  final StatefulWidgetBuilder = [
    HomePage(),
    UploadPage(),
    FilesPage(),
    FriendPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CypheNet'),
        backgroundColor: Colors.black,
      ),
      body: StatefulWidgetBuilder[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
//            backgroundColor: Colors.black
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_upload),
              title: Text('Upload'),
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.folder_shared),
              title: Text('Files'),
//              backgroundColor: Colors.black
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.group),
              title: Text('Friends'),
//              backgroundColor: Colors.black
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

//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          title: Text('Cyphernet'),
//          backgroundColor: Colors.black,
//        ),
//        body: Padding(
//          padding: EdgeInsets.all(10),
//        )
//    );
//  }

//  @override
//  Widget build(BuildContext context) =>
//      Scaffold(
//        appBar: AppBar(title: Text("Home Screen")),
//        body: Center(
//          child: FutureBuilder(
//              future: http.read('$SERVER_IP/account', headers: {"Authorization": jwt}),
//              builder: (context, snapshot) =>
//              snapshot.hasData ?
//              Column(children: <Widget>[
//                Text("${payload['username']}, here's the data:"),
//                Text(snapshot.data, style: Theme.of(context).textTheme.display1)
//              ],)
//                  :
//              snapshot.hasError ? Text("An error occurred") : CircularProgressIndicator()
//          ),
//        ),
//      );