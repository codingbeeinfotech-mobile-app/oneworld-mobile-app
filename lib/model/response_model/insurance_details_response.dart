class InsurancePdfResponse {
  InsurancePdfResponse({
    required this.result,
    required this.data,
  });

  final Result? result;
  final Data? data;

  factory InsurancePdfResponse.fromJson(Map<String, dynamic> json){
    return InsurancePdfResponse(
      result: json["Result"] == null ? null : Result.fromJson(json["Result"]),
      data: json["Data"] == null ? null : Data.fromJson(json["Data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "Result": result?.toJson(),
    "Data": data?.toJson(),
  };

  @override
  String toString(){
    return "$result, $data, ";
  }
}

class Data {
  Data({
    required this.isInsured,
    required this.tdsDocument1,
    required this.tdsDocument2,
    required this.tdsDocument3,
    required this.tdsDocument4,
    required this.ecardDocument,
  });

  final String? isInsured;
  final String? tdsDocument1;
  final String? tdsDocument2;
  final String? tdsDocument3;
  final String? tdsDocument4;
  final String? ecardDocument;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      isInsured: json["IsInsured"] ?? "",
      tdsDocument1: json["TDS_Document1"] ?? "",
      tdsDocument2: json["TDS_Document2"] ?? "",
      tdsDocument3: json["TDS_Document3"] ?? "",
      tdsDocument4: json["TDS_Document4"] ?? "",
      ecardDocument: json["Ecard_Document"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "IsInsured": isInsured,
    "TDS_Document1": tdsDocument1,
    "TDS_Document2": tdsDocument2,
    "TDS_Document3": tdsDocument3,
    "TDS_Document4": tdsDocument4,
    "Ecard_Document": ecardDocument,
  };

  @override
  String toString(){
    return "$isInsured, $tdsDocument1, $tdsDocument2, $tdsDocument3, $tdsDocument4, $ecardDocument, ";
  }
}

class Result {
  Result({
    required this.flag,
    required this.flagMsg,
  });

  final String? flag;
  final String? flagMsg;

  factory Result.fromJson(Map<String, dynamic> json){
    return Result(
      flag: json["Flag"] ?? "",
      flagMsg: json["Flag_Msg"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Flag": flag,
    "Flag_Msg": flagMsg,
  };

  @override
  String toString(){
    return "$flag, $flagMsg, ";
  }
}
