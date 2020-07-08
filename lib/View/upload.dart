import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileappflutter/View/login.dart';
import 'env.dart';
import 'package:flutter/services.dart';

class UploadPage extends StatefulWidget {

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>{

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  String _fileName;
  String _path;
  Map<String, String> _paths;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType = FileType.any;

  String compressionValue = 'none';
  String encryptionValue = 'none';
  String path = '';
  
  @override
  void initState() {
    super.initState();
  }

//  Future<String> attemptUpload(String compression, String chiffrement, String path) async {
//    final body = jsonEncode({
//      "accountUuid": "971f685c-fdf9-4423-ae65-0d2ca533b563",
//      "types": [
//        {"name": compression, "password": "superpassword"},
//        {"name": chiffrement}
//        ]
//    });
//    Map<String,String> headers = {'Content-Type': 'application/json; charset=UTF-8'};
//    var res = await http.post(
//        "$SERVER_IP/api/worker/uploadFile",
//        headers: headers,
//        body: body
//    );
//
//    if(res.statusCode == 200) {
//      return res.headers["authorization"];
//    }
//    return null;
//  }

  Uri apiUrl = Uri.parse('$SERVER_IP/api/worker/uploadFile');

  Future<Map<String, dynamic>> attemptUpload(String compression, String chiffrement, String path) async {
    final jwt = await jwtOrEmpty;
    // Intilize the multipart request
    final fileUploadRequest = http.MultipartRequest('POST', apiUrl);

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath(
        'file', path
    );
//    fileUploadRequest.fields['ext'] = mimeTypeData[1];

    final tasks = jsonEncode({
      "accountUuid": "971f685c-fdf9-4423-ae65-0d2ca533b563",
      "types": [
        {"name": compression, "password": "superpassword"},
        {"name": chiffrement}
        ]
    });

    Map<String,String> headers = {'Authorization': jwt};

    fileUploadRequest.files.add(file);
    fileUploadRequest.headers.addAll(headers);
    fileUploadRequest.fields['tasks'] = tasks;
    print(fileUploadRequest);


    try {
      final streamedResponse = await fileUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.request);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      _resetState();
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _resetState() {
    setState(() {
      compressionValue = 'none';
      encryptionValue = 'none';
      path = '';
    });
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
        body: ListView(
          scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                  child: Card(margin: EdgeInsets.all(4),
                    child: Column(
                      children: <Widget>[
                        DropdownButton<String>(
                          value: compressionValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 12,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              compressionValue = newValue;
                            });
                          },
                          items: <String>['none', 'ENCRYPT_AES_128_ECB', 'ENCRYPT_AES_192_ECB','ENCRYPT_AES_256_ECB', 'ENCRYPT_AES_128_CBC', 'ENCRYPT_AES_192_CBC', 'ENCRYPT_AES_256_CBC']
                            .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                          }).toList(),
                        )
                      ],
                    ),
                  )
                ),
                Container(
                  child: Card(margin: EdgeInsets.all(4),
                      child: Column(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.50,
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

                                          return new Card(margin: EdgeInsets.all(4),
                                            child:Column(
                                                children: <Widget>[
                                                ListTile(
                                                  title: new Text(name),
                                                  subtitle: new Text(path),
                                                )
                                                ]
                                          )
                                          );
                                        },
                                        separatorBuilder:
                                        (BuildContext context, int index) =>
                                          new Divider(),
                                  ),
                            )
                                : new Container(),
                          ),
                        ]
                      ),
                  ),
                ),
                Container(
                    height: 70,
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.black,
                      child: Text('uploader'),
                      onPressed: () async {
                        attemptUpload(compressionValue, encryptionValue, _path);
                      },
                    )),
              ],
            )
        );
  }
}
