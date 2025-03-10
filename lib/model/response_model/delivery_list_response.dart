class DeliveryListResponse {
  DeliveryListResponse({
    required this.result,
    required this.data,
  });

  final Result? result;
  final List<Data> data;

  factory DeliveryListResponse.fromJson(Map<String, dynamic> json){
    return DeliveryListResponse(
      result: json["Result"] == null ? null : Result.fromJson(json["Result"]),
      data: json["Data"] == null ? [] : List<Data>.from(json["Data"]!.map((x) => Data.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "Result": result?.toJson(),
    "Data": data.map((x) => x.toJson()).toList(),
  };

}

class Data {
  Data({
    required this.odnId,
    required this.trackingNumber,
    required this.transporterId,
    required this.transporterLocation,
    required this.transporterLocationId,
    required this.orderType,
    required this.codAmount,
    required this.masterNumber,
  });

  final int? odnId;
  final String? trackingNumber;
  final String? transporterId;
  final String? transporterLocation;
  final int? transporterLocationId;
  final String? orderType;
  final double? codAmount;
  final String? masterNumber;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      odnId: json["OdnId"],
      trackingNumber: json["TrackingNumber"],
      transporterId: json["TransporterId"],
      transporterLocation: json["TransporterLocation"],
      transporterLocationId: json["TransporterLocationId"],
      orderType: json["OrderType"],
      codAmount: json["CodAmount"],
      masterNumber: json["MasterNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
    "OdnId": odnId,
    "TrackingNumber": trackingNumber,
    "TransporterId": transporterId,
    "TransporterLocation": transporterLocation,
    "TransporterLocationId": transporterLocationId,
    "OrderType": orderType,
    "CodAmount": codAmount,
    "MasterNumber": masterNumber,
  };

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
      flag: json["Flag"],
      flagMessage: json["FlagMessage"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Flag": flag,
    "FlagMessage": flagMessage,
  };

}
