import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/user.dart';
import 'package:mobileappflutter/Service/Data/friend_repository.dart';

abstract class FriendPendingServiceBase {
  @protected
  List<User> initialPendingFriends;
  @protected
  List<User> statePendingFriends;
  List<User> get currentPendingFriends => statePendingFriends;

  void setStatePendingFriends(List<User> friends) {
    statePendingFriends = friends;
  }

  void reset() {
    statePendingFriends = initialPendingFriends;
  }

  Future<List<User>> refreshCurrentPendingFriends();

  Future<bool> confirmFriend(User friend);

  Future<bool> ignoreFriend(User friend);
}

class FriendPendingService extends FriendPendingServiceBase {
  static final FriendPendingService _instance = FriendPendingService._internal();
  static final FriendRepository _friendRepository = FriendRepository();

  factory FriendPendingService() {
    return _instance;
  }

  FriendPendingService._internal() {
    initialPendingFriends = new List<User>();
    statePendingFriends = initialPendingFriends;
  }

  @override
  Future<List<User>> refreshCurrentPendingFriends() async {
    List<User> friends = await _friendRepository.getMyFriends();
    setStatePendingFriends(friends);
    return currentPendingFriends;
  }

  @override
  Future<bool> confirmFriend(User friend) async {
    bool success = await _friendRepository.confirmFriend(friend.uuid);
    if (success && currentPendingFriends.contains(friend)) {
      currentPendingFriends.remove(friend);
    }
    return success;
  }

  @override
  Future<bool> ignoreFriend(User friend) async {
    bool success = await _friendRepository.ignoreFriend(friend.uuid);
    if (success && currentPendingFriends.contains(friend)) {
      currentPendingFriends.remove(friend);
    }
    return success;
  }
}