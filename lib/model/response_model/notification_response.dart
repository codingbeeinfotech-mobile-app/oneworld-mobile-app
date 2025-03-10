class NotificationModel {
  List<NotificationItem> notifications;

  NotificationModel({required this.notifications});

  factory NotificationModel.fromJson(List<dynamic> jsonList) {
    return NotificationModel(
      notifications: jsonList.map((json) => NotificationItem.fromJson(json)).toList(),
    );
  }
}

class NotificationItem {
  int driverId;
  int companyId;
  int warehouseId;
  int odnId;
  String trackingNumber;
  String title;
  String body;
  dynamic fcmToken;
  dynamic responseResult;

  NotificationItem({
    required this.driverId,
    required this.companyId,
    required this.warehouseId,
    required this.odnId,
    required this.trackingNumber,
    required this.title,
    required this.body,
    required this.fcmToken,
    required this.responseResult,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      driverId: json["DriverId"],
      companyId: json["CompanyId"],
      warehouseId: json["WarehouseId"],
      odnId: json["OdnId"],
      trackingNumber: json["TrackingNumber"],
      title: json["Title"],
      body: json["Body"],
      fcmToken: json["FcmToken"],
      responseResult: json["ResponseResult"],
    );
  }
}