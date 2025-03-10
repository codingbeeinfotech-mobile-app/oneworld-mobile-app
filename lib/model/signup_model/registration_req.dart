class RegistrationReq {
  late String cLIENTID;
  late String cLIENTNAME;
  late String contactNo;
  late String emailAddress;
  late String employeeId;
  late String name;
  late String password;
  late String sREDesignation;
  late String sREManagerType;
  late String timeStamp;

  RegistrationReq(
      {required this.cLIENTID,
       required this.cLIENTNAME,
       required this.contactNo,
       required this.emailAddress,
       required this.employeeId,
       required this.name,
       required this.password,
       required this.sREDesignation,
       required this.sREManagerType,
       required this.timeStamp});

  RegistrationReq.fromJson(Map<String, dynamic> json) {
    cLIENTID = json['CLIENT_ID']??"";
    cLIENTNAME = json['CLIENT_NAME']??"";
    contactNo = json['ContactNo']??"";
    emailAddress = json['EmailAddress']??"";
    employeeId = json['EmployeeId']??"";
    name = json['Name']??"";
    password = json['Password']??"";
    sREDesignation = json['SRE_Designation']??"";
    sREManagerType = json['SRE_Manager_Type']??"";
    timeStamp = json['TimeStamp']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CLIENT_ID'] = cLIENTID;
    data['CLIENT_NAME'] = cLIENTNAME;
    data['ContactNo'] = contactNo;
    data['EmailAddress'] = emailAddress;
    data['EmployeeId'] = employeeId;
    data['Name'] = name;
    data['Password'] = password;
    data['SRE_Designation'] = sREDesignation;
    data['SRE_Manager_Type'] = sREManagerType;
    data['TimeStamp'] = timeStamp;
    return data;
  }
}