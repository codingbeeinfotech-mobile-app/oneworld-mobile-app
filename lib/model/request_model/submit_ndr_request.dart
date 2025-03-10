class SubmitNdrRequest {
  SubmitNdrRequest({
    required this.defaultParam,
    required this.param,
  });

  final DefaultParam? defaultParam;
  final List<Param> param;

  factory SubmitNdrRequest.fromJson(Map<String, dynamic> json){
    return SubmitNdrRequest(
      defaultParam: json["DefaultParam"] == null ? null : DefaultParam.fromJson(json["DefaultParam"]),
      param: json["Param"] == null ? [] : List<Param>.from(json["Param"]!.map((x) => Param.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "DefaultParam": defaultParam?.toJson(),
    "Param": param.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$defaultParam, $param, ";
  }
}

class DefaultParam {
  DefaultParam({
    required this.clientId,
    required this.clientName,
  });

  final String? clientId;
  final String? clientName;

  factory DefaultParam.fromJson(Map<String, dynamic> json){
    return DefaultParam(
      clientId: json["ClientId"],
      clientName: json["ClientName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "ClientName": clientName,
  };

  @override
  String toString(){
    return "$clientId, $clientName, ";
  }
}

class Param {
  Param({
    required this.employeeId,
    required this.odnId,
    required this.picture,
    required this.receiverName,
    required this.receiverPhoneNo,
    required this.signature,
  });

  final String? employeeId;
  final String? odnId;
  final String? picture;
  final String? receiverName;
  final String? receiverPhoneNo;
  final String? signature;

  factory Param.fromJson(Map<String, dynamic> json){
    return Param(
      employeeId: json["EmployeeId"],
      odnId: json["OdnId"],
      picture: json["Picture"],
      receiverName: json["ReceiverName"],
      receiverPhoneNo: json["ReceiverPhoneNo"],
      signature: json["Signature"],
    );
  }

  Map<String, dynamic> toJson() => {
    "EmployeeId": employeeId,
    "OdnId": odnId,
    "Picture": picture,
    "ReceiverName": receiverName,
    "ReceiverPhoneNo": receiverPhoneNo,
    "Signature": signature,
  };

  @override
  String toString(){
    return "$employeeId, $odnId, $picture, $receiverName, $receiverPhoneNo, $signature, ";
  }
}
