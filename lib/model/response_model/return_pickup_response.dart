class ReturnPickupResponse {
  ReturnPickupResponse({
    required this.result,
    required this.data,
  });

  final Result? result;
  final List<Datum> data;

  factory ReturnPickupResponse.fromJson(Map<String, dynamic> json){
    return ReturnPickupResponse(
      result: json["Result"] == null ? null : Result.fromJson(json["Result"]),
      data: json["Data"] == null ? [] : List<Datum>.from(json["Data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "Result": result?.toJson(),
    "Data": data.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$result, $data, ";
  }
}

class Datum {
  Datum({
    required this.odnId,
    required this.trackingNumber,
    required this.transporterId,
    required this.pickupLocation,
    required this.pickupLocationId,
    required this.pickupCustomerName,
    required this.orderType,
    required this.codAmount,
  });

  final int? odnId;
  final String? trackingNumber;
  final String? transporterId;
  final String? pickupLocation;
  final int? pickupLocationId;
  final String? pickupCustomerName;
  final String? orderType;
  final double? codAmount;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      odnId: json["OdnId"] ?? "",
      trackingNumber: json["TrackingNumber"] ?? "",
      transporterId: json["TransporterId"] ?? "",
      pickupLocation: json["PickupLocation"] ?? "",
      pickupLocationId: json["PickupLocationId"] ?? "",
      pickupCustomerName: json["PickupCustomerName"] ?? "",
      orderType: json["OrderType"] ?? "",
      codAmount: json["CodAmount"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "OdnId": odnId,
    "TrackingNumber": trackingNumber,
    "TransporterId": transporterId,
    "PickupLocation": pickupLocation,
    "PickupLocationId": pickupLocationId,
    "PickupCustomerName": pickupCustomerName,
    "OrderType": orderType,
    "CodAmount": codAmount,
  };

  @override
  String toString(){
    return "$odnId, $trackingNumber, $transporterId, $pickupLocation, $pickupLocationId, $pickupCustomerName, $orderType, $codAmount, ";
  }
}

class Result {
  Result({
    required this.flag,
    required this.flagMessage,
  });

  final bool? flag;
  final String? flagMessage;

  factory Result.fromJson(Map<String, dynamic> json){
    return Result(
      flag: json["Flag"] ?? "",
      flagMessage: json["FlagMessage"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Flag": flag,
    "FlagMessage": flagMessage,
  };

  @override
  String toString(){
    return "$flag, $flagMessage, ";
  }
}
