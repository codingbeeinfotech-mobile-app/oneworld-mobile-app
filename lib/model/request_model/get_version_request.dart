class VersionCheckRequest {
  VersionCheckRequest({
    required this.clientId,
    required this.clientName,
  });

  final String? clientId;
  final String? clientName;

  factory VersionCheckRequest.fromJson(Map<String, dynamic> json){
    return VersionCheckRequest(
      clientId: json["CLIENT_ID"],
      clientName: json["CLIENT_NAME"],
    );
  }

  Map<String, dynamic> toJson() => {
    "CLIENT_ID": clientId,
    "CLIENT_NAME": clientName,
  };

  @override
  String toString(){
    return "$clientId, $clientName, ";
  }
}
