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

  Map<String, String> toObject(){
    return {"uuid": this.uuid, "username": this.username, "email": this.email};
  }
}