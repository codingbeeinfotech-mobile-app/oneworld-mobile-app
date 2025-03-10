class DriverStatusRequest {
  DriverStatusRequest({
    required this.clientId,
    required this.clientName,
    required this.companyId,
    required this.driverId,
    required this.warehouseId,
  });

  final int? clientId;
  final String? clientName;
  final int? companyId;
  final int? driverId;
  final int? warehouseId;

  factory DriverStatusRequest.fromJson(Map<String, dynamic> json){
    return DriverStatusRequest(
      clientId: json["ClientId"],
      clientName: json["ClientName"],
      companyId: json["CompanyId"],
      driverId: json["DriverId"],
      warehouseId: json["WarehouseId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "ClientName": clientName,
    "CompanyId": companyId,
    "DriverId": driverId,
    "WarehouseId": warehouseId,
  };

  @override
  String toString(){
    return "$clientId, $clientName, $companyId, $driverId, $warehouseId, ";
  }
}
