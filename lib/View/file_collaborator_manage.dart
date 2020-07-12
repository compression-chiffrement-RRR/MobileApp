import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobileappflutter/Modele/file_advanced_information.dart';
import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Modele/user.dart';
import 'package:mobileappflutter/Service/collaborator_service.dart';
import 'package:mobileappflutter/Style/color.dart';

class FileCollaboratorManagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FileCollaboratorManagePage();
}

class _FileCollaboratorManagePage extends State<FileCollaboratorManagePage> {
  final CollaboratorService _collaboratorService = CollaboratorService();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final friendController = TextEditingController();

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
      body: Column(
        children: <Widget>[
          makeAddCollaboratorForm()
        ],
      ),
    );
  }

  Form makeAddCollaboratorForm() =>
      Form(
        key: _formKey,
        child: Container(
          height: 50,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          padding: EdgeInsets.only(left: 20, right: 3, top: 3, bottom: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: friendController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Add a collaborator",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    /*if (await _collaboratorService.addCollaborators(fileBasicInformation: fileBasicInformation, collaborators: [] )) {
                      return showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Friend Added'),
                            content: const Text("successfull"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  friendController.clear();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    else {
                      return showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Friend Not Added'),
                            content: const Text("error"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  friendController.clear();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }*/
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                ),
                height: double.infinity,
                minWidth: 50,
                elevation: 0,
                color: AppColor.secondaryColor,
                child: Icon(Icons.group_add, color: Colors.white,),
              )
            ],
          ),
        ),
      );

  RefreshIndicator makeListCollaborator(FileAdvancedInformation fileAdvancedInformation) =>
      RefreshIndicator(
        color: AppColor.thirdColor,
        child: FutureBuilder(
            future: _collaboratorService.getCollaborators(fileAdvancedInformation),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: Center(
                      child: Text("Loading..."),
                    )
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return slide(fileAdvancedInformation, snapshot.data[index], index);
                  },
                );
              }
            }
        ),
        onRefresh: () async {
          await _collaboratorService.getCollaborators(fileAdvancedInformation);
          setState(() {
          });
        },
      );

  Slidable slide(FileBasicInformation fileBasicInformation, User user, int index) => Slidable(
    delegate: new SlidableDrawerDelegate(),
    actionExtentRatio: 0.25,
    child: new Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: AppColor.secondaryColor),
        child: new ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: new Text(
            user.username,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
    secondaryActions: <Widget>[
      new Card(
        margin: new EdgeInsets.symmetric(horizontal: 0, vertical: 6.0),
        child: new IconSlideAction(
          caption: 'remove',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            await _collaboratorService.removeCollaborator(fileBasicInformation: fileBasicInformation, collaborator: user);
          },
        ),
      ),
    ],
  );

}