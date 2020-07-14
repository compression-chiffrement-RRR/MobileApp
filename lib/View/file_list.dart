import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/file_account.dart';
import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Service/file_service.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'package:mobileappflutter/View/file_collaborator_manage.dart';
import 'friendSharedFiles.dart';
import 'upload.dart';

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
          itemBuilder: (BuildContext context) => <PopupMenuEntry<FileAction>>[
            const PopupMenuItem<FileAction>(
              value: FileAction.download,
              child: Text('Download'),
            ),
            const PopupMenuItem<FileAction>(
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
                // TODO: Handle this case.
                break;
              case FileAction.share:
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FileCollaboratorManagePage(basicInformation: file)
                ));
                break;
            }
            setState(() {
            });
          },
        );

    ListTile makeListTile(FileBasicInformation file) =>
        ListTile(
          dense: true,
          enabled: true,
          contentPadding: EdgeInsets.only(left: 10),
          leading: Icon(Icons.insert_drive_file, color: Colors.white),
          title: Text(
            file.name,
            style: TextStyle(color: Colors.white, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: makePopupButton(file),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage()));
          },
        );

    Card makeCard(FileBasicInformation file) => Card(
      elevation: 0.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      color: AppColor.mainColor,
      child: Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network("https://via.placeholder.com/150x100"),
            ),
            makeListTile(file)
          ],
        ),
      ),
    );

    final makeBody = Container(
        // decoration: BoxDecoration(color: AppColor.mainColor),
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
              return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (150 / 130),
                  children: List.generate(fileAccount.userFilesAuthor.length, (index) {
                    return Container(
                      height: 100,
                      child: makeCard(fileAccount.userFilesAuthor[index]),
                    );
                  })
              );
            }
          },
        )
    );


    final floatButton = FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UploadPage()));
      },
      child: Icon(Icons.file_upload),
      backgroundColor: AppColor.mainColor,
    );

    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: makeBody,
      floatingActionButton: floatButton,
    );

  }
}