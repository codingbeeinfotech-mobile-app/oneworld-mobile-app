class BulkPickUpSubmitRequest {
  BulkPickUpSubmitRequest({
    required this.defaultParam,
    required this.param,
  });

  final DefaultParam? defaultParam;
  final List<Param> param;

  factory BulkPickUpSubmitRequest.fromJson(Map<String, dynamic> json){
    return BulkPickUpSubmitRequest(
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
    required this.userId,
    required this.roleId,
  });

  final int? clientId;
  final String? clientName;
  final int? userId;
  final int? roleId;

  factory DefaultParam.fromJson(Map<String, dynamic> json){
    return DefaultParam(
      clientId: json["ClientId"],
      clientName: json["ClientName"],
      userId: json["UserId"],
      roleId: json["RoleId"],
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
    required this.trackingNoStatus,
  });

  late final int? odnId;
  late final String? trackingNoStatus;

  factory Param.fromJson(Map<String, dynamic> json){
    return Param(
      odnId: json["OdnId"],
      trackingNoStatus: json["TrackingNoStatus"],
    );
  }

  Map<String, dynamic> toJson() => {
    "OdnId": odnId,
    "TrackingNoStatus": trackingNoStatus,
  };

  @override
  String toString(){
    return "$odnId, $trackingNoStatus, ";
  }
}



class SubmitNdrDelivery {
  List<SubmitNdrDeliveryParam> param;

  SubmitNdrDelivery({
    required this.param,
  });

  factory SubmitNdrDelivery.fromJson(Map<String, dynamic> json) => SubmitNdrDelivery(
    param: List<SubmitNdrDeliveryParam>.from(json["Param"].map((x) => SubmitNdrDeliveryParam.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Param": List<dynamic>.from(param.map((x) => x.toJson())),
  };
}

class SubmitNdrDeliveryParam {
  int odnId;
  String employeeId;
  String signature;
  String picture;
  int latitude;
  int longitude;

  SubmitNdrDeliveryParam({
    required this.odnId,
    required this.employeeId,
    required this.signature,
    required this.picture,
    required this.latitude,
    required this.longitude,
  });

  factory SubmitNdrDeliveryParam.fromJson(Map<String, dynamic> json) => SubmitNdrDeliveryParam(
    odnId: json["OdnId"],
    employeeId: json["EmployeeId"],
    signature: json["Signature"],
    picture: json["Picture"],
    latitude: json["Latitude"],
    longitude: json["Longitude"],
  );

  Map<String, dynamic> toJson() => {
    "OdnId": odnId,
    "EmployeeId": employeeId,
    "Signature": signature,
    "Picture": picture,
    "Latitude": latitude,
    "Longitude": longitude,
  };
}
