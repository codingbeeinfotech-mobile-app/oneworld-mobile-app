class ValidatePickupTrackingNoResponse {
  ValidatePickupTrackingNoResponse({
    required this.result,
    required this.data,
  });

  final Result? result;
  final Data? data;

  factory ValidatePickupTrackingNoResponse.fromJson(Map<String, dynamic> json){
    return ValidatePickupTrackingNoResponse(
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
    required this.odnId,
    required this.trackingNumber,
    required this.transporterId,
    required this.transporterLocation,
    required this.transporterLocationId,
  });

  final int? odnId;
  final String? trackingNumber;
  final String? transporterId;
  final String? transporterLocation;
  final int? transporterLocationId;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      odnId: json["OdnId"],
      trackingNumber: json["TrackingNumber"],
      transporterId: json["TransporterId"],
      transporterLocation: json["TransporterLocation"],
      transporterLocationId: json["TransporterLocationId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "OdnId": odnId,
    "TrackingNumber": trackingNumber,
    "TransporterId": transporterId,
    "TransporterLocation": transporterLocation,
    "TransporterLocationId": transporterLocationId,
  };

  @override
  String toString(){
    return "$odnId, $trackingNumber, $transporterId, $transporterLocation, $transporterLocationId, ";
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
      flag: json["Flag"],
      flagMessage: json["FlagMessage"],
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
