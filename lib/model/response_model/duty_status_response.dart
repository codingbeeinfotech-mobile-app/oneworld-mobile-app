class DutyStatusResponse {
  DutyStatusResponse({
    required this.result,
    required this.data,
  });

  final Result? result;
  final Data? data;

  factory DutyStatusResponse.fromJson(Map<String, dynamic> json){
    return DutyStatusResponse(
      result: json["Result"] == null ? null : Result.fromJson(json["Result"]),
      data: json["Data"] == null ? null : Data.fromJson(json["Data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "Result": result?.toJson(),
    "Data": data?.toJson(),
  };

  @override
  String toString(){
    return "$result, $data, ";
  }
}

class Data {
  Data({
    required this.latitude,
    required this.longitude,
  });

  final double? latitude;
  final double? longitude;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      latitude: json["Latitude"],
      longitude: json["Longitude"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Latitude": latitude,
    "Longitude": longitude,
  };

  @override
  String toString(){
    return "$latitude, $longitude, ";
  }
}

class Result {
  Result({
    required this.flag,
    required this.flagMessage,
  });

  final bool? flag;
  final String? flagMessage;

  factory Result.fromJson(Map<String, dynamic> json){
    return Result(
      flag: json["Flag"],
      flagMessage: json["FlagMessage"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Flag": flag,
    "FlagMessage": flagMessage,
  };

  @override
  String toString(){
    return "$flag, $flagMessage, ";
  }
}
