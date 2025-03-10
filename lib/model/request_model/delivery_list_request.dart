class DeliveryListRequestModel {
  late int dRIVERID;
  late int clientId;
  late String clientName;
  late int companyId;
  late String locationId;
  late int userId;
  late int warehouseId;

  DeliveryListRequestModel(
      { required this.dRIVERID,
        required this.clientId,
        required this.clientName,
        required this.companyId,
        required this.locationId,
        required this.userId,
        required this.warehouseId});

  DeliveryListRequestModel.fromJson(Map<String, dynamic> json) {
    dRIVERID = json['DRIVER_ID']?? "";
    clientId = json['ClientId']?? "";
    clientName = json['ClientName']?? "";
    companyId = json['CompanyId']?? "";
    locationId = json['LocationId']?? "";
    userId = json['UserId']?? "";
    warehouseId = json['WarehouseId']?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DRIVER_ID'] = dRIVERID;
    data['ClientId'] = clientId;
    data['ClientName'] = clientName;
    data['CompanyId'] = companyId;
    data['LocationId'] = locationId;
    data['UserId'] = userId;
    data['WarehouseId'] = warehouseId;
    return data;
  }
}
