class ReasonListResponse {
  ReasonListResponse({
    required this.statusCode,
    required this.flag,
    required this.flagMsg,
    required this.data,
  });

  final int statusCode;
  final int flag;
  final String flagMsg;
  final List<ReasonInformation> data;

  factory ReasonListResponse.fromJson(Map<String, dynamic> json){
    return ReasonListResponse(
      statusCode: json["StatusCode"] ?? 0,
      flag: json["Flag"] ?? 0,
      flagMsg: json["Flag_Msg"] ?? "",
      data: json["Data"] == null ? [] : List<ReasonInformation>.from(json["Data"]!.map((x) => ReasonInformation.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "StatusCode": statusCode,
    "Flag": flag,
    "Flag_Msg": flagMsg,
    "Data": data.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$statusCode, $flag, $flagMsg, $data, ";
  }
}

class ReasonInformation {
  ReasonInformation({
    required this.codeId,
    required this.codeDescription,
  });

  final int codeId;
  final String codeDescription;

  factory ReasonInformation.fromJson(Map<String, dynamic> json){
    return ReasonInformation(
      codeId: json["CodeId"] ?? 0,
      codeDescription: json["CodeDescription"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "CodeId": codeId,
    "CodeDescription": codeDescription,
  };

  @override
  String toString(){
    return "$codeId, $codeDescription, ";
  }
}
