class ValidatePickupResponse {
  ValidatePickupResponse({
    required this.result,
    required this.data,
  });

  final Result? result;
  final Data? data;

  factory ValidatePickupResponse.fromJson(Map<String, dynamic> json){
    return ValidatePickupResponse(
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
    required this.pickupLocation,
    required this.productType,
    required this.productDescription,
    required this.productImage,
    required this.qualityCheck,
    required this.returnReason,
    required this.droplocation,
    required this.pickupCustomerName,
    required this.pickupLocationContactNumber,
    required this.receiverEmailId,
    required this.totalAmount,
    required this.driverId,
  });

  final int? odnId;
  final String? trackingNumber;
  final String? transporterId;
  final String? pickupLocation;
  final String? productType;
  final String? productDescription;
  late final String? productImage;
  final String? qualityCheck;
  final String? returnReason;
  final String? droplocation;
  final String? pickupCustomerName;
  final String? pickupLocationContactNumber;
  final dynamic receiverEmailId;
  final double? totalAmount;
  final int? driverId;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      odnId: json["OdnId"],
      trackingNumber: json["TrackingNumber"],
      transporterId: json["TransporterId"],
      pickupLocation: json["PickupLocation"],
      productType: json["ProductType"],
      productDescription: json["ProductDescription"],
      productImage: json["ProductImage"],
      qualityCheck: json["QualityCheck"],
      returnReason: json["ReturnReason"],
      droplocation: json["Droplocation"],
      pickupCustomerName: json["PickupCustomerName"],
      pickupLocationContactNumber: json["PickupLocationContactNumber"],
      receiverEmailId: json["ReceiverEmailId"],
      totalAmount: json["TotalAmount"],
      driverId: json["DriverId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "OdnId": odnId,
    "TrackingNumber": trackingNumber,
    "TransporterId": transporterId,
    "PickupLocation": pickupLocation,
    "ProductType": productType,
    "ProductDescription": productDescription,
    "ProductImage": productImage,
    "QualityCheck": qualityCheck,
    "ReturnReason": returnReason,
    "Droplocation": droplocation,
    "PickupCustomerName": pickupCustomerName,
    "PickupLocationContactNumber": pickupLocationContactNumber,
    "ReceiverEmailId": receiverEmailId,
    "TotalAmount": totalAmount,
    "DriverId": driverId,
  };

  @override
  String toString(){
    return "$odnId, $trackingNumber, $transporterId, $pickupLocation, $productType, $productDescription, $productImage, $qualityCheck, $returnReason, $droplocation, $pickupCustomerName, $pickupLocationContactNumber, $receiverEmailId, $totalAmount, $driverId, ";
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
