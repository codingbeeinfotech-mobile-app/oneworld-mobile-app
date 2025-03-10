class ValidateTrackingNumberResponse {
  ValidateTrackingNumberResponse({
    required this.result,
    required this.data,
  });

  final Result? result;
  final ValidTrackingNumberProduct? data;

  factory ValidateTrackingNumberResponse.fromJson(Map<String, dynamic> json) {
    return ValidateTrackingNumberResponse(
      result: json["Result"] == null ? null : Result.fromJson(json["Result"]),
      data: json["Data"] == null
          ? null
          : ValidTrackingNumberProduct.fromJson(json["Data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "Result": result?.toJson(),
        "Data": data?.toJson(),
      };

  @override
  String toString() {
    return "$result, $data, ";
  }
}

class ValidTrackingNumberProduct {
  ValidTrackingNumberProduct({
    required this.isRto,
    required this.otp,
    required this.odnId,
    required this.trackingNumber,
    required this.transporterId,
    required this.transporterLocation,
    required this.transporterLocationId,
    required this.receiverName,
    required this.receiverPhoneNo,
    required this.receiverEmailId,
    required this.totalAmount,
    required this.codValue,
    required this.driverId,
  });

  final int isRto;
  final int otp;
  final int odnId;
  final String trackingNumber;
  final String transporterId;
  final String transporterLocation;
  final int transporterLocationId;
  final dynamic receiverName;
  final String receiverPhoneNo;
  final dynamic receiverEmailId;
  final double totalAmount;
  final double codValue;
  final int driverId;

  factory ValidTrackingNumberProduct.fromJson(Map<String, dynamic> json) {
    return ValidTrackingNumberProduct(
      isRto: (json.containsKey("isRto")) ? (json["isRto"] ?? 0) : 0,
      otp: json["Otp"] ?? 0,
      odnId: json["OdnId"] ?? 0,
      trackingNumber: json["TrackingNumber"] ?? "",
      transporterId: json["TransporterId"] ?? "",
      transporterLocation: json["TransporterLocation"] ?? "",
      transporterLocationId: json["TransporterLocationId"] ?? 0,
      receiverName: json["ReceiverName"],
      receiverPhoneNo: json["ReceiverPhoneNo"] ?? "",
      receiverEmailId: json["ReceiverEmailId"],
      totalAmount: json["TotalAmount"] ?? 0,
      codValue: json["CodValue"] ?? 0,
      driverId: json["DriverId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "isRto": isRto,
        "Otp": otp,
        "OdnId": odnId,
        "TrackingNumber": trackingNumber,
        "TransporterId": transporterId,
        "TransporterLocation": transporterLocation,
        "TransporterLocationId": transporterLocationId,
        "ReceiverName": receiverName,
        "ReceiverPhoneNo": receiverPhoneNo,
        "ReceiverEmailId": receiverEmailId,
        "TotalAmount": totalAmount,
        "CodValue": codValue,
        "DriverId": driverId,
      };

  @override
  String toString() {
    return "$isRto, $otp, $odnId, $trackingNumber, $transporterId, $transporterLocation, $transporterLocationId, $receiverName, $receiverPhoneNo, $receiverEmailId, $totalAmount, $codValue, $driverId, ";
  }
}

class Result {
  Result({
    required this.flag,
    required this.flagMessage,
  });

  final bool flag;
  final String flagMessage;

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      flag: json["Flag"] ?? false,
      flagMessage: json["FlagMessage"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "Flag": flag,
        "FlagMessage": flagMessage,
      };

  @override
  String toString() {
    return "$flag, $flagMessage, ";
  }
}
