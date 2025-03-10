class VersionCheckResponse {
  VersionCheckResponse({
    required this.apikey,
    required this.name,
    required this.employeeId,
    required this.contactNo,
    required this.currentVersion,
    required this.hiringType,
  });

  final dynamic apikey;
  final dynamic name;
  final dynamic employeeId;
  final String? contactNo;
  final String? currentVersion;
  final dynamic hiringType;

  factory VersionCheckResponse.fromJson(Map<String, dynamic> json){
    return VersionCheckResponse(
      apikey: json["APIKEY"] ?? "",
      name: json["NAME"] ?? "",
      employeeId: json["EmployeeId"] ?? "",
      contactNo: json["ContactNo"] ?? "",
      currentVersion: json["CurrentVersion"] ?? "",
      hiringType: json["HiringType"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "APIKEY": apikey,
    "NAME": name,
    "EmployeeId": employeeId,
    "ContactNo": contactNo,
    "CurrentVersion": currentVersion,
    "HiringType": hiringType,
  };

  @override
  String toString(){
    return "$apikey, $name, $employeeId, $contactNo, $currentVersion, $hiringType, ";
  }
}
