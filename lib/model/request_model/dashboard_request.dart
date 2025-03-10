class DashboardRequest {
  late int clientId;
  late String clientName;
  late int companyId;
  late int driverId;
  late String vendorId;
  late int warehouseId;

  DashboardRequest(
      {required this.clientId,
        required this.clientName,
        required this.companyId,
        required this.driverId,
        required this.vendorId,
        required this.warehouseId});

  DashboardRequest.fromJson(Map<String, dynamic> json) {
    clientId = json['ClientId'];
    clientName = json['ClientName'];
    companyId = json['CompanyId'];
    driverId = json['DriverId'];
    vendorId = json['VendorId'];
    warehouseId = json['WarehouseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClientId'] = clientId;
    data['ClientName'] = clientName;
    data['CompanyId'] = companyId;
    data['DriverId'] = driverId;
    data['VendorId'] = vendorId;
    data['WarehouseId'] = warehouseId;
    return data;
  }
}
