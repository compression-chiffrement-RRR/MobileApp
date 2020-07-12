import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/user.dart';
import 'package:mobileappflutter/Service/friend_pending_service.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class PendingFriendPage extends StatefulWidget {

  @override
  _PendingFriendPageState createState() => _PendingFriendPageState();
}

class _PendingFriendPageState extends State<PendingFriendPage>{
  final FriendPendingService _friendPendingService = FriendPendingService();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
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
            caption: 'accept',
            color: Colors.green,
            icon: Icons.check,
            onTap: () async {
              await _friendPendingService.confirmFriend(user);
            },
          ),
        ),
        new Card(
          margin: new EdgeInsets.symmetric(horizontal: 0, vertical: 6.0),
          child: new IconSlideAction(
            caption: 'refuse',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () async {
              await _friendPendingService.ignoreFriend(user);
            },
          ),
        ),
      ],
    );

    final makeBody = Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: RefreshIndicator(
                  child: FutureBuilder(
                      future: _friendPendingService.getCurrentPendingFriendsOrRefresh(),
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
                    await _friendPendingService.refreshCurrentPendingFriends();
                    setState(() {
                    });
                  },
                ),
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

