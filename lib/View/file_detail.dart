import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Service/file_service.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'package:mobileappflutter/View/file_collaborator_manage.dart';
import 'package:mobileappflutter/View/file_downloader.dart';


enum FileAction { download, share, delete }

class DetailPage extends StatefulWidget {
  final FileBasicInformation fileBasicInformation;

  DetailPage({this.fileBasicInformation});

  @override
  _DetailPageState createState() => _DetailPageState(fileBasicInformation);
}

class _DetailPageState extends State<DetailPage>{
  final FileService _fileService = FileService();


  _DetailPageState(this._fileBasicInformation);
  final FileBasicInformation _fileBasicInformation;
  //FileAdvancedInformation _fileAdvancedInformation = await _fileService.getInformation(_fileBasicInformation.uuid);

  @override
  void initState() {
  super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Container makeBody(FileBasicInformation file) =>
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'FileName :',
                              style: TextStyle(
                                  color: AppColor.lightedMainColor2,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: Text(
                                _fileBasicInformation.name,
                                style: TextStyle(
                                    color: AppColor.lightedMainColor2,
                                    fontSize: 14.0),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Creation Date :',
                              style: TextStyle(
                                  color: AppColor.lightedMainColor2,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: Text(
                                _fileBasicInformation.creationDate.toString(),
                                style: TextStyle(
                                    color: AppColor.lightedMainColor2,
                                    fontSize: 14.0),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Treatment State :',
                              style: TextStyle(
                                  color: AppColor.lightedMainColor2,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: Text(

                                _fileBasicInformation.isTreated
                                    ? 'Treated'
                                    : 'Pending',
                                style: TextStyle(
                                    color: AppColor.lightedMainColor2,
                                    fontSize: 14.0),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'File in Error :',
                              style: TextStyle(
                                  color: AppColor.lightedMainColor2,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: Text(
                                _fileBasicInformation.isError ? 'Yes' : 'No',
                                style: TextStyle(
                                    color: AppColor.lightedMainColor2,
                                    fontSize: 14.0),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: AppColor.lightedMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 13),
                  child: Text("Download File", style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),),
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => FileDownloaderPage(fileBasicInformation: file),
                    )).then((value) => setState(() {}));
                  },
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: AppColor.lightedMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 13),
                  child: Text("Share File", style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => FileCollaboratorManagePage(fileBasicInformation: file)
                    )).then((value) => setState(() {}));
                  },
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: AppColor.lightedMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 13),
                  child: Text("Delete File", style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),),
                  onPressed: () async {
                    await _fileService.deleteFile(file);
                    Navigator.of(context).pop();
                    setState(() {

                    });
                  },
                ),
              ],
            ),
          );

    final appBar = AppBar(
      elevation: 20,
      brightness: Brightness.dark,
      backgroundColor: AppColor.mainColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios, size: 20, color: AppColor.lightedMainColor2),
      ),
    );

    return Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: appBar,
      body: makeBody(_fileBasicInformation),
    );

  }
}