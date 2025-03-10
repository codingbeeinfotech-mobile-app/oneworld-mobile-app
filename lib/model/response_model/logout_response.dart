class LogOutResponse {
  late String flag;
  late String flagMsg;

  LogOutResponse({required this.flag, required this.flagMsg});

  LogOutResponse.fromJson(Map<String, dynamic> json) {
    flag = json['Flag'].toString() ?? "";
    flagMsg = json['FlagMsg'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Flag'] = flag;
    data['FlagMsg'] = flagMsg;
    return data;
  }
}
