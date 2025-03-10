class ReturnPickupRequest {
  ReturnPickupRequest({
    required this.clientId,
    required this.clientName,
    required this.companyId,
    required this.userId,
    required this.warehouseId,
  });

  final int? clientId;
  final String? clientName;
  final int? companyId;
  final int? userId;
  final int? warehouseId;

  factory ReturnPickupRequest.fromJson(Map<String, dynamic> json){
    return ReturnPickupRequest(
      clientId: json["ClientId"],
      clientName: json["ClientName"],
      companyId: json["CompanyId"],
      userId: json["UserId"],
      warehouseId: json["WarehouseId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "ClientName": clientName,
    "CompanyId": companyId,
    "UserId": userId,
    "WarehouseId": warehouseId,
  };

  @override
  String toString(){
    return "$clientId, $clientName, $companyId, $userId, $warehouseId, ";
  }
}
