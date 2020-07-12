import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/user.dart';
import 'package:mobileappflutter/Service/friend_service.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'friendSharedFiles.dart';


class FriendListPage extends StatefulWidget {

  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage>{
  final FriendService _friendService = FriendService();
  final _formKey = GlobalKey<FormState>();
  final friendController = TextEditingController();

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

    ListTile makeListTile(User user) => ListTile(
      contentPadding:
      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        user.username,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(user.email,
                    style: TextStyle(color: Colors.white))),
          )
        ],
      ),
      trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage()));
      },
    );

    Card makeCard(User user) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: AppColor.secondaryColor),
        child: makeListTile(user),
      ),
    );

    final makeBody = Container(
      child: Column(
        children: <Widget>[
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
                            hintText: "Add a friend",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          if (await _friendService.addFriend(friendController.text)) {
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
                          }
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
            ),
          Expanded(
            child: RefreshIndicator(
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
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return makeCard(snapshot.data[index]);
                        },
                      );
                    }
                  }
              ),
              onRefresh: () async {
                await _friendService.refreshCurrentFriends();
                setState(() {
                });
              },
            )
          )
        ],
      )
    );

    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: makeBody,
    );

  }
}

