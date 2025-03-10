class ReturnPickupSubmitRequest {
  ReturnPickupSubmitRequest({
    required this.defaultParam,
    required this.param,
  });

  final DefaultParam? defaultParam;
  final List<Param> param;

  factory ReturnPickupSubmitRequest.fromJson(Map<String, dynamic> json){
    return ReturnPickupSubmitRequest(
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
  });

  final int? clientId;
  final String? clientName;
  final int? userId;

  factory DefaultParam.fromJson(Map<String, dynamic> json){
    return DefaultParam(
      clientId: json["ClientId"],
      clientName: json["ClientName"],
      userId: json["UserId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "ClientName": clientName,
    "UserId": userId,
  };

  @override
  String toString(){
    return "$clientId, $clientName, $userId, ";
  }
}

class Param {
  Param({
    required this.nonPickupReasonId,
    required this.odnId,
    required this.productImageList,
    required this.qualityCheck,
    required this.qualityCheckFailedReasonId,
    required this.trackingNoStatus,
    required this.barcode,
  });

  final int? nonPickupReasonId;
  final int? odnId;
  final List<ProductImageList> productImageList;
  final String? qualityCheck;
  final int? qualityCheckFailedReasonId;
  final String? trackingNoStatus;
  final String? barcode;

  factory Param.fromJson(Map<String, dynamic> json){
    return Param(
      nonPickupReasonId: json["NonPickupReasonId"],
      odnId: json["OdnId"],
      productImageList: json["ProductImageList"] == null ? [] : List<ProductImageList>.from(json["ProductImageList"]!.map((x) => ProductImageList.fromJson(x))),
      qualityCheck: json["QualityCheck"],
      qualityCheckFailedReasonId: json["QualityCheckFailedReasonId"],
      trackingNoStatus: json["TrackingNoStatus"],
      barcode: json["Barcode"],
    );
  }

  Map<String, dynamic> toJson() => {
    "NonPickupReasonId": nonPickupReasonId,
    "OdnId": odnId,
    "ProductImageList": productImageList.map((x) => x.toJson()).toList(),
    "QualityCheck": qualityCheck,
    "QualityCheckFailedReasonId": qualityCheckFailedReasonId,
    "TrackingNoStatus": trackingNoStatus,
    "Barcode": barcode,
  };

  @override
  String toString(){
    return "$nonPickupReasonId, $odnId, $productImageList, $qualityCheck, $qualityCheckFailedReasonId, $trackingNoStatus, $barcode, ";
  }
}

class ProductImageList {
  ProductImageList({
    required this.image,
  });

  final String? image;

  factory ProductImageList.fromJson(Map<String, dynamic> json){
    return ProductImageList(
      image: json["Image"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Image": image,
  };

  @override
  String toString(){
    return "$image, ";
  }
}
