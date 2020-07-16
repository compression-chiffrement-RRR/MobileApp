import 'package:flutter/material.dart';
import 'package:mobileappflutter/View/friend_list.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'pending_friend.dart';

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
        backgroundColor: AppColor.mainColor,
        appBar: PreferredSize(
          preferredSize: new Size(200, 30),
          child: TabBar(
            indicatorColor: AppColor.thirdColor,
            tabs: [
              Tab(
                icon: Icon(Icons.person),
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