class BulkPickupResponse {
  BulkPickupResponse({
    required this.flag,
    required this.flagMessage,
    required this.data,
  });

  final bool? flag;
  final String? flagMessage;
  final Data? data;

  factory BulkPickupResponse.fromJson(Map<String, dynamic> json) {
    return BulkPickupResponse(
      flag: json["Flag"],
      flagMessage: json["FlagMessage"],
      data: json["Data"] == null ? null : Data.fromJson(json["Data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "Flag": flag,
        "FlagMessage": flagMessage,
        "Data": data?.toJson(),
      };

  @override
  String toString() {
    return "$flag, $flagMessage, $data, ";
  }
}

class Data {
  Data({
    required this.trackingNumberList,
  });

  final List<TrackingNumberList> trackingNumberList;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      trackingNumberList: json["TrackingNumberList"] == null
          ? []
          : List<TrackingNumberList>.from(json["TrackingNumberList"]!
              .map((x) => TrackingNumberList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "TrackingNumberList":
            trackingNumberList.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$trackingNumberList, ";
  }
}

class TrackingNumberList {
  TrackingNumberList({
    required this.odnId,
    required this.trackingNumber,
    required this.pickupLocationName,
    required this.dropLocationName,
    required this.masterNumber,
  });

  final int? odnId;
  final String? trackingNumber;
  final String? pickupLocationName;
  final String? dropLocationName;
  final dynamic masterNumber;

  factory TrackingNumberList.fromJson(Map<String, dynamic> json) {
    return TrackingNumberList(
      odnId: json["OdnId"],
      trackingNumber: json["TrackingNumber"],
      pickupLocationName: json["PickupLocationName"] ?? '',
      dropLocationName: json["DropLocationName"],
      masterNumber: json["MasterNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
        "OdnId": odnId,
        "TrackingNumber": trackingNumber,
        "PickupLocationName": pickupLocationName,
        "DropLocationName": dropLocationName,
        "MasterNumber": masterNumber,
      };

  @override
  String toString() {
    return "$odnId, $trackingNumber, $pickupLocationName, $dropLocationName, $masterNumber, ";
  }
}
class ValidateTrackingResponse {
    Result? result;
    TrackingNumberData? data;

  ValidateTrackingResponse({this.result, this.data});

  // Factory method to parse JSON
  factory ValidateTrackingResponse.fromJson(Map<String, dynamic> json) {
    return ValidateTrackingResponse(
      result: json['Result'] != null ? Result.fromJson(json['Result']) : null,
      data: json['Data'] != null ? TrackingNumberData.fromJson(json['Data']) : null,
    );
  }

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'Result': result?.toJson(),
      'Data': data?.toJson(),
    };
  }
}

class Result {
  final bool? flag;
  final String? flagMessage;

  Result({this.flag, this.flagMessage});

  // Factory method to parse JSON
  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      flag: json['Flag'],
      flagMessage: json['FlagMessage'],
    );
  }

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'Flag': flag,
      'FlagMessage': flagMessage,
    };
  }
}

class TrackingNumberData {
  final int? odnId;
  final String? trackingNumber;
  final String? ndrReason;

  TrackingNumberData({this.odnId, this.trackingNumber, this.ndrReason});

  // Factory method to parse JSON
  factory TrackingNumberData.fromJson(Map<String, dynamic> json) {
    return TrackingNumberData(
      odnId: json['OdnId'],
      trackingNumber: json['TrackingNumber'],
      ndrReason: json['NdrReason'],
    );
  }

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'OdnId': odnId,
      'TrackingNumber': trackingNumber,
      'NdrReason': ndrReason,
    };
  }
}
