class UnprocessFile {
  String uuid;
  String password;

  UnprocessFile(this.uuid, this.password);

  Map<String, dynamic> toJson() =>
      {
        'uuid': uuid,
        'password': password
      };
}
