class AppVersionResponse {
  AppVersionResponse({
    required this.apikey,
    required this.name,
    required this.employeeId,
    required this.contactNo,
    required this.currentVersion,
    required this.hiringType,
    required this.flutterVersion,
  });

  final dynamic apikey;
  final dynamic name;
  final dynamic employeeId;
  final String? contactNo;
  final String? currentVersion;
  final dynamic hiringType;
  final String? flutterVersion;

  factory AppVersionResponse.fromJson(Map<String, dynamic> json){
    return AppVersionResponse(
      apikey: json["APIKEY"],
      name: json["NAME"],
      employeeId: json["EmployeeId"],
      contactNo: json["ContactNo"],
      currentVersion: json["CurrentVersion"],
      hiringType: json["HiringType"],
      flutterVersion: json["FlutterVersion"],
    );
  }

  Map<String, dynamic> toJson() => {
    "APIKEY": apikey,
    "NAME": name,
    "EmployeeId": employeeId,
    "ContactNo": contactNo,
    "CurrentVersion": currentVersion,
    "HiringType": hiringType,
    "FlutterVersion": flutterVersion,
  };

  @override
  String toString(){
    return "$apikey, $name, $employeeId, $contactNo, $currentVersion, $hiringType, $flutterVersion, ";
  }
}
