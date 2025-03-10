class GetVendorDataResponse {
  GetVendorDataResponse({
    required this.flag,
    required this.flagMsg,
    required this.data,
  });

  final int flag;
  final String flagMsg;
  final List<VendorData> data;

  factory GetVendorDataResponse.fromJson(Map<String, dynamic> json){
    return GetVendorDataResponse(
      flag: json["Flag"] ?? 0,
      flagMsg: json["Flag_Msg"] ?? "",
      data: json["Data"] == null ? [] : List<VendorData>.from(json["Data"]!.map((x) => VendorData.fromJson(x))),
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

class VendorData {
  VendorData({
    required this.odnId,
    required this.forwardAwbNumber,
    required this.pickupLocationAddress,
  });

  final String odnId;
  final String forwardAwbNumber;
  final String pickupLocationAddress;

  factory VendorData.fromJson(Map<String, dynamic> json){
    return VendorData(
      odnId: json["OdnId"] ?? "",
      forwardAwbNumber: json["ForwardAwbNumber"] ?? "",
      pickupLocationAddress: json["PickupLocationAddress"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "OdnId": odnId,
    "ForwardAwbNumber": forwardAwbNumber,
    "PickupLocationAddress": pickupLocationAddress,
  };

  @override
  String toString(){
    return "$odnId, $forwardAwbNumber, $pickupLocationAddress, ";
  }
}
