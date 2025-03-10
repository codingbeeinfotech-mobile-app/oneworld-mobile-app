class PayPhiGenerateQrResponse {
  PayPhiGenerateQrResponse({
    required this.respHeader,
    required this.respBody,
  });

  final RespHeader? respHeader;
  final RespBody? respBody;

  factory PayPhiGenerateQrResponse.fromJson(Map<String, dynamic> json){
    return PayPhiGenerateQrResponse(
      respHeader: json["respHeader"] == null ? null : RespHeader.fromJson(json["respHeader"]),
      respBody: json["respBody"] == null ? null : RespBody.fromJson(json["respBody"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "respHeader": respHeader?.toJson(),
    "respBody": respBody?.toJson(),
  };

  @override
  String toString(){
    return "$respHeader, $respBody, ";
  }
}

class RespBody {
  RespBody({
    required this.merchantId,
    required this.aggregatorId,
    required this.merchantRefNo,
    required this.bharatQr,
    required this.upiQr,
    required this.expiry,
    required this.serviceChargeUpi,
    required this.serviceChargeBharatQr,
  });

  final String? merchantId;
  final dynamic aggregatorId;
  final String? merchantRefNo;
  final dynamic bharatQr;
  final String? upiQr;
  final String? expiry;
  final String? serviceChargeUpi;
  final dynamic serviceChargeBharatQr;

  factory RespBody.fromJson(Map<String, dynamic> json){
    return RespBody(
      merchantId: json["merchantID"] ?? "",
      aggregatorId: json["aggregatorID"] ?? "",
      merchantRefNo: json["merchantRefNo"] ?? "",
      bharatQr: json["bharatQR"] ?? "",
      upiQr: json["upiQR"] ?? "",
      expiry: json["expiry"] ?? "",
      serviceChargeUpi: json["serviceChargeUPI"] ?? "",
      serviceChargeBharatQr: json["serviceChargeBharatQR"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "merchantID": merchantId,
    "aggregatorID": aggregatorId,
    "merchantRefNo": merchantRefNo,
    "bharatQR": bharatQr,
    "upiQR": upiQr,
    "expiry": expiry,
    "serviceChargeUPI": serviceChargeUpi,
    "serviceChargeBharatQR": serviceChargeBharatQr,
  };

  @override
  String toString(){
    return "$merchantId, $aggregatorId, $merchantRefNo, $bharatQr, $upiQr, $expiry, $serviceChargeUpi, $serviceChargeBharatQr, ";
  }
}

class RespHeader {
  RespHeader({
    required this.returnCode,
    required this.desc,
    required this.upiRespDesc,
  });

  final int? returnCode;
  final String? desc;
  final String? upiRespDesc;

  factory RespHeader.fromJson(Map<String, dynamic> json){
    return RespHeader(
      returnCode: json["returnCode"] ?? "",
      desc: json["desc"] ?? "",
      upiRespDesc: json["upiRespDesc"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "returnCode": returnCode,
    "desc": desc,
    "upiRespDesc": upiRespDesc,
  };

  @override
  String toString(){
    return "$returnCode, $desc, $upiRespDesc, ";
  }
}
