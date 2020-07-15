import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobileappflutter/Helper/dialog_helper.dart';
import 'package:mobileappflutter/Modele/Enum/cipher_task_type.dart';
import 'package:mobileappflutter/Modele/file_advanced_information.dart';
import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Modele/task_unprocess_file.dart';
import 'package:mobileappflutter/Modele/unprocess_file.dart';
import 'package:mobileappflutter/Service/file_service.dart';
import 'package:mobileappflutter/Service/worker_service.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:enum_to_string/enum_to_string.dart';

class FileDownloaderPage extends StatefulWidget {
  final FileBasicInformation fileBasicInformation;

  FileDownloaderPage({this.fileBasicInformation});

  @override
  State<StatefulWidget> createState() => _FileDownloaderPage(fileBasicInformation);
}

class _FileDownloaderPage extends State<FileDownloaderPage> {
  final FileService _fileService = FileService();
  final WorkerService _workerService = WorkerService();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _askUnprocessFile = false;
  bool _unprocessFile = false;
  bool _downloadingFile = false;
  bool _isDownloaded = false;
  String _progress = '0';
  List<Widget> _formPasswordInputs = new List();
  TaskUnprocessFile _taskUnprocessFile = TaskUnprocessFile([]);

  final FileBasicInformation _fileBasicInformation;
  FileAdvancedInformation _fileAdvancedInformation;
  FileBasicInformation _fileUnprocessed;

  _FileDownloaderPage(this._fileBasicInformation);

  Timer _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
          icon: Icon(Icons.arrow_back_ios, size: 20, color: AppColor.lightedMainColor2),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              _fileBasicInformation.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColor.lightedMainColor2,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            !_fileBasicInformation.isTreated ? Icon(Icons.not_interested, color: AppColor.lightedMainColor): Container(),
            Divider(
              color: AppColor.lightedMainColor,
              height: 50,
              thickness: 1,
              indent: 70,
              endIndent: 70,
            ),
            Center(
              child: makeButtonDownloadWithProcessApplied(_fileBasicInformation),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: !_askUnprocessFile ?
                makeButtonDownloadWithoutProcessApplied(_fileBasicInformation):
                makeButtonValidateDownloadWithProcessApplied(_fileAdvancedInformation),
            ),
            _askUnprocessFile && !_downloadingFile ? makeFormUnprocess(_fileAdvancedInformation) : Container(),
            Divider(
              color: AppColor.lightedMainColor,
              height: 50,
              thickness: 1,
              indent: 70,
              endIndent: 70,
            ),
            _unprocessFile ? makeContainerShowStatusFileUnprocess() : Container(),
            _downloadingFile || _isDownloaded ? makeContainerShowStatusFileDownload() : Container(),
            _isDownloaded ? makeSuccessMessage() : Container(),
          ],
        ),
      ),
    );
  }

  RaisedButton makeButtonDownloadWithProcessApplied(FileBasicInformation fileBasicInformation) =>
      RaisedButton(
        textColor: Colors.white,
        color: AppColor.lightedMainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 13),
        child: Text("Download with process applied", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        onPressed: () async {
          downloadFile(fileBasicInformation);
        },
      );

  void downloadFile(FileBasicInformation fileBasicInformation) async {
    String path = await _fileService.downloadFile(fileBasicInformation, (rcv, total) {
      print(
          'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');

      setState(() {
        _progress = ((rcv / total) * 100).toStringAsFixed(0);
      });

      if (_progress == '100') {
        setStateFinishDownload();
      } else if (double.parse(_progress) < 100) {}
    });
    if (path == null) {
      DialogHelper.displayDialog(context, "Download", "Cannot download file yet, please retry later");
      setStateReset();
    } else {
      setStateDownloading();
    }
  }

  RaisedButton makeButtonDownloadWithoutProcessApplied(FileBasicInformation fileBasicInformation) =>
      RaisedButton(
        textColor: Colors.white,
        color: AppColor.lightedMainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 13),
        child: Text("Download without process applied", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        onPressed: () async {
          _fileAdvancedInformation = await _fileService.getInformation(_fileBasicInformation.uuid);
          if (_fileAdvancedInformation.isTreated) {
            _formPasswordInputs = new List();
            List<String> cipherNames = EnumToString.toList(CipherTaskType.values);
            _fileAdvancedInformation.processes.forEach((process) {
              if (cipherNames.contains(process.processType)) {
                _formPasswordInputs.add(makeInput(
                    label: "${process.processType} n°${process.order} password",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (val) => val.isEmpty ? "Please entrer your password used during upload" : null,
                    onSaved: (val) {
                      _taskUnprocessFile.types.removeWhere((unprocessElement) => unprocessElement.uuid == process.uuid);
                      _taskUnprocessFile.types.add(UnprocessFile(process.uuid, val));
                    }
                ));
              }
            });
            if (_formPasswordInputs.length == 0) {
              setStateUnprocessStatus();
              _fileUnprocessed = await requestUnprocessFile(_fileAdvancedInformation, _taskUnprocessFile);
              if (_fileUnprocessed == null) {
                DialogHelper.displayDialog(context, "Download", "Cannot unprocess file yet, please retry later");
                setStateReset();
              } else {
                checkIfFileIsTreated(_fileUnprocessed);
              }
            } else {
              setStateAskUnprocessInformation();
            }
          } else {
            DialogHelper.displayDialog(context, "Download", "Cannot download file yet, please retry later");
            setStateReset();
          }
        },
      );

  RaisedButton makeButtonValidateDownloadWithProcessApplied(FileBasicInformation fileBasicInformation) =>
      RaisedButton(
        textColor: Colors.white,
        color: Colors.lightGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 65, vertical: 13),
        child: Text("Unprocess file with this information", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            setStateUnprocessStatus();
            _fileUnprocessed = await requestUnprocessFile(_fileAdvancedInformation, _taskUnprocessFile);
            if (_fileUnprocessed == null) {
              DialogHelper.displayDialog(context, "Download", "Cannot unprocess file yet, please retry later");
              setStateReset();
            } else {
              checkIfFileIsTreated(_fileUnprocessed);
            }
          }
        },
      );

  void setStateAskUnprocessInformation() {
    setState(() {
      _progress = '0';
      _askUnprocessFile = true;
      _isDownloaded = false;
      _downloadingFile = false;
      _unprocessFile = false;
    });
  }

  void setStateUnprocessStatus() {
    setState(() {
      _progress = '0';
      _askUnprocessFile = false;
      _isDownloaded = false;
      _downloadingFile = false;
      _unprocessFile = true;
    });
  }

  void setStateDownloading() {
    setState(() {
      _progress = '0';
      _askUnprocessFile = false;
      _isDownloaded = false;
      _downloadingFile = true;
      _unprocessFile = false;
    });
  }

  void setStateFinishDownload() {
    setState(() {
      _progress = '100';
      _askUnprocessFile = false;
      _isDownloaded = true;
      _downloadingFile = false;
      _unprocessFile = false;
    });
  }

  void setStateReset() {
    setState(() {
      _progress = '0';
      _askUnprocessFile = false;
      _isDownloaded = false;
      _downloadingFile = false;
      _unprocessFile = false;
    });
  }

  Future<FileBasicInformation> requestUnprocessFile(FileBasicInformation fileBasicInformation, TaskUnprocessFile taskUnprocessFile) async {
    FileBasicInformation fileUnprocessed = await _workerService.unprocessFile(fileUuid: fileBasicInformation.uuid, taskUnprocessFile: taskUnprocessFile);
    setState(() {
      _progress = '0';
      _askUnprocessFile = false;
      _isDownloaded = false;
      _downloadingFile = false;
    });
    return fileUnprocessed;
  }

  void checkIfFileIsTreated(FileBasicInformation fileBasicInformation) async {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      _fileUnprocessed = await _fileService.getInformation(fileBasicInformation.uuid);
      if (_fileUnprocessed.isError) {
        DialogHelper.displayDialog(context, "Download", "Cannot unprocess file yet, an error as occured, please retry later");
        setStateReset();
      }
      if (_fileUnprocessed.isTreated) {
        timer.cancel();
        downloadFile(_fileUnprocessed);
      }
    });
  }

  Widget makeFormUnprocess(FileAdvancedInformation fileAdvancedInformation) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: _formPasswordInputs,
          ),
        ),
      );

  Widget makeInput({controller, keyboardType, validator, onSaved, label, obscureText = false}) =>
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
          style: TextStyle(color: AppColor.lightedMainColor2),
          controller: controller,
          obscureText: obscureText,
          autocorrect: false,
          keyboardType: keyboardType,
          validator: validator,
          autovalidate: true,
          onSaved: onSaved,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.lightedMainColor2)
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.lightedMainColor2)
            ),
          ),
        ),
        SizedBox(height: 12,),
      ],
    );

  Container makeContainerShowStatusFileDownload() =>
      Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Download Information',
                  style: TextStyle(
                      color: AppColor.lightedMainColor2,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: <Widget>[
                  Align(
                    child: Text(
                      'Process status',
                      style: TextStyle(
                          color: AppColor.lightedMainColor2,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 50,
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 500,
                    percent: double.parse(_progress) / 100,
                    center: Text(_progress),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.green,
                    animateFromLastPercent: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Container makeContainerShowStatusFileUnprocess() =>
      Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Unprocess Information',
                  style: TextStyle(
                      color: AppColor.lightedMainColor2,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: <Widget>[
                  Align(
                    child: Text(
                      'Status process: Waiting unprocess your file',
                      style: TextStyle(
                          color: AppColor.lightedMainColor2,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                    ),
                  )
                ],
              ),
            ),
            /*SizedBox(
              height: 30,
            ),*/
            //makeButtonLinkToFileOnSystem()
          ],
        ),
      );

  Container makeSuccessMessage() =>
      Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            'Download Success',
            style: TextStyle(
                color: Colors.lightGreen,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
}