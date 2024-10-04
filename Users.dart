import 'dart:convert';

List<Users> usersFromJson(String str) => List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  int? id;
  String? username;
  String? password;

  Users({
    this.id,
    this.username,
    this.password,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
      };
}
