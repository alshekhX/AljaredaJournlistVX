// To parse this JSON data, do
//
//     final userInfo = userInfoFromMap(jsonString);

import 'dart:convert';

class UserInfo {
  UserInfo({
    this.photo,
    this.role,
    this.createdAt,
    this.id,
    this.firstName,
    this.userName,
    this.lastName,
    this.email,
    this.description,
    this.v,
  });

  String? photo;
  String ?role;
  DateTime? createdAt;
  String ?id;
  String ?firstName;
  String ?userName;
  String ?lastName;
  String ?email;
  String ?description;
  int ?v;

  factory UserInfo.fromJson(String str) => UserInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserInfo.fromMap(Map<String, dynamic> json) => UserInfo(
        photo: json["photo"] == null ? null : json["photo"],
        role: json["role"] == null ? null : json["role"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        id: json["_id"] == null ? null : json["_id"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        userName: json["userName"] == null ? null : json["userName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        email: json["email"] == null ? null : json["email"],
                description: json["description"] == null ? null : json["description"],

        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toMap() => {
        "photo": photo == null ? null : photo,
        "role": role == null ? null : role,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "_id": id == null ? null : id,
        "firstName": firstName == null ? null : firstName,
        "userName": userName == null ? null : userName,
        "lastName": lastName == null ? null : lastName,
        "email": email == null ? null : email,
                "description": description == null ? null : description,

        "__v": v == null ? null : v,
      };
}
