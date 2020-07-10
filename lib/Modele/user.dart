class User {
  String uuid;
  String username;
  String mail;

  User(
      {this.uuid, this.username, this.mail});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'],
      username: json['username'],
      mail: json['mail'],
    );
  }
}