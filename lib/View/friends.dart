import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii;
import 'dart:convert';

class FriendPage extends StatefulWidget {
//  UploadPage(this.jwt, this.payload);
//
//  factory UploadPage.fromBase64(String jwt) =>
//      UploadPage(
//          jwt,
//          json.decode(
//              ascii.decode(
//                  base64.decode(base64.normalize(jwt.split(".")[1]))
//              )
//          )
//      );
//
//  final String jwt;
//  final Map<String, dynamic> payload;


  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage>{

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Friends'));
  }
}