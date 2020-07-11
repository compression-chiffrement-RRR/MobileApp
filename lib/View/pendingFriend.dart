import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/user.dart';
import 'env.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class PendingFriendPage extends StatefulWidget {

  @override
  _PendingFriendPageState createState() => _PendingFriendPageState();
}

class _PendingFriendPageState extends State<PendingFriendPage>{
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

  Future<List<User>> getMyPendingFriends() async {
    final jwt = await jwtOrEmpty;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": jwt
    };
    var res = await http.get(
        "$SERVER_IP/api/friend/pending",
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

  Future<bool> acceptFriend(fUuid) async {
    final jwt = await jwtOrEmpty;
    final body = jsonEncode({"friendUuid": fUuid});
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": jwt
    };
    var res = await http.post(
        "$SERVER_IP/api/friend/confirmFriend",
        headers: headers,
        body: body
    );
    if(res.statusCode == 200) {

    }
    return null;
  }

  Future<bool> ignoreFriend(fUuid) async {
    final jwt = await jwtOrEmpty;
    final body = jsonEncode({"friendUuid": fUuid});
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": jwt
    };
    var res = await http.post(
        "$SERVER_IP/api/friend/ignoreFriend",
        headers: headers,
        body: body
    );
    if(res.statusCode == 200) {

    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    users = getMyPendingFriends();
  }

  @override
  Widget build(BuildContext context) {

    Slidable slide(User user) => Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: new Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
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
            caption: 'accept',
            color: Colors.green,
            icon: Icons.check,
            onTap: () {
              acceptFriend(user.uuid);
            },
          ),
        ),
        new Card(
          margin: new EdgeInsets.symmetric(horizontal: 0, vertical: 6.0),
          child: new IconSlideAction(
            caption: 'refuse',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              ignoreFriend(user.uuid);
              },
          ),
        ),
      ],
    );

    final makeBody = Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: FutureBuilder(
                    future: getMyPendingFriends(),
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
                            return slide(snapshot.data[index]);
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
    getMyPendingFriends();
  }
}

