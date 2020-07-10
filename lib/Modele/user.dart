class User {
  String uuid;
  String username;
  String email;

  User(
      {this.uuid, this.username, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'],
      username: json['username'],
      email: json['email'],
    );
  }
}