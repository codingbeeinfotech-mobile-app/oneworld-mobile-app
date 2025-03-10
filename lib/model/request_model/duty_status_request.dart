class DutyStatusRequest {
  DutyStatusRequest({
    required this.driverId,
    required this.companyId,
    required this.warehouseId,
    required this.entryDate,
    required this.entryTime,
    required this.latitude,
    required this.longitude,
    required this.dutyStatus,
    required this.isActivity,
  });

  final int? driverId;
  final int? companyId;
  final int? warehouseId;
  final String? entryDate;
  final String? entryTime;
  final double? latitude;
  final double? longitude;
  final int? dutyStatus;
  final String? isActivity;

  factory DutyStatusRequest.fromJson(Map<String, dynamic> json){
    return DutyStatusRequest(
      driverId: json["DriverId"],
      companyId: json["CompanyId"],
      warehouseId: json["WarehouseId"],
      entryDate: json["EntryDate"],
      entryTime: json["EntryTime"],
      latitude: json["Latitude"],
      longitude: json["Longitude"],
      dutyStatus: json["DutyStatus"],
      isActivity: json["IsActivity"],
    );
  }

  Map<String, dynamic> toJson() => {
    "DriverId": driverId,
    "CompanyId": companyId,
    "WarehouseId": warehouseId,
    "EntryDate": entryDate,
    "EntryTime": entryTime,
    "Latitude": latitude,
    "Longitude": longitude,
    "DutyStatus": dutyStatus,
    "IsActivity": isActivity,
  };

  @override
  String toString(){
    return "$driverId,$isActivity,$companyId, $warehouseId, $entryDate, $entryTime, $latitude, $longitude, $dutyStatus, ";
  }
}
