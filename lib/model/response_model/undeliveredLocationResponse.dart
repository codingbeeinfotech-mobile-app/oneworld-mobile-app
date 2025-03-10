class NdrByLocationResponse {
  NdrByLocationResponse({
    required this.result,
    required this.data,
  });

  final Result? result;
  final List<Datum> data;

  factory NdrByLocationResponse.fromJson(Map<String, dynamic> json){
    return NdrByLocationResponse(
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
    required this.transporterLocation,
    required this.transporterLocationId,
  });

  final int? odnId;
  final String? trackingNumber;
  final String? transporterId;
  final String? transporterLocation;
  final int? transporterLocationId;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
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
