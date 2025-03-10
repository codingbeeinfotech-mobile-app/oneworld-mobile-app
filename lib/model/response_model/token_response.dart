class LoginTokenResponse {
  late String accessToken;
  late String tokenType;
  late int expiresIn;
  late String userName;
  late String issued;
  late String expires;

  LoginTokenResponse(
      {required this.accessToken,
      required this.tokenType,
      required this.expiresIn,
      required this.userName,
      required this.issued,
      required this.expires});

  LoginTokenResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'] ?? '';
    tokenType = json['token_type'] ?? '';
    expiresIn = json['expires_in'] ?? "";
    userName = json['userName'] ?? '';
    issued = json['.issued'] ?? '';
    expires = json['.expires'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['userName'] = userName;
    data['.issued'] = issued;
    data['.expires'] = expires;
    return data;
  }

  @override
  String toString() {
    return 'LoginTokenResponse{accessToken: $accessToken, tokenType: $tokenType, expiresIn: $expiresIn, userName: $userName, issued: $issued, expires: $expires}';
  }
}
