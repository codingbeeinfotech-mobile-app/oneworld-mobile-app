class GetVendorListResponse {
  GetVendorListResponse({
    required this.flag,
    required this.flagMsg,
    required this.data,
  });

  final int flag;
  final String flagMsg;
  final List<VendorList> data;

  factory GetVendorListResponse.fromJson(Map<String, dynamic> json){
    return GetVendorListResponse(
      flag: json["Flag"] ?? 0,
      flagMsg: json["Flag_Msg"] ?? "",
      data: json["Data"] == null ? [] : List<VendorList>.from(json["Data"]!.map((x) => VendorList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "Flag": flag,
    "Flag_Msg": flagMsg,
    "Data": data.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$flag, $flagMsg, $data, ";
  }
}

class VendorList {
  VendorList({
    required this.vendorId,
    required this.vendorCode,
    required this.vendorName,
  });

  final int vendorId;
  final String vendorCode;
  final String vendorName;

  factory VendorList.fromJson(Map<String, dynamic> json){
    return VendorList(
      vendorId: json["VendorId"] ?? 0,
      vendorCode: json["VendorCode"] ?? "",
      vendorName: json["VendorName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "VendorId": vendorId,
    "VendorCode": vendorCode,
    "VendorName": vendorName,
  };

  @override
  String toString(){
    return "$vendorId, $vendorCode, $vendorName, ";
  }
}
