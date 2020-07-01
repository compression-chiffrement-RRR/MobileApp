import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';


enum CompressionType { C1, C2, none }
enum EncryptionType { E1, E2, none}

//File file;
//
//void _choose() async {
//  String filePath = await FilePicker.getFilePath(type: FileType.any);
//}
//
//void _upload() {
//  if (file == null) return;
//  String base64Image = base64Encode(file.readAsBytesSync());
//  String fileName = file.path.split("/").last;
//
//  http.post("$SERVER_IP/login", body: {
//    "image": base64Image,
//    "name": fileName,
//  }).then((res) {
//    print(res.statusCode);
//  }).catchError((err) {
//    print(err);
//  });
//}

class UploadPage extends StatefulWidget {
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
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>{
  CompressionType _compressionType = CompressionType.none;
  EncryptionType _encryptionType = EncryptionType.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Flex(direction: Axis.vertical,
          children: <Widget>[
            ListBody(mainAxis: Axis.vertical,
              children: <Widget>[
                Container(
                  child: Card(margin: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text('Compression : ' + '$_compressionType',
                                style: TextStyle(fontSize: 18))
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Radio(
                              value: CompressionType.C1,
                              groupValue: _compressionType,
                              onChanged: (CompressionType value) {
                                setState(() {
                                  _compressionType = value;
                                });
                              },
                            ),
                            Text(
                              'compress 1',
                              style: new TextStyle(fontSize: 12.0),
                            ),
                            Radio(
                              value: CompressionType.C2,
                              groupValue: _compressionType,
                              onChanged: (CompressionType value) {
                                setState(() {
                                  _compressionType = value;
                                });
                              },
                            ),
                            Text(
                              'compress 2',
                              style: new TextStyle(fontSize: 12.0),
                            ),
                            Radio(
                              value: CompressionType.none,
                              groupValue: _compressionType,
                              onChanged: (CompressionType value) {
                                setState(() {
                                  _compressionType = value;
                                });
                              },
                            ),
                            Text(
                              'none',
                              style: new TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Card(margin: EdgeInsets.all(16),
                    child:Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text('Chiffrement : ' + '$_encryptionType',
                                style: TextStyle(fontSize: 18))
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Radio(
                              value: EncryptionType.E1,
                              groupValue: _encryptionType,
                              onChanged: (EncryptionType value) {
                                setState(() {
                                  _encryptionType = value;
                                });
                              },
                            ),
                            Text(
                              'Chiff 1',
                              style: new TextStyle(fontSize: 12.0),
                            ),
                            Radio(
                              value: EncryptionType.E2,
                              groupValue: _encryptionType,
                              onChanged: (EncryptionType value) {
                                setState(() {
                                  _encryptionType = value;
                                });
                              },
                            ),
                            Text(
                              'Chiff 2',
                              style: new TextStyle(fontSize: 12.0),
                            ),
                            Radio(
                              value: EncryptionType.none,
                              groupValue: _encryptionType,
                              onChanged: (EncryptionType value) {
                                setState(() {
                                  _encryptionType = value;
                                });
                              },
                            ),
                            Text(
                              'none',
                              style: new TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
//                Container(
//                    child: Card(margin: EdgeInsets.all(16),
//                        child: Column(
//                          children: <Widget>[
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                RaisedButton(
//                                  onPressed: _choose,
//                                  child: Text('Choose file'),
//                                ),
//                                SizedBox(width: 10.0),
//                                RaisedButton(
//                                  onPressed: _upload,
//                                  child: Text('Upload File'),
//                                )
//                              ],
//                            )
//                          ],
//                        )
//                    )
//                )
              ],
            )
          ],
        )
    );
  }
}
