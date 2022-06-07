// To parse this JSON data, do
//
//     final articleModel = articleModelFromMap(jsonString);

import 'dart:convert';

class ArticleModel {
    ArticleModel({
        this.approved,
        this.category,
        this.articletype,
        this.photo,
        this.video,
        this.audio,
        this.id,
        this.title,
        this.place,
        this.user,
        this.assets,
        this.description,
        this.createdAt,
        this.publishedAt,
        this.v,
    });

    bool? approved;
    List<String>? category;
    List<String>? articletype;
        List? assets;

    String? photo;
    String? video;
    String? audio;
    String? id;
    String? title;
    String? place;
    User ?user;
    String? description;
    DateTime? createdAt;
    DateTime? publishedAt;
    int ?v;

    factory ArticleModel.fromJson(String str) => ArticleModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ArticleModel.fromMap(Map<String, dynamic> json) => ArticleModel(
        approved: json["approved"] == null ? null : json["approved"],
        category: json["category"] == null ? null : List<String>.from(json["category"].map((x) => x)),
        articletype: json["articletype"] == null ? null : List<String>.from(json["articletype"].map((x) => x)),
        photo: json["photo"] == null ? null : json["photo"],
                assets: json["assets"] == null ? [] : json["assets"],

        video: json["video"] == null ? null : json["video"],
        audio: json["audio"] == null ? null : json["audio"],
        id: json["_id"] == null ? null : json["_id"],
        title: json["title"] == null ? null : json["title"],
        place: json["place"] == null ? null : json["place"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        description: json["description"] == null ? null : json["description"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
        v: json["__v"] == null ? null : json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "approved": approved == null ? null : approved,
        "category": category == null ? null : List<dynamic>.from(category!.map((x) => x)),
        "articletype": articletype == null ? null : List<dynamic>.from(articletype!.map((x) => x)),
        "photo": photo == null ? null : photo,
        "video": video == null ? null : video,
        "audio": audio == null ? null : audio,
        "_id": id == null ? null : id,
        "title": title == null ? null : title,
        "place": place == null ? null : place,
        "user": user == null ? null : user!.toMap(),
        "description": description == null ? null : description,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "publishedAt": publishedAt == null ? null : publishedAt!.toIso8601String(),
        "__v": v == null ? null : v,
    };
}

class User {
    User({
        this.photo,
        this.role,
        this.createdAt,
        this.id,
        this.userName,
        this.firstName,
        this.lastName,
        this.email,
            this.description,

        this.v,
    });

    String ?photo;
    String ?role;
    DateTime? createdAt;
    String ?id;
    String ?userName;
    String ?firstName;
    String ?lastName;
    String ?email;
      String ?description;

    int? v;

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        photo: json["photo"] == null ? null : json["photo"],
        role: json["role"] == null ? null : json["role"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        id: json["_id"] == null ? null : json["_id"],
        userName: json["userName"] == null ? null : json["userName"],
        firstName: json["firstName"] == null ? null : json["firstName"],
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
        "userName": userName == null ? null : userName,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "email": email == null ? null : email,
                        "description": description == null ? null : description,

        "__v": v == null ? null : v,
    };
}
