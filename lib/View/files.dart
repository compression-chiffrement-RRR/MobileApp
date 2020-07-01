import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

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

class _FilesPageState extends State<FilesPage>{

  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType, fileExtension: _extension);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("FilePickerApp"),
        ),
        body: Container(
          child: Center(
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
                    builder: (BuildContext context) => _loadingPath
                        ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: const CircularProgressIndicator())
                        : _path != null || _paths != null
                        ? new Container(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      height: MediaQuery.of(context).size.height * 0.50,
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
              )),
        ),
      ),
    );
  }
}