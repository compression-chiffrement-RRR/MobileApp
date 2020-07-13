import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobileappflutter/Helper/dialog_helper.dart';
import 'package:mobileappflutter/Modele/Enum/cipher_task_type.dart';
import 'package:mobileappflutter/Modele/file_advanced_information.dart';
import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Service/file_service.dart';
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _askUnprocessFile = false;
  bool _downloadingFile = false;
  bool _isDownloaded = false;
  String _progress = '0';
  List<Widget> formPasswordInputs = new List();

  final FileBasicInformation _fileBasicInformation;
  FileAdvancedInformation _fileAdvancedInformation;

  _FileDownloaderPage(this._fileBasicInformation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
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
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            !_fileBasicInformation.isTreated ? Icon(Icons.not_interested, color: Colors.black): Container(),
            SizedBox(
              height: 30,
            ),
            Center(
              child: makeButtonDownloadWithProcessApplied(_fileBasicInformation),
            ),
            Divider(
              color: Colors.black,
              height: 50,
              thickness: 1,
              indent: 70,
              endIndent: 70,
            ),
            Center(
              child: makeButtonDownloadWithoutProcessApplied(_fileBasicInformation),
            ),
            makeFormUnprocess(_fileAdvancedInformation),
            Divider(
              color: Colors.black,
              height: 50,
              thickness: 1,
              indent: 70,
              endIndent: 70,
            ),
            _downloadingFile ? makeContainerShowStatusFileDownload() : Container(),
            _isDownloaded ? makeSuccessMessage() : Container(),
          ],
        ),
      ),
    );
  }

  RaisedButton makeButtonDownloadWithProcessApplied(FileBasicInformation fileBasicInformation) =>
      RaisedButton(
        textColor: Colors.white,
        color: AppColor.thirdColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 13),
        child: Text("Download with process applied", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        onPressed: () async {
          String path = await _fileService.downloadFile(fileBasicInformation, (rcv, total) {
            print(
                'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');

            setState(() {
              _progress = ((rcv / total) * 100).toStringAsFixed(0);
            });

            if (_progress == '100') {
              setState(() {
                _isDownloaded = true;
              });
            } else if (double.parse(_progress) < 100) {}
          });
          if (path == null) {
            DialogHelper.displayDialog(context, "Download", "Cannot download file yet, please retry later");
            setState(() {
              _progress = '0';
              _isDownloaded = false;
              _downloadingFile = false;
            });
          } else {
            setState(() {
              _progress = '0';
              _isDownloaded = false;
              _downloadingFile = true;
            });
          }
        },
      );

  RaisedButton makeButtonDownloadWithoutProcessApplied(FileBasicInformation fileBasicInformation) =>
      RaisedButton(
        textColor: Colors.white,
        color: AppColor.thirdColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 13),
        child: Text("Download without process applied", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        onPressed: () async {
          _fileAdvancedInformation = await _fileService.getInformation(_fileBasicInformation.uuid);
          formPasswordInputs = new List();
          List<String> cipherNames = EnumToString.toList(CipherTaskType.values);
          _fileAdvancedInformation.processes.forEach((element) {
            print(element.processType);
            if (cipherNames.contains(element.processType)) {
              formPasswordInputs.add(makeInput(
                label: "${element.processType} n°${element.order} password",
                obscureText: true
              ));
            }
          });
          setState(() {
            _progress = '0';
            _isDownloaded = false;
            _downloadingFile = false;
          });
        },
      );

  Widget makeFormUnprocess(FileAdvancedInformation fileAdvancedInformation) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: formPasswordInputs,
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
            color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          autocorrect: false,
          keyboardType: keyboardType,
          validator: validator,
          onSaved: onSaved,
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
                      color: Colors.black,
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
                      'Status process',
                      style: TextStyle(
                          color: Colors.black,
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

  RaisedButton makeButtonLinkToFileOnSystem() =>
      RaisedButton(
        textColor: Colors.white,
        color: AppColor.thirdColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: Text("Show file", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        onPressed: () async {
        },
      );
}