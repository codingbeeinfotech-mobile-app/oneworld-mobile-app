class GetVendorListRequest {
  GetVendorListRequest({
    required this.clientId,
    required this.clientName,
    required this.companyId,
  });

  final int clientId;
  final String clientName;
  final int companyId;

  factory GetVendorListRequest.fromJson(Map<String, dynamic> json){
    return GetVendorListRequest(
      clientId: json["ClientId"] ?? 0,
      clientName: json["ClientName"] ?? "",
      companyId: json["CompanyId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "ClientName": clientName,
    "CompanyId": companyId,
  };

  @override
  String toString(){
    return "$clientId, $clientName, $companyId, ";
  }
}
