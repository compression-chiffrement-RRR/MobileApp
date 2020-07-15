import 'package:enum_to_string/enum_to_string.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:mobileappflutter/Helper/dialog_helper.dart';
import 'package:mobileappflutter/Modele/Enum/cipher_task_type.dart';
import 'package:mobileappflutter/Modele/Enum/compress_task_type.dart';
import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Modele/process_file.dart';
import 'package:mobileappflutter/Modele/task_process_file.dart';
import 'package:mobileappflutter/Service/worker_service.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'package:flutter/services.dart';

class FileUploaderPage extends StatefulWidget {
  @override
  _FileUploaderPageState createState() => _FileUploaderPageState();
}

class _FileUploaderPageState extends State<FileUploaderPage> {
  WorkerService _workerService = WorkerService();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _filenameController = TextEditingController();

  List<String> _taskTypes;
  TaskProcessFile _taskProcessFile;

  String _fileName;
  String _path;
  Map<String, String> _paths;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType = FileType.any;

  List<Row> _formRowProcessInputs = new List();

  @override
  void initState() {
    _taskTypes = EnumToString.toList(CipherTaskType.values);
    _taskTypes.addAll(EnumToString.toList(CompressTaskType.values));
    _taskProcessFile = TaskProcessFile(new List());
    _filenameController.text = _fileName;
    super.initState();
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(type: _pickingType);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(type: _pickingType);
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
        _filenameController.text = _fileName;
      });
    }
  }

  RaisedButton makeAddFormFieldButton() =>
      RaisedButton(
        textColor: Colors.white,
        color: AppColor.thirdColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 13),
        child: Text("Add a process to the file", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        onPressed: () async {
          dialogSelectTypeProcess();
        },
      );

  void dialogSelectTypeProcess() =>
      showMaterialRadioPicker(
        context: context,
        title: "Pick Your Process Type",
        items: _taskTypes,
        selectedItem: _taskTypes[0],
        onChanged: (value) {
          setState(() {
            ProcessFile processFile;
            if (EnumToString.toList(CipherTaskType.values).contains(value)) {
              processFile = ProcessFile.fromCipher(type: CipherTaskType.values.firstWhere((element) => element.toString() == "CipherTaskType.$value"));
              _formRowProcessInputs.add(makeNewProcessFormRow(UniqueKey(), makeCipherFormFields(
                  label: value,
                  onSaved: (val) => processFile.password = val
              )));
            } else {
              processFile = ProcessFile.fromCompress(type: CompressTaskType.values.firstWhere((element) => element.toString() == "CompressTaskType.$value"));
              _formRowProcessInputs.add(makeNewProcessFormRow(UniqueKey(), makeCompressFields(label: value)));
            }
            _taskProcessFile.types.add(processFile);
          });
        },
      );

  Form makeForm() => Form(
    key: _formKey,
    child: Column(
      children: _formRowProcessInputs,
    ),
  );

  Row makeNewProcessFormRow(Key rowKey, Container formFields) =>
    Row(
      key: rowKey,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: formFields,
          flex: 10,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _formRowProcessInputs.removeWhere((Row element) => element.key == rowKey);
                });
              },
              icon: Icon(Icons.delete_forever, size: 20, color: Colors.red,),
            ),
          ),
          flex: 1,
        )
      ],
    );

  Container makeCipherFormFields({label, onSaved}) => Container(
    child: makeInput(
      label: label,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: (val) => val.isEmpty ? "Please entrer a password to secure your file" : null,
      onSaved: onSaved
    ),
  );

  Container makeCompressFields({label}) => Container(
    child: Text(label),
  );

  Widget makeInput({controller, keyboardType, validator, onSaved, label, obscureText = false, defaultValue}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColor.lightedMainColor2
          ),),
          SizedBox(height: 5,),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            autocorrect: false,
            keyboardType: keyboardType,
            validator: validator,
            autovalidate: true,
            onSaved: onSaved,
            initialValue: defaultValue,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400])
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400])
              ),
            ),
          ),
          SizedBox(height: 12,),
        ],
      );

  Container makeFilePickerButton() => Container(
        child: Card(
          margin: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                          padding: const EdgeInsets.all(10.0),
                          height: 160,
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

                              return Column(
                                children: <Widget>[
                                  new Card(
                                      margin: EdgeInsets.only(bottom: 10),
                                      elevation: 1,
                                      child: Column(children: <Widget>[
                                        ListTile(
                                          title: new Text(name),
                                          subtitle: new Text(path),
                                        )
                                      ])),
                                  makeInput(
                                    label: "File name",
                                    keyboardType: TextInputType.text,
                                    controller: _filenameController,
                                    validator: (value) => value.isEmpty ? "Provide a file name" : null,
                                  )
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    new Divider(),
                          ),
                        )
                      : new Container(),
            ),
          ]),
        ),
      );

  Container makeButtonUpload() =>
      Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: RaisedButton(
            textColor: Colors.white,
            color: AppColor.lightedMainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 13),
            child: Text("Upload file", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            onPressed: () async {
              if (_formKey.currentState.validate() && _path != null && _filenameController.text != null) {
                _formKey.currentState.save();
                final snackbar = SnackBar(
                  duration: Duration(seconds: 900),
                  content: Row(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text("  File uploading ...")
                    ],
                  ),
                );
                _scaffoldKey.currentState.showSnackBar(snackbar);
                FileBasicInformation fileBasicInformation = await _workerService.uploadFile(path: _path, filename: _filenameController.text, task: _taskProcessFile);
                if (fileBasicInformation == null) {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  DialogHelper.displayDialog(context, "Error during upload", "Upload file fail, please retry");
                } else {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  final snackbar = SnackBar(
                    duration: Duration(seconds: 3),
                    content: Row(
                      children: <Widget>[
                        Icon(Icons.save_alt, size: 20),
                        Text("  File uploaded !")
                      ],
                    ),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackbar);
                  resetState();
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.pop(context, true);
                }
              }
            },
          )
      );

  void resetState() {
    _path = null;
    _fileName = null;
    _taskProcessFile = TaskProcessFile(new List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.mainColor,
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 10,
          brightness: Brightness.dark,
          backgroundColor: AppColor.mainColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              makeForm(),
              makeAddFormFieldButton(),
              makeFilePickerButton(),
              makeButtonUpload(),
            ],
          ),
        ));
  }
}
