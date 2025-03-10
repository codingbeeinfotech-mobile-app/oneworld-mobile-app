class GetVendorDataRequest {
  GetVendorDataRequest({
    required this.clientId,
    required this.clientName,
    required this.companyId,
    required this.vendorId,
    required this.date,
  });

  final int clientId;
  final String clientName;
  final int companyId;
  final int vendorId;
  final String date;

  factory GetVendorDataRequest.fromJson(Map<String, dynamic> json){
    return GetVendorDataRequest(
      clientId: json["ClientId"] ?? 0,
      clientName: json["ClientName"] ?? "",
      companyId: json["CompanyId"] ?? 0,
      vendorId: json["VendorId"] ?? 0,
      date: json["Date"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "ClientName": clientName,
    "CompanyId": companyId,
    "VendorId": vendorId,
    "Date": date,
  };

  @override
  String toString(){
    return "$clientId, $clientName, $companyId, $vendorId, $date, ";
  }
}
