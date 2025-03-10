// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

class UserModel {
  List<UserDatum> data;

  UserModel({
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    data: List<UserDatum>.from(json["data"].map((x) => UserDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class UserDatum {
  String userId;
  String userName;
  String name;

  UserDatum({
    required this.userId,
    required this.userName,
    required this.name,
  });

  factory UserDatum.fromJson(Map<String, dynamic> json) => UserDatum(
    userId: json["UserId"],
    userName: json["UserName"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "UserName": userName,
    "Name": name,
  };
}