class LoginRequestModel {
  late String loginId;
  late String password;
  late String fcmToken;

  LoginRequestModel({required this.loginId,required this.password,required this.fcmToken});

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    loginId = json['LoginId'];
    password = json['Password'];
    fcmToken = json['FcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LoginId'] = loginId;
    data['Password'] = password;
    data['FcmToken'] = fcmToken;
    return data;
  }
}
