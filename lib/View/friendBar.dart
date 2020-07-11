import 'package:flutter/material.dart';
import 'package:mobileappflutter/View/friendList.dart';
import 'pendingFriend.dart';

class FriendBar extends StatefulWidget {

  @override
  _FriendBarState createState() => _FriendBarState();
}

class _FriendBarState extends State<FriendBar> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: PreferredSize(
          preferredSize: new Size(200, 30),
          child: TabBar(
            tabs: [
              Tab(
                  icon: Icon(Icons.person)
              ),
              Tab(
                  icon: Icon(Icons.mail)
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendListPage(),
            PendingFriendPage()
          ],
        ),
      ),
    );
  }

}