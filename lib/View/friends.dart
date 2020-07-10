import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/user.dart';
import 'env.dart';
import 'friendSharedFiles.dart';
import 'package:http/http.dart' as http;

import 'login.dart';


class FriendPage extends StatefulWidget {

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage>{
  final _formKey = GlobalKey<FormState>();
  final friendController = TextEditingController();

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  set users(Future<List<User>> users) {}

  @override
  void dispose() {
    friendController.dispose();
    super.dispose();
  }

  Future<bool> addFriend(String username) async {
      final jwt = await jwtOrEmpty;
      print('addfriend');
      final user = await searchUser(username);
      if(user != null) {
        final body = jsonEncode({"friendUuid": user.uuid});
        Map<String, String> headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": jwt,
        };
        var res = await http.post(
            "$SERVER_IP/api/friend",
            headers: headers,
            body: body
        );

        if (res.statusCode != 200) {
          return false;
        }
        return true;
      }
      return false;
    }

  Future<User> searchUser(String username) async {
    final jwt = await jwtOrEmpty;
    print('searchUser');
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": jwt
    };
    var res = await http.get(
        "$SERVER_IP/api/account?username=$username",
        headers: headers
    );
    print(res.body);
    if (res.statusCode == 200) {
      return User.fromJson(json.decode(res.body));
    }
    else {
      return null;
    }
  }

  Future<List<User>> getMyFriends() async {
    final jwt = await jwtOrEmpty;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": jwt
    };
    var res = await http.get(
        "$SERVER_IP/api/friend/",
        headers: headers
    );
    if(res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      List<User> users = [];
      for(var u in jsonData){
        User user = User.fromJson(u);
        users.add(user);
      }
      
      return users;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    users = getMyFriends();
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
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
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
                          if (await addFriend(friendController.text)) {
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
                      color: Color.fromRGBO(64, 75, 96, .9),
                      child: Icon(Icons.group_add, color: Colors.white,),
                    )
                  ],
                ),
              ),
            ),
          Expanded(
            child: FutureBuilder(
              future: getMyFriends(),
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
                      print(snapshot.data[index].email);
                      return makeCard(snapshot.data[index]);
                    },
                  );
                }
              }
            )
          )
        ],
      )
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: makeBody,
    );

  }

  List getUsers() {
    getMyFriends();
  }
}

