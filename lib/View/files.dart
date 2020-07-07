import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class FilesPage extends StatefulWidget {
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
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('files'));
  }
}