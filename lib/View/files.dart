import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/file.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'friendSharedFiles.dart';
import 'upload.dart';

class FilesPage extends StatefulWidget {

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage>{
  List files;

  @override
  void initState() {
    files = getFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    ListTile makeListTile(SFile file) =>
        ListTile(
          contentPadding: EdgeInsets.all(1.0),
          leading: Icon(Icons.insert_drive_file, color: Colors.white),
          title: Text(
            file.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
//           subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
          subtitle: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(file.creationDate,
                        style: TextStyle(color: Colors.white))),
              )
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage()));
          },
        );

    Card makeCard(SFile file) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: AppColor.secondaryColor),
        child: makeListTile(file),
      ),
    );

    final makeBody = Container(
        // decoration: BoxDecoration(color: AppColor.mainColor),
        child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(files.length, (index) {
            return makeCard(files[index]);
        })
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
List getFiles() {
  return [
    SFile(
        name: "test.php",
        isTreated: true,
        creationDate: "01-09-2019"),
    SFile(
        name: "test.php",
        isTreated: true,
        creationDate: "01-09-2019"),
    SFile(
        name: "test.php",
        isTreated: true,
        creationDate: "01-09-2019"),
    SFile(
        name: "test.php",
        isTreated: true,
        creationDate: "01-09-2019"),
    SFile(
        name: "test.php",
        isTreated: true,
        creationDate: "01-09-2019"),
    SFile(
        name: "test.php",
        isTreated: true,
        creationDate: "01-09-2019"),
    SFile(
        name: "test.php",
        isTreated: true,
        creationDate: "01-09-2019"),
  ];
}