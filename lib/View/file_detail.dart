import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/file_advanced_information.dart';
import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Service/file_service.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'package:mobileappflutter/View/file_collaborator_manage.dart';
import 'package:mobileappflutter/View/file_downloader.dart';
import 'package:intl/intl.dart';


enum FileAction { download, share, delete }

class DetailPage extends StatefulWidget {
  final FileBasicInformation fileBasicInformation;

  DetailPage({this.fileBasicInformation});

  @override
  _DetailPageState createState() => _DetailPageState(fileBasicInformation);
}

class _DetailPageState extends State<DetailPage>{
  final FileService _fileService = FileService();
  final FileBasicInformation _fileBasicInformation;
  Future<FileAdvancedInformation> _fileAdvancedInformation;

  _DetailPageState(this._fileBasicInformation);

  @override
  void initState() {
    _fileAdvancedInformation = _fileService.getInformation(_fileBasicInformation.uuid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Container makeBody(FileAdvancedInformation file) =>
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: Flexible(
                      child: Row(
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
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                file.name,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppColor.lightedMainColor2,
                                    fontSize: 16.0),
                              ),
                            ),
                          )
                        ],
                      ),
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
                              margin: EdgeInsets.all(10),
                              child: Text(
                                DateFormat('dd/MM/yyyy HH:mm:ss').format(file.creationDatetime),
                                style: TextStyle(
                                    color: AppColor.lightedMainColor2,
                                    fontSize: 16.0),
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
                              margin: EdgeInsets.all(10),
                              child: Text(

                                file.isTreated
                                    ? 'Treated'
                                    : 'Pending',
                                style: TextStyle(
                                    color: AppColor.lightedMainColor2,
                                    fontSize: 16.0),
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
                              margin: EdgeInsets.all(10),
                              child: Text(
                                file.isError ? 'Yes' : 'No',
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
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(25, 20, 0, 10),
                  child: Text(
                    'Treatment State :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: AppColor.lightedMainColor2,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                    child: ListView.builder(
                      itemCount: file.processes.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${file.processes[index].order + 1} - ${file.processes[index].processType}",
                              style: TextStyle(
                                color: AppColor.lightedMainColor2,
                                fontSize: 14.0),),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: AppColor.lightedMainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 13),
                    child: Text("Download File", style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),),
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => FileDownloaderPage(fileBasicInformation: file),
                      )).then((value) => setState(() {}));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: AppColor.lightedMainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 110, vertical: 13),
                    child: Text("Share File", style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => FileCollaboratorManagePage(fileBasicInformation: file)
                      )).then((value) => setState(() {}));
                    },
                  ),
                ),
                Expanded(child: Container(),),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: AppColor.redDeleteButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 110, vertical: 13),
                    child: Text("Delete File", style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),),
                    onPressed: () async {
                      await _fileService.deleteFile(file);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );

    final appBar = AppBar(
      elevation: 10,
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
      body: FutureBuilder(
        future: _fileAdvancedInformation,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                 child: Text("Loading..."),
              )
            );
          } else {
            return makeBody(snapshot.data);
          }
        },
      ),
    );

  }
}