class AppVersionRequest {
  AppVersionRequest({
    required this.apikey,
    required this.clientId,
    required this.clientName,
    required this.type,
  });

  final String? apikey;
  final String? clientId;
  final String? clientName;
  final String? type;

  factory AppVersionRequest.fromJson(Map<String, dynamic> json){
    return AppVersionRequest(
      apikey: json["APIKEY"],
      clientId: json["CLIENT_ID"],
      clientName: json["CLIENT_NAME"],
      type: json["Type"],
    );
  }

  Map<String, dynamic> toJson() => {
    "APIKEY": apikey,
    "CLIENT_ID": clientId,
    "CLIENT_NAME": clientName,
    "Type": type,
  };

  @override
  String toString(){
    return "$apikey, $clientId, $clientName, $type, ";
  }
}
