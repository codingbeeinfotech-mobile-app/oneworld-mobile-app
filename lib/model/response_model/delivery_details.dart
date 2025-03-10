class TrackingDetailsResponseClass {
  TrackingDetailsResponseClass({
    required this.odnId,
    required this.trackingNumber,
    required this.transporterId,
    required this.transporterLocation,
    required this.transporterLocationId,
    required this.orderType,
    required this.codAmount,
    required this.masterNumber,
  });

  @override
  String toString() {
    return 'TrackingDetailsResponseClass{odnId: $odnId, trackingNumber: $trackingNumber, transporterId: $transporterId, transporterLocationId: $transporterLocationId, orderType: $orderType, codAmount: $codAmount, masterNumber: $masterNumber}';
  }

  final int? odnId;
  final String? trackingNumber;
  final String? transporterId;
  final String? transporterLocation;
  final int? transporterLocationId;
  final String? orderType;
  final double? codAmount;
  final dynamic masterNumber;

  factory TrackingDetailsResponseClass.fromJson(Map<String, dynamic> json){
    return TrackingDetailsResponseClass(
      odnId: json["OdnId"],
      trackingNumber: json["TrackingNumber"],
      transporterId: json["TransporterId"],
      transporterLocation: json["TransporterLocation"],
      transporterLocationId: json["TransporterLocationId"],
      orderType: json["OrderType"],
      codAmount: json["CodAmount"],
      masterNumber: json["MasterNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
    "OdnId": odnId,
    "TrackingNumber": trackingNumber,
    "TransporterId": transporterId,
    "TransporterLocation": transporterLocation,
    "TransporterLocationId": transporterLocationId,
    "OrderType": orderType,
    "CodAmount": codAmount,
    "MasterNumber": masterNumber,
  };

}
