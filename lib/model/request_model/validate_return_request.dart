class ValidatePickupRequest {
  ValidatePickupRequest({
    required this.clientId,
    required this.clientName,
    required this.companyId,
    required this.trackingNumber,
    required this.userId,
    required this.warehouseId,
  });

  final int? clientId;
  final String? clientName;
  final int? companyId;
  final String? trackingNumber;
  final int? userId;
  final int? warehouseId;

  factory ValidatePickupRequest.fromJson(Map<String, dynamic> json){
    return ValidatePickupRequest(
      clientId: json["ClientId"],
      clientName: json["ClientName"],
      companyId: json["CompanyId"],
      trackingNumber: json["TrackingNumber"],
      userId: json["UserId"],
      warehouseId: json["WarehouseId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "ClientName": clientName,
    "CompanyId": companyId,
    "TrackingNumber": trackingNumber,
    "UserId": userId,
    "WarehouseId": warehouseId,
  };

  @override
  String toString(){
    return "$clientId, $clientName, $companyId, $trackingNumber, $userId, $warehouseId, ";
  }
}
