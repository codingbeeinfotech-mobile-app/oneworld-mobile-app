class DashboardResponse {
  late Result result;
  late Data data;

  DashboardResponse({required this.result, required this.data});

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    result =
    (json['Result'] != null ? Result.fromJson(json['Result']) : null)!;
    data = (json['Data'] != null ? Data.fromJson(json['Data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Result'] = result.toJson();
    data['Data'] = this.data.toJson();
      return data;
  }
}

class Result {
  late bool flag;
  late String flagMessage;

  Result({required this.flag,required this.flagMessage});

  Result.fromJson(Map<String, dynamic> json) {
    flag = json['Flag'];
    flagMessage = json['FlagMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Flag'] = flag;
    data['FlagMessage'] = flagMessage;
    return data;
  }
}

class Data {
  late int orderAllocated;
  late int todayOrderAllocated;
  late int orderPicked;
  late int todayOrderPicked;
  late int orderDelivered;
  late int todayOrderDelivered;
  late int orderUnDelivered;
  late int todayOrderUnDelivered;
  late int prepaidShipments;
  late int todayPrepaidShipments;
  late int codShipments;
  late int todayCodShipments;
  late double codAmountCollected;
  late double todayCodAmountCollected;
  late int bulkPickUpCount;
  late int todayBulkPickUpCount;
  late String bulkPickUpAddress;

  Data(
      {required this.orderAllocated,
        required this.todayOrderAllocated,
        required this.orderPicked,
        required this.todayOrderPicked,
        required this.orderDelivered,
        required this.todayOrderDelivered,
        required this.orderUnDelivered,
        required this.todayOrderUnDelivered,
        required this.prepaidShipments,
        required this.todayPrepaidShipments,
        required this.codShipments,
        required this.todayCodShipments,
        required this.codAmountCollected,
        required this.todayCodAmountCollected,
        required this.bulkPickUpCount,
        required this.todayBulkPickUpCount,
        required this.bulkPickUpAddress});

  Data.fromJson(Map<String, dynamic> json) {
    orderAllocated = json['OrderAllocated'];
    todayOrderAllocated = json['TodayOrderAllocated'];
    orderPicked = json['OrderPicked'];
    todayOrderPicked = json['TodayOrderPicked'];
    orderDelivered = json['OrderDelivered'];
    todayOrderDelivered = json['TodayOrderDelivered'];
    orderUnDelivered = json['OrderUnDelivered'];
    todayOrderUnDelivered = json['TodayOrderUnDelivered'];
    prepaidShipments = json['PrepaidShipments'];
    todayPrepaidShipments = json['TodayPrepaidShipments'];
    codShipments = json['CodShipments'];
    todayCodShipments = json['TodayCodShipments'];
    codAmountCollected = json['CodAmountCollected'];
    todayCodAmountCollected = json['TodayCodAmountCollected'];
    bulkPickUpCount = json['BulkPickUpCount'];
    todayBulkPickUpCount = json['TodayBulkPickUpCount'];
    bulkPickUpAddress = json['BulkPickUpAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrderAllocated'] = orderAllocated;
    data['TodayOrderAllocated'] = todayOrderAllocated;
    data['OrderPicked'] = orderPicked;
    data['TodayOrderPicked'] = todayOrderPicked;
    data['OrderDelivered'] = orderDelivered;
    data['TodayOrderDelivered'] = todayOrderDelivered;
    data['OrderUnDelivered'] = orderUnDelivered;
    data['TodayOrderUnDelivered'] = todayOrderUnDelivered;
    data['PrepaidShipments'] = prepaidShipments;
    data['TodayPrepaidShipments'] = todayPrepaidShipments;
    data['CodShipments'] = codShipments;
    data['TodayCodShipments'] = todayCodShipments;
    data['CodAmountCollected'] = codAmountCollected;
    data['TodayCodAmountCollected'] = todayCodAmountCollected;
    data['BulkPickUpCount'] = bulkPickUpCount;
    data['TodayBulkPickUpCount'] = todayBulkPickUpCount;
    data['BulkPickUpAddress'] = bulkPickUpAddress;
    return data;
  }
}
