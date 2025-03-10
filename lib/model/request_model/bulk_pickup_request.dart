class BulkPickupRequest {
  BulkPickupRequest({
    this.clientId,
    this.clientName,
    required this.companyId,
    required this.trackingNumber,
  });

  final int? clientId;
  final String? clientName;
  final int? companyId;
  final String? trackingNumber;

  factory BulkPickupRequest.fromJson(Map<String, dynamic> json) {
    return BulkPickupRequest(
      clientId: json["ClientId"],
      clientName: json["ClientName"],
      companyId: json["CompanyId"],
      trackingNumber: json["TrackingNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
        "ClientId": clientId,
        "ClientName": clientName,
        "CompanyId": companyId,
        "TrackingNumber": trackingNumber,
      };

  @override
  String toString() {
    return "$clientId, $clientName,$trackingNumber, $companyId, ";
  }
}
