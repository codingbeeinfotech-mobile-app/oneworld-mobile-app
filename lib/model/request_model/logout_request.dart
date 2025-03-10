class LogOutRequest {
  LogOutRequest({
    required this.userName,
    required this.userPassword,
    required this.userid,required this.fcmToken
  });

  final String? userName;
  final String? userPassword;
  final String? userid;
  late String fcmToken;


  LogOutRequest copyWith({
    String? userName,
    String? userPassword,
    String? userid,
    String? fcmToken,
  }) {
    return LogOutRequest(
      userName: userName ?? this.userName,
      userPassword: userPassword ?? this.userPassword,
      userid: userid ?? this.userid,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  factory LogOutRequest.fromJson(Map<String, dynamic> json) {
    return LogOutRequest(
      userName: json["UserName"],
      userPassword: json["UserPassword"],
      userid: json["UserId"],
fcmToken: json["FcmToken"],

);
  }

  Map<String, dynamic> toJson() => {
        "UserName": userName,
        "UserPassword": userPassword,
        "UserId": userid,
        "FcmToken": fcmToken,
      };
}
