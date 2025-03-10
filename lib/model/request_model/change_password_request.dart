class ChangePasswordRequest {
  ChangePasswordRequest({
    required this.userName,
    required this.oldPassword,
    required this.newPassword,
    required this.clientId,
    required this.clientName,
  });

  final String? userName;
  final String? oldPassword;
  final String? newPassword;
  final String? clientId;
  final String? clientName;

  ChangePasswordRequest copyWith({
    String? userName,
    String? oldPassword,
    String? newPassword,
    String? clientId,
    String? clientName,
  }) {
    return ChangePasswordRequest(
      userName: userName ?? this.userName,
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
    );
  }

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    return ChangePasswordRequest(
      userName: json["userName"],
      oldPassword: json["oldPassword"],
      newPassword: json["newPassword"],
      clientId: json["CLIENT_ID"],
      clientName: json["CLIENT_NAME"],
    );
  }

  Map<String, dynamic> toJson() => {
    "userName": userName,
    "oldPassword": oldPassword,
    "newPassword": newPassword,
    "CLIENT_ID": clientId,
    "CLIENT_NAME": clientName,
  };
}
