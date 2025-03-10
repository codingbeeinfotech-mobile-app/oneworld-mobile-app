class ValidatePrintTrackingNumberResponse {
  ValidatePrintTrackingNumberResponse({
    required this.flag,
    required this.message,
    required this.obj,
  });

  final int? flag;
  final String? message;
  final Obj? obj;

  factory ValidatePrintTrackingNumberResponse.fromJson(Map<String, dynamic> json){
    return ValidatePrintTrackingNumberResponse(
      flag: json["Flag"] ?? "",
      message: json["Message"] ?? "",
      obj: json["obj"] == null ? null : Obj.fromJson(json["obj"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "Flag": flag,
    "Message": message,
    "obj": obj?.toJson(),
  };

  @override
  String toString(){
    return "$flag, $message, $obj, ";
  }
}

class Obj {
  Obj({
    required this.masterNumber,
    required this.childNumber,
    required this.fromAddress,
    required this.toAddress,
    required this.fromCity,
    required this.toCity,
    required this.consignorAddress,
    required this.consigneeAddress,
    required this.pickupLocationContactNumber,
    required this.dropLocationContactNumber,
    required this.consignorName,
    required this.consigneeName,
    required this.itemDescription,
    required this.amount,
    required this.orderTypeId,
  });

  final String? masterNumber;
  final List<ChildNumber> childNumber;
  final String? fromAddress;
  final String? toAddress;
  final String? fromCity;
  final String? toCity;
  final String? consignorAddress;
  final String? consigneeAddress;
  final String? pickupLocationContactNumber;
  final String? dropLocationContactNumber;
  final String? consignorName;
  final String? consigneeName;
  final String? itemDescription;
  final int? amount;
  final int? orderTypeId;

  factory Obj.fromJson(Map<String, dynamic> json){
    return Obj(
      masterNumber: json["MasterNumber"] ?? "",
      childNumber: json["ChildNumber"] == null ? [] : List<ChildNumber>.from(json["ChildNumber"]!.map((x) => ChildNumber.fromJson(x))),
      fromAddress: json["FromAddress"] ?? "",
      toAddress: json["ToAddress"] ?? "",
      fromCity: json["FromCity"] ?? "",
      toCity: json["ToCity"] ?? "",
      consignorAddress: json["consignorAddress"] ?? "",
      consigneeAddress: json["ConsigneeAddress"] ?? "",
      pickupLocationContactNumber: json["PickupLocationContactNumber"] ?? "",
      dropLocationContactNumber: json["DropLocationContactNumber"] ?? "",
      consignorName: json["ConsignorName"] ?? "",
      consigneeName: json["ConsigneeName"] ?? "",
      itemDescription: json["ItemDescription"] ?? "",
      amount: json["Amount"] ?? "",
      orderTypeId: json["OrderTypeId"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "MasterNumber": masterNumber,
    "ChildNumber": childNumber.map((x) => x?.toJson()).toList(),
    "FromAddress": fromAddress,
    "ToAddress": toAddress,
    "FromCity": fromCity,
    "ToCity": toCity,
    "consignorAddress": consignorAddress,
    "ConsigneeAddress": consigneeAddress,
    "PickupLocationContactNumber": pickupLocationContactNumber,
    "DropLocationContactNumber": dropLocationContactNumber,
    "ConsignorName": consignorName,
    "ConsigneeName": consigneeName,
    "ItemDescription": itemDescription,
    "Amount": amount,
    "OrderTypeId": orderTypeId,
  };

  @override
  String toString(){
    return "$masterNumber, $childNumber, $fromAddress, $toAddress, $fromCity, $toCity, $consignorAddress, $consigneeAddress, $pickupLocationContactNumber, $dropLocationContactNumber, $consignorName, $consigneeName, $itemDescription, $amount, $orderTypeId, ";
  }
}

class ChildNumber {
  ChildNumber({
    required this.id,
    required this.awbNo,
  });

  final int? id;
  final String? awbNo;

  factory ChildNumber.fromJson(Map<String, dynamic> json){
    return ChildNumber(
      id: json["Id"] ?? "",
      awbNo: json["AwbNo"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Id": id,
    "AwbNo": awbNo,
  };

  @override
  String toString(){
    return "$id, $awbNo, ";
  }
}
