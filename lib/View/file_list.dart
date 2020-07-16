import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/file_account.dart';
import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Service/file_service.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'package:mobileappflutter/View/file_collaborator_manage.dart';
import 'package:mobileappflutter/View/file_downloader.dart';
import 'package:shimmer/shimmer.dart';
import 'file_detail.dart';
import 'file_uploader.dart';
import 'package:intl/intl.dart';

enum FileAction { download, share, delete }

class FileListPage extends StatefulWidget {

  @override
  _FileListPageState createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage>{
  final FileService _fileService = FileService();

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    PopupMenuButton makePopupButton(FileBasicInformation file) =>
        PopupMenuButton<FileAction>(
          elevation: 10,
          color: AppColor.lightedMainColor2,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<FileAction>>[
            file.isError || !file.isTreated ? null : const PopupMenuItem<FileAction>(
              value: FileAction.download,
              child: Text('Download'),
            ),
            file.isError || !file.isTreated ? null : const PopupMenuItem<FileAction>(
              value: FileAction.share,
              child: Text('Share'),
            ),
            const PopupMenuItem<FileAction>(
              value: FileAction.delete,
              child: Text('Delete'),
            )
          ],
          onSelected: (FileAction result) async {
            switch (result) {
              case FileAction.delete:
                await _fileService.deleteFile(file);
                break;
              case FileAction.download:
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FileDownloaderPage(fileBasicInformation: file),
                )).then((value) => setState(() {}));
                break;
              case FileAction.share:
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FileCollaboratorManagePage(fileBasicInformation: file)
                )).then((value) => setState(() {}));
                break;
            }
            setState(() {
            });
          },
        );

    Widget makeCardContent(FileBasicInformation file) =>
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(fileBasicInformation: file)))
                .then((value) => setState(() {}));
          },
          child: Container(
            decoration: BoxDecoration(
                color: AppColor.lightedMainColor2,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 5, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircleAvatar(
                            backgroundColor: AppColor.thirdColorVeryLight,
                            child: Icon(Icons.insert_drive_file, color: AppColor.thirdColor, size: 30,),
                        ),
                        makePopupButton(file)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        file.name,
                        style: TextStyle(color: AppColor.mainColor, fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10,),
                      Text(
                        DateFormat('dd/MM/yyyy').format(file.creationDatetime),
                        style: TextStyle(color: AppColor.mainColor, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    Container makeCard(FileBasicInformation file) =>
        Container(
          child: Card(
            elevation: 0.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            color: AppColor.mainColor,
            child: file.isError ? Shimmer.fromColors(
              baseColor: Colors.red[800],
              highlightColor: Colors.red[500],
              enabled: true,
              child: makeCardContent(file)
            ) : !file.isTreated ? Shimmer.fromColors(
                baseColor: Colors.grey[500],
                highlightColor: Colors.grey[200],
                enabled: true,
                child: makeCardContent(file)
            ) : makeCardContent(file)
          ),
        );

    final makeBody = Container(
        // decoration: BoxDecoration(color: AppColor.mainColor),
        child: RefreshIndicator(
          color: AppColor.thirdColor,
          child: FutureBuilder(
            future: _fileService.getAllFiles(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: Center(
                      child: Text("Loading..."),
                    )
                );
              } else {
                FileAccount fileAccount = snapshot.data;
                List<FileBasicInformation> files = fileAccount.userFilesAuthor;
                files.addAll(fileAccount.userFilesCollaborator);
                return GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: (150 / 120),
                    children: List.generate(files.length, (index) {
                      return Container(
                        height: 100,
                        child: makeCard(files[index]),
                      );
                    })
                );
              }
            },
          ),
          onRefresh: () async {
            setState(() {
            });
          },
        )
    );


    final floatButton = FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FileUploaderPage()))
            .then((value) => setState(() {}));
      },
      child: Icon(Icons.file_upload),
      backgroundColor: AppColor.thirdColor,
    );

    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: makeBody,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: floatButton,
      ),
    );

  }
}