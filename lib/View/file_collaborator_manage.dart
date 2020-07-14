import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobileappflutter/Helper/dialog_helper.dart';
import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Modele/user.dart';
import 'package:mobileappflutter/Service/collaborator_service.dart';
import 'package:mobileappflutter/Service/friend_service.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';


class FileCollaboratorManagePage extends StatefulWidget {
  final FileBasicInformation basicInformation;

  FileCollaboratorManagePage({this.basicInformation});

  @override
  State<StatefulWidget> createState() => _FileCollaboratorManagePage(basicInformation);
}

class _FileCollaboratorManagePage extends State<FileCollaboratorManagePage> {
  final FriendService _friendService = FriendService();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final CollaboratorService _collaboratorService = CollaboratorService();
  final friendController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final formKey = new GlobalKey<FormState>();
  List<String> uidSelected = new List();

  _FileCollaboratorManagePage(this._basicInformation);
  final FileBasicInformation _basicInformation;


  @override
  void dispose() {
    friendController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Form collaboratorForm(List<User> users) => Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: MultiSelectFormField(
              autovalidate: false,
              titleText: 'Add Collaborator',
              validator: (value) {return null;},
              dataSource: users.map((e) => e.toObject()).toList(),
              textField: 'username',
              valueField: 'uuid',
              okButtonLabel: 'OK',
              cancelButtonLabel: 'CANCEL',
              hintText: 'Please choose one or more collaborator',
              onSaved: (value){
                uidSelected = (value as List)?.map((item) => item as String)?.toList();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: RaisedButton(
              child: Text('Save'),
              onPressed: () async {
                if(formKey.currentState.validate()){
                  List<User> userSelected = users.where((element) => uidSelected.contains(element.uuid)).toList();
                  bool res = await _collaboratorService.addCollaborators(fileBasicInformation: _basicInformation, collaborators: userSelected);
                  if(res){
                    setState(() {
                    });
                  }
                  else{
                    DialogHelper.displayDialog(context, "Error", 'An error occured, cannot add a collaborator');
                  }
                }

              },
            ),
          ),
        ],
      ),
    );

    Slidable slide(User user, int index) => Slidable(
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
            caption: 'delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () async {
              bool res = await _collaboratorService.removeCollaborator(fileBasicInformation: _basicInformation, collaborator: user);
              if(res){
                setState(() {
                });
              }
              else{
                DialogHelper.displayDialog(context, "Error", 'An error occured, cannot delete a collaborator');
              }
            },
          ),
        ),
      ],
    );

    final makeBody = Container(
        child: Column(
          children: <Widget>[
            Container(
              child: FutureBuilder(
                future: _friendService.getCurrentFriendsOrRefresh(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                        child: Center(
                          child: Text("Loading..."),
                        )
                    );
                  } else {
                    return ListView.builder(
                      key: _formKey,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return collaboratorForm(snapshot.data);
                      },
                    );
                  }
                }
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColor.thirdColor,
                child: FutureBuilder(
                    future: _friendService.getCurrentFriendsOrRefresh(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                            child: Center(
                              child: Text("Loading..."),
                            )
                        );
                      } else {
                        return ListView.builder(
                          key: _listKey,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return slide(snapshot.data[index], index);
                          },
                        );
                      }
                    }
                ),
                onRefresh: () async {
                  //TODO: Fix problem when remove pending friends by reloading
                  await _collaboratorService.getCollaborators(_basicInformation);
                  setState(() {
                  });
                },
              ),
            )
          ],
        )
    );

    final appBar = AppBar(
      elevation: 0,
      brightness: Brightness.dark,
      backgroundColor: AppColor.mainColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
      ),
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: AppColor.mainColor,
      body: makeBody,
    );

  }
}


