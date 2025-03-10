class SubmitNprRequest {
  SubmitNprRequest({
    required this.defaultParam,
    required this.param,
  });

  final DefaultParam? defaultParam;
  final List<Param> param;

  factory SubmitNprRequest.fromJson(Map<String, dynamic> json){
    return SubmitNprRequest(
      defaultParam: json["DefaultParam"] == null ? null : DefaultParam.fromJson(json["DefaultParam"]),
      param: json["Param"] == null ? [] : List<Param>.from(json["Param"]!.map((x) => Param.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "DefaultParam": defaultParam?.toJson(),
    "Param": param.map((x) => x?.toJson()).toList(),
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
    required this.userId,
    required this.roleId,
  });

  final int clientId;
  final String clientName;
  final int userId;
  final int roleId;

  factory DefaultParam.fromJson(Map<String, dynamic> json){
    return DefaultParam(
      clientId: json["ClientId"] ?? 0,
      clientName: json["ClientName"] ?? "",
      userId: json["UserId"] ?? 0,
      roleId: json["RoleId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "ClientName": clientName,
    "UserId": userId,
    "RoleId": roleId,
  };

  @override
  String toString(){
    return "$clientId, $clientName, $userId, $roleId, ";
  }
}

class Param {
  Param({
    required this.odnId,
    required this.nonPickedUpReasonId,
    required this.codeTypeId,
  });

  final int odnId;
  final int nonPickedUpReasonId;
  final String codeTypeId;

  factory Param.fromJson(Map<String, dynamic> json){
    return Param(
      odnId: json["OdnId"] ?? 0,
      nonPickedUpReasonId: json["NonPickedUpReasonId"] ?? 0,
      codeTypeId: json["CodeTypeID"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "OdnId": odnId,
    "NonPickedUpReasonId": nonPickedUpReasonId,
    "CodeTypeID": codeTypeId,
  };

  @override
  String toString(){
    return "$odnId, $nonPickedUpReasonId, $codeTypeId, ";
  }
}
