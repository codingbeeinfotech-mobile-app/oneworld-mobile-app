class DriverStatusResponse {
  DriverStatusResponse({
    required this.result,
    required this.data,
  });

  final Result? result;
  final List<Datum> data;

  factory DriverStatusResponse.fromJson(Map<String, dynamic> json) {
    return DriverStatusResponse(
      result: json["Result"] == null ? null : Result.fromJson(json["Result"]),
      data: json["Data"] == null
          ? []
          : List<Datum>.from(json["Data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "Result": result?.toJson(),
        "Data": data.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$result, $data, ";
  }
}

class Datum {
  Datum({
    required this.duty,
    required this.driverId,
    required this.driverName,
    required this.totalTime,
    required this.entryDate,
    required this.entryTime,
    required this.latitude,
    required this.longitude,
  });

  final String? duty;
  final String? driverId;
  final String? driverName;
  final String? totalTime;
  final String? entryDate;
  final String? entryTime;
  final double? latitude;
  final double? longitude;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      duty: json["Duty"] ?? "",
      driverId: json["DriverId"] ?? "",
      driverName: json["DriverName"] ?? "",
      totalTime: json["TotalTime"] ?? "",
      entryDate: json["EntryDate"] ?? "",
      entryTime: json["EntryTime"] ?? "",
      latitude: json["Latitude"] ?? "",
      longitude: json["Longitude"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "Duty": duty,
        "DriverId": driverId,
        "DriverName": driverName,
        "TotalTime": totalTime,
        "EntryDate": entryDate,
        "EntryTime": entryTime,
        "Latitude": latitude,
        "Longitude": longitude,
      };

  @override
  String toString() {
    return "$duty, $driverId, $driverName, $totalTime, $entryDate, $entryTime, $latitude, $longitude, ";
  }
}

class Result {
  Result({
    required this.flag,
    required this.flagMessage,
    required this.currentStatus,
  });

  final bool? flag;
  final String? flagMessage;
  final String? currentStatus;

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      flag: json["Flag"],
      flagMessage: json["FlagMessage"],
      currentStatus: json["CurrentStatus"],
    );
  }

  Map<String, dynamic> toJson() => {
        "Flag": flag,
        "FlagMessage": flagMessage,
        "CurrentStatus": currentStatus,
      };

  @override
  String toString() {
    return "$flag, $flagMessage, $currentStatus, ";
  }
}
