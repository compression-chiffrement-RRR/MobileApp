import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

enum CompressionType { C1, C2, none }
enum EncryptionType { E1, E2, none}


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
  String _fileName;
  String _path;
  Map<String, String> _paths;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType = FileType.any;

  CompressionType _compressionType = CompressionType.none;
  EncryptionType _encryptionType = EncryptionType.none;

  @override
  void initState() {
    super.initState();
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _fileName = _path != null
            ? _path
            .split('/')
            .last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }



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
                Container(
                  child: Card(margin: EdgeInsets.all(16),
                      child:Column(
                        children: <Widget>[
                            Center(
                                child: Column(
                                  children: <Widget>[
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                                      child: new RaisedButton(
                                        onPressed: () => _openFileExplorer(),
                                        child: new Text("Open file picker"),
                                      ),
                                    ),
                                    new Builder(
                                      builder: (BuildContext context) =>
                                      _loadingPath
                                          ? Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: const CircularProgressIndicator())
                                          : _path != null || _paths != null
                                          ? new Container(
                                        padding: const EdgeInsets.only(bottom: 30.0),
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.50,
                                        child: new Scrollbar(
                                            child: new ListView.separated(
                                              itemCount: _paths != null && _paths.isNotEmpty
                                                  ? _paths.length
                                                  : 1,
                                              itemBuilder: (BuildContext context, int index) {
                                                final bool isMultiPath =
                                                    _paths != null && _paths.isNotEmpty;
                                                final String name = 'File $index: ' +
                                                    (isMultiPath
                                                        ? _paths.keys.toList()[index]
                                                        : _fileName ?? '...');
                                                final path = isMultiPath
                                                    ? _paths.values.toList()[index].toString()
                                                    : _path;

                                                return new ListTile(
                                                  title: new Text(
                                                    name,
                                                  ),
                                                  subtitle: new Text(path),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context, int index) =>
                                              new Divider(),
                                            )),
                                      )
                                          : new Container(),
                                    ),
                                  ],
                                )
                            ),
                        ]
                      ),
                  ),
                )
              ],
            )
          ],
        )
    );
  }
}
