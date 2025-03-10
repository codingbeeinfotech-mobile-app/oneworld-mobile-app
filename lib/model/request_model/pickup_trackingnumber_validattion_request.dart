class ValidatePickupTrackingNoRequest {
  ValidatePickupTrackingNoRequest({
    required this.userId,
    required this.clientId,
    required this.clientName,
    required this.companyId,
    required this.trackingNumber,
    required this.warehouseId,
  });

  final int? userId;
  final int? clientId;
  final String? clientName;
  final int? companyId;
  final String? trackingNumber;
  final int? warehouseId;

  factory ValidatePickupTrackingNoRequest.fromJson(Map<String, dynamic> json){
    return ValidatePickupTrackingNoRequest(
      userId: json["UserId"],
      clientId: json["ClientId"],
      clientName: json["ClientName"],
      companyId: json["CompanyId"],
      trackingNumber: json["TrackingNumber"],
      warehouseId: json["WarehouseId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "ClientId": clientId,
    "ClientName": clientName,
    "CompanyId": companyId,
    "TrackingNumber": trackingNumber,
    "WarehouseId": warehouseId,
  };

  @override
  String toString(){
    return "$userId, $clientId, $clientName, $companyId, $trackingNumber, $warehouseId, ";
  }
}
