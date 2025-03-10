class ChangePasswordResponse {
  ChangePasswordResponse({
    required this.userName,
    required this.otp,
    required this.oldPassword,
    required this.newPassword,
    required this.result,
    required this.resultFlag,
    required this.clientId,
    required this.clientName,
    required this.type,
  });

  final dynamic userName;
  final dynamic otp;
  final dynamic oldPassword;
  final dynamic newPassword;
  final String? result;
  final String? resultFlag;
  final dynamic clientId;
  final dynamic clientName;
  final dynamic type;

  ChangePasswordResponse copyWith({
    dynamic userName,
    dynamic otp,
    dynamic oldPassword,
    dynamic newPassword,
    String? result,
    String? resultFlag,
    dynamic clientId,
    dynamic clientName,
    dynamic type,
  }) {
    return ChangePasswordResponse(
      userName: userName ?? this.userName,
      otp: otp ?? this.otp,
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      result: result ?? this.result,
      resultFlag: resultFlag ?? this.resultFlag,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      type: type ?? this.type,
    );
  }

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      userName: json["UserName"],
      otp: json["OTP"],
      oldPassword: json["OldPassword"],
      newPassword: json["NewPassword"],
      result: json["Result"],
      resultFlag: json["ResultFlag"],
      clientId: json["CLIENT_ID"],
      clientName: json["CLIENT_NAME"],
      type: json["Type"],
    );
  }

  Map<String, dynamic> toJson() => {
    "UserName": userName,
    "OTP": otp,
    "OldPassword": oldPassword,
    "NewPassword": newPassword,
    "Result": result,
    "ResultFlag": resultFlag,
    "CLIENT_ID": clientId,
    "CLIENT_NAME": clientName,
    "Type": type,
  };
}
