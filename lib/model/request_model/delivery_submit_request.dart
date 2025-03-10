class SubmitDeliveryRequest {
  SubmitDeliveryRequest({
    required this.defaultParam,
    required this.param,
  });

  final DefaultParam? defaultParam;
  final List<Param> param;

  factory SubmitDeliveryRequest.fromJson(Map<String, dynamic> json){
    return SubmitDeliveryRequest(
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
  });

  final String clientId;
  final String clientName;

  factory DefaultParam.fromJson(Map<String, dynamic> json){
    return DefaultParam(
      clientId: json["ClientId"] ?? "",
      clientName: json["ClientName"] ?? "",
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
    required this.amount,
    required this.deliveryDistance,
    required this.employeeId,
    required this.isPaidOnline,
    required this.isReturn,
    required this.odnId,
    required this.paymentLinkId,
    required this.picture,
    required this.receiverName,
    required this.receiverPhoneNo,
    required this.returnReasonId,
    required this.signature,
    required this.trackingNoStatus,
    required this.unDeliveredReasonId,
    required this.codeTypeId,
  });

  final String amount;
  final double deliveryDistance;
  final String employeeId;
  final bool isPaidOnline;
  final int isReturn;
  final int odnId;
  final String paymentLinkId;
  final String picture;
  final String receiverName;
  final String receiverPhoneNo;
  final int returnReasonId;
  final String signature;
  final String trackingNoStatus;
  final int unDeliveredReasonId;
  final String codeTypeId;

  factory Param.fromJson(Map<String, dynamic> json){
    return Param(
      amount: json["Amount"] ?? "",
      deliveryDistance: json["DeliveryDistance"] ?? 0,
      employeeId: json["EmployeeId"] ?? "",
      isPaidOnline: json["IsPaidOnline"] ?? false,
      isReturn: json["IsReturn"] ?? 0,
      odnId: json["OdnId"] ?? 0,
      paymentLinkId: json["PaymentLinkId"] ?? "",
      picture: json["Picture"] ?? "",
      receiverName: json["ReceiverName"] ?? "",
      receiverPhoneNo: json["ReceiverPhoneNo"] ?? "",
      returnReasonId: json["ReturnReasonId"] ?? 0,
      signature: json["Signature"] ?? "",
      trackingNoStatus: json["TrackingNoStatus"] ?? "",
      unDeliveredReasonId: json["UnDeliveredReasonId"] ?? 0,
      codeTypeId: json["CodeTypeID"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Amount": amount,
    "DeliveryDistance": deliveryDistance,
    "EmployeeId": employeeId,
    "IsPaidOnline": isPaidOnline,
    "IsReturn": isReturn,
    "OdnId": odnId,
    "PaymentLinkId": paymentLinkId,
    "Picture": picture,
    "ReceiverName": receiverName,
    "ReceiverPhoneNo": receiverPhoneNo,
    "ReturnReasonId": returnReasonId,
    "Signature": signature,
    "TrackingNoStatus": trackingNoStatus,
    "UnDeliveredReasonId": unDeliveredReasonId,
    "CodeTypeID": codeTypeId,
  };

  @override
  String toString(){
    return "$amount, $deliveryDistance, $employeeId, $isPaidOnline, $isReturn, $odnId, $paymentLinkId, $picture, $receiverName, $receiverPhoneNo, $returnReasonId, $signature, $trackingNoStatus, $unDeliveredReasonId, $codeTypeId, ";
  }
}
