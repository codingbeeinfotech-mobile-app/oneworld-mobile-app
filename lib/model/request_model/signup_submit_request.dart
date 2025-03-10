
class SubmitSignupRequest {
  final int signupDriverId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String emailId;
  final String dateOfBirth;
  final String currentAddress;
  final String permanentAddress;
  final String gender;
  final int bloodGroupId;
  final String pinCode;
  final int stateId;
  final int cityId;
  final String mobileNo;
  final int vehicleTypeId;
  final String aadharCardNumber;
  final String panCardNumber;
  final String drivingLicenseNumber;
  final String twoWheelerDrivingLicenseNumber;
  final String threeWheelerDrivingLicenseNumber;
  final String fourWheelerDrivingLicenseNumber;
  final String drivingLicenseIssueDate;
  final String drivingLicenseExpiryDate;
  final String drivingLicenseFrontSide;
  final String drivingLicenseBackSide;
  final String voterIdFrontSide;
  final String voterIdBackSide;
  final String aadharCardFrontSide;
  final String aadharCardBackSide;
  final String panCardImage;
  final String selfie;
  final String voterId;
  final String alternativeMobileNo;
  final bool useCurrentAddressAsPermanentAddress;
  final String dlVehicleTypeIds;
  final String dlTypeId;
  final bool haveDrivingLicense;
  final String vehicleNo;
  final String rcPhoto;

  SubmitSignupRequest({
    required this.signupDriverId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.emailId,
    required this.dateOfBirth,
    required this.currentAddress,
    required this.permanentAddress,
    required this.gender,
    required this.bloodGroupId,
    required this.pinCode,
    required this.stateId,
    required this.cityId,
    required this.mobileNo,
    required this.vehicleTypeId,
    required this.aadharCardNumber,
    required this.panCardNumber,
    required this.drivingLicenseNumber,
    required this.twoWheelerDrivingLicenseNumber,
    required this.threeWheelerDrivingLicenseNumber,
    required this.fourWheelerDrivingLicenseNumber,
    required this.drivingLicenseIssueDate,
    required this.drivingLicenseExpiryDate,
    required this.drivingLicenseFrontSide,
    required this.drivingLicenseBackSide,
    required this.voterIdFrontSide,
    required this.voterIdBackSide,
    required this.aadharCardFrontSide,
    required this.aadharCardBackSide,
    required this.panCardImage,
    required this.selfie,
    required this.voterId,
    required this.alternativeMobileNo,
    required this.useCurrentAddressAsPermanentAddress,
    required this.dlVehicleTypeIds,
    required this.dlTypeId,
    required this.haveDrivingLicense,
    required this.vehicleNo,
    required this.rcPhoto,
  });

  factory SubmitSignupRequest.fromJson(Map<String, dynamic> json) => SubmitSignupRequest(
    signupDriverId: json["SignupDriverId"],
    firstName: json["FirstName"],
    middleName: json["MiddleName"],
    lastName: json["LastName"],
    emailId: json["EmailId"],
    dateOfBirth: json["DateOfBirth"] ,
    currentAddress: json["CurrentAddress"],
    permanentAddress: json["PermanentAddress"],
    gender: json["Gender"],
    bloodGroupId: json["BloodGroupId"],
    pinCode: json["PinCode"],
    stateId: json["StateId"],
    cityId: json["CityId"],
    mobileNo: json["MobileNo"],
    vehicleTypeId: json["VehicleTypeId"],
    aadharCardNumber: json["AadharCardNumber"],
    panCardNumber: json["PanCardNumber"],
    drivingLicenseNumber: json["DrivingLicenseNumber"],
    twoWheelerDrivingLicenseNumber: json["TwoWheelerDrivingLicenseNumber"],
    threeWheelerDrivingLicenseNumber: json["ThreeWheelerDrivingLicenseNumber"],
    fourWheelerDrivingLicenseNumber: json["FourWheelerDrivingLicenseNumber"],
    drivingLicenseIssueDate: json["DrivingLicenseIssueDate"] ,
    drivingLicenseExpiryDate: json["DrivingLicenseExpiryDate"] ,
    drivingLicenseFrontSide: json["DrivingLicenseFrontSide"],
    drivingLicenseBackSide: json["DrivingLicenseBackSide"],
    voterIdFrontSide: json["VoterIdFrontSide"],
    voterIdBackSide: json["VoterIdBackSide"],
    aadharCardFrontSide: json["AadharCardFrontSide"],
    aadharCardBackSide: json["AadharCardBackSide"],
    panCardImage: json["PanCardImage"],
    selfie: json["Selfie"],
    voterId: json["VoterId"],
    alternativeMobileNo: json["AlternativeMobileNo"],
    useCurrentAddressAsPermanentAddress: json["UseCurrentAddressAsPermanentAddress"],
    dlVehicleTypeIds: json["DlVehicleTypeIds"],
    dlTypeId: json["DlTypeId"],
    haveDrivingLicense: json["HaveDrivingLicense"],
    vehicleNo: json["VehicleNo"],
    rcPhoto: json["RcPhoto"],
  );

  Map<String, dynamic> toJson() => {
    "SignupDriverId": signupDriverId,
    "FirstName": firstName,
    "MiddleName": middleName,
    "LastName": lastName,
    "EmailId": emailId,
    "DateOfBirth": dateOfBirth,
    "CurrentAddress": currentAddress,
    "PermanentAddress": permanentAddress,
    "Gender": gender,
    "BloodGroupId": bloodGroupId,
    "PinCode": pinCode,
    "StateId": stateId,
    "CityId": cityId,
    "MobileNo": mobileNo,
    "VehicleTypeId": vehicleTypeId,
    "AadharCardNumber": aadharCardNumber,
    "PanCardNumber": panCardNumber,
    "DrivingLicenseNumber": drivingLicenseNumber,
    "TwoWheelerDrivingLicenseNumber": twoWheelerDrivingLicenseNumber,
    "ThreeWheelerDrivingLicenseNumber": threeWheelerDrivingLicenseNumber,
    "FourWheelerDrivingLicenseNumber": fourWheelerDrivingLicenseNumber,
    "DrivingLicenseIssueDate": drivingLicenseIssueDate,
    "DrivingLicenseExpiryDate": drivingLicenseExpiryDate,
    "DrivingLicenseFrontSide": drivingLicenseFrontSide,
    "DrivingLicenseBackSide": drivingLicenseBackSide,
    "VoterIdFrontSide": voterIdFrontSide,
    "VoterIdBackSide": voterIdBackSide,
    "AadharCardFrontSide": aadharCardFrontSide,
    "AadharCardBackSide": aadharCardBackSide,
    "PanCardImage": panCardImage,
    "Selfie": selfie,
    "VoterId": voterId,
    "AlternativeMobileNo": alternativeMobileNo,
    "UseCurrentAddressAsPermanentAddress": useCurrentAddressAsPermanentAddress,
    "DlVehicleTypeIds": dlVehicleTypeIds,
    "DlTypeId": dlTypeId,
    "HaveDrivingLicense": haveDrivingLicense,
    "VehicleNo": vehicleNo,
    "RcPhoto": rcPhoto,
  };
}
