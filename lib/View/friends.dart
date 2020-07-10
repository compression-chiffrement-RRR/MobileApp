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
  List users;
  final _formKey = GlobalKey<FormState>();
  final friendController = TextEditingController();

  @override
  void dispose() {
    friendController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    users = getUsers();
    super.initState();
  }

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  Future<void> addFriend(String username) async {
    print('addfriend');
    final user = await searchUser(username);
    final body = jsonEncode({"friendUuid": user.uuid});
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    var res = await http.post(
        "$SERVER_IP/api/friend",
        headers: headers,
        body: body
    );

    if(res.statusCode != 200) {
      throw Exception('Error adding this friend');
    }
    return null;
  }

  Future<User> searchUser(String username) async {
    print('searchUser');
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    var res = await http.get(
        "$SERVER_IP/api/account?username=$username",
        headers: headers
    );
    print(res.body);
    if (res.statusCode == 200) {
      return User.fromJson(json.decode(res.body));
    }
    else if(res.statusCode == 400){
      throw Exception('No user found');
    }
    else {
      throw Exception('Failed to load user');
    }
  }

//  Future<String> getMyFriends() async {
//    Map<String, String> headers = {
//      'Content-Type': 'application/json; charset=UTF-8'
//    };
//    var res = await http.get(
//        "$SERVER_IP/api/friend/",
//        headers: headers
//    );
//
//    if(res.statusCode == 200) {
//      return res.headers["authorization"];
//    }
//    return null;
//  }



  @override
  Widget build(BuildContext context) {

    ListTile makeListTile(User lesson) => ListTile(
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
        lesson.username,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(lesson.mail,
                    style: TextStyle(color: Colors.white))),
          )
        ],
      ),
      trailing:
      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage()));
      },
    );

    Card makeCard(User lesson) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(lesson),
      ),
    );

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(users[index]);
        },
      ),
    );

    final floatButton = FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Username'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: friendController,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Submit"),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      addFriend(friendController.text) ;
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
            },
          child: Icon(Icons.group_add),
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: makeBody,
      floatingActionButton: floatButton,
    );

  }
}

List getUsers() {
  return [
    User(
        username: "Romain",
        mail: "romain.boilleau@gmail.com"),
    User(
        username: "Romain",
        mail: "romain.boilleau@gmail.com"),
    User(
        username: "Romain",
        mail: "romain.boilleau@gmail.com"),
    User(
        username: "Romainr",
        mail: "romain.boilleau@gmail.com"),
    User(
        username: "Romain",
        mail: "romain.boilleau@gmail.com"),
    User(
        username: "Romain",
        mail: "romain.boilleau@gmail.com"),
    User(
        username: "Romain",
        mail: "romain.boilleau@gmail.com"),
  ];
}