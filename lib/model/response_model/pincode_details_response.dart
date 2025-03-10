

class PinCodeResponse {
  PinCodeResponse({
    required this.pincode,
    required this.state,
    required this.stateId,
    required this.city,
    required this.locationCode,
    required this.locationId,
    required this.cityId,
  });

  final String? pincode;
  final String? state;
  final String? locationCode;
  final int? stateId;
  final int? locationId;
  final String? city;
  final int? cityId;

  factory PinCodeResponse.fromJson(Map<String, dynamic> json){
    return PinCodeResponse(
      pincode: json["Pincode"],
      locationCode: json["LocationCode"],
      locationId: json["LocationId"],
      state: json["StateName"],
      stateId: json["StateId"],
      city: json["CityName"],
      cityId: json["CityId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Pincode": pincode,
    "LocationCode": locationCode,
    "LocationId": locationId,
    "StateName": state,
    "StateId": stateId,
    "CityName": city,
    "CityId": cityId,
  };

  @override
  String toString(){
    return "$pincode, $state, $stateId, $city, $cityId, ";
  }
}

class Result {
  Result({
    required this.flag,
    required this.flagMsg,
  });

  final int? flag;
  final String? flagMsg;

  factory Result.fromJson(Map<String, dynamic> json){
    return Result(
      flag: json["Flag"],
      flagMsg: json["Flag_Msg"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Flag": flag,
    "Flag_Msg": flagMsg,
  };

  @override
  String toString(){
    return "$flag, $flagMsg, ";
  }
}
