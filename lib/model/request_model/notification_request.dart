class NotificationRequest {
  NotificationRequest({
    required this.driverId,
    required this.companyId,
    required this.warehouseId,
  });

  final int? driverId;
  final int? companyId;
  final int? warehouseId;

  factory NotificationRequest.fromJson(Map<String, dynamic> json){
    return NotificationRequest(
      driverId: json["DriverId"],
      companyId: json["CompanyId"],
      warehouseId: json["WarehouseId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "DriverId": driverId,
    "CompanyId": companyId,
    "WarehouseId": warehouseId,
  };

  @override
  String toString(){
    return "$driverId, $companyId, $warehouseId,  ";
  }
}
