class NdrByLocationRequest {
  late int clientId;
  late String clientName;
  late int companyId;
  late int userId;
  late int warehouseId;

  NdrByLocationRequest(
      {required this.clientId,
        required this.clientName,
        required this.companyId,
        required this.userId,
        required this.warehouseId});

  NdrByLocationRequest.fromJson(Map<String, dynamic> json) {
    clientId = json['ClientId'] ?? "";
    clientName = json['ClientName']?? "";
    companyId = json['CompanyId']?? "";
    userId = json['UserId']?? "";
    warehouseId = json['WarehouseId']?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClientId'] = clientId;
    data['ClientName'] = clientName;
    data['CompanyId'] = companyId;
    data['UserId'] = userId;
    data['WarehouseId'] = warehouseId;
    return data;
  }
}
