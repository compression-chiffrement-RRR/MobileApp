import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/user.dart';
import 'package:mobileappflutter/Service/Data/friend_repository.dart';

abstract class FriendServiceBase {
  @protected
  List<User> initialFriends;
  @protected
  List<User> stateFriends;
  List<User> get currentFriends => stateFriends;

  void setStateFriends(List<User> friends) {
    stateFriends = friends;
  }

  void reset() {
    stateFriends = initialFriends;
  }

  Future<List<User>> getCurrentFriendsOrRefresh();

  Future<List<User>> refreshCurrentFriends();

  Future<bool> addFriend(String friendUuid);

  Future<bool> deleteFriend(User friend);
}

class FriendService extends FriendServiceBase {
  static final FriendService _instance = FriendService._internal();
  static final FriendRepository _friendRepository = FriendRepository();

  factory FriendService() {
    return _instance;
  }

  FriendService._internal() {
    initialFriends = new List<User>();
    stateFriends = initialFriends;
  }

  @override
  Future<List<User>> getCurrentFriendsOrRefresh() async {
    if (currentFriends.length > 0) {
      return currentFriends;
    }
    return refreshCurrentFriends();
  }

  @override
  Future<List<User>> refreshCurrentFriends() async {
    List<User> friends = await _friendRepository.getMyFriends();
    setStateFriends(friends);
    return currentFriends;
  }

  @override
  Future<bool> addFriend(String friendUuid) async {
    bool success = await _friendRepository.addFriend(friendUuid);
    return success;
  }

  @override
  Future<bool> deleteFriend(User friend) async {
    bool success = await _friendRepository.deleteFriend(friend.uuid);
    if (success && currentFriends.contains(friend)) {
      currentFriends.remove(friend);
    }
    return success;
  }

}