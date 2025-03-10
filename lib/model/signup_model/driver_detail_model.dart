class SignUpDriverDetailsByMobileNoModel {
  dynamic aadharNumber;
  dynamic panNumber;
  int? statusId;
  int? driverLocationId;
  int? warehouseId;
  int? branchId;
  String? driverLocationCode;
  dynamic driverCode;
  DateTime? fromDate;
  DateTime? toDate;
  bool? isApproved;
  String? status;
  dynamic remarks;
  int? signupDriverId;
  dynamic driverName;
  String? firstName;
  String? middleName;
  String? lastName;
  DateTime? entryDate;
  DateTime? dateOfBirth;
  String? aadharCardNumber;
  String? panCardNumber;
  String? mobileNo;
  String? emailId;
  String? currentAddress;
  String? permanentAddress;
  String? gender;
  String? selfie;
  int? stateId;
  String? stateName;
  int? cityId;
  String? cityName;
  String? pincode;
  int? bankId;
  String? branchName;
  String? accountHolderName;
  String? accountNumber;
  String? ifscCode;
  String? passbookCancelCheque;
  String? nomineeName;
  String? nomineeContactNo;
  String? nomineeRelation;
  dynamic business;
  int? businessId;
  int? businessSubId;
  dynamic department;
  int? departmentId;
  dynamic branchState;
  int? branchStateId;
  dynamic businessUnit;
  int? businessUnitId;
  int? vehicleTypeId;
  dynamic vehicleType;
  bool? haveDrivingLicense;
  dynamic dlVehicleTypeIds;
  dynamic dlTypeId;
  dynamic vehicleNo;
  dynamic rcPhoto;
  String? drivingLicenseNumber;
  DateTime? drivingLicenseIssueDate;
  DateTime? drivingLicenseExpiryDate;
  String? drivingLicenseFrontSide;
  String? drivingLicenseBackSide;
  String? aadharCardFrontSide;
  String? aadharCardBackSide;
  dynamic imageFile;
  String? tempId;
  int? bgvStatusId;
  dynamic bgvStatus;
  int? agreementStatusId;
  dynamic agreementStatus;
  dynamic triggerAgreement;
  String? twoWheelerDrivingLicenseNumber;
  String? threeWheelerDrivingLicenseNumber;
  String? fourWheelerDrivingLicenseNumber;
  String? panCardImage;
  String? voterIdFrontSide;
  String? voterIdBackSide;
  int? updateBy;
  int? bloodGroupId;
  bool? isOnlyRemarkUpdate;
  int? designationId;
  int? daCategoryId;
  int? paymentTypeId;
  int? payFrequencyId;
  int? routeId;
  double? fixAmount;
  double? variableAmount;
  double? fuelAmount;
  double? fixVariable;
  double? fixRateAmount;
  dynamic caller;
  dynamic voterId;
  dynamic alternativeMobileNo;
  bool? useCurrentAddressAsPermanentAddress;


  SignUpDriverDetailsByMobileNoModel({
    this.aadharNumber,
    this.panNumber,
    this.statusId,
    this.driverLocationId,
    this.warehouseId,
    this.branchId,
    this.driverLocationCode,
    this.driverCode,
    this.fromDate,
    this.toDate,
    this.isApproved,
    this.status,
    this.remarks,
    this.signupDriverId,
    this.driverName,
    this.firstName,
    this.middleName,
    this.lastName,
    this.entryDate,
    this.dateOfBirth,
    this.aadharCardNumber,
    this.panCardNumber,
    this.mobileNo,
    this.emailId,
    this.currentAddress,
    this.permanentAddress,
    this.gender,
    this.selfie,
    this.stateId,
    this.stateName,
    this.cityId,
    this.cityName,
    this.pincode,
    this.bankId,
    this.branchName,
    this.accountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.passbookCancelCheque,
    this.nomineeName,
    this.nomineeContactNo,
    this.nomineeRelation,
    this.business,
    this.businessId,
    this.businessSubId,
    this.department,
    this.departmentId,
    this.branchState,
    this.branchStateId,
    this.businessUnit,
    this.businessUnitId,
    this.vehicleTypeId,
    this.vehicleType,
    this.haveDrivingLicense,
    this.dlVehicleTypeIds,
    this.dlTypeId,
    this.vehicleNo,
    this.rcPhoto,
    this.drivingLicenseNumber,
    this.drivingLicenseIssueDate,
    this.drivingLicenseExpiryDate,
    this.drivingLicenseFrontSide,
    this.drivingLicenseBackSide,
    this.aadharCardFrontSide,
    this.aadharCardBackSide,
    this.imageFile,
    this.tempId,
    this.bgvStatusId,
    this.bgvStatus,
    this.agreementStatusId,
    this.agreementStatus,
    this.triggerAgreement,
    this.twoWheelerDrivingLicenseNumber,
    this.threeWheelerDrivingLicenseNumber,
    this.fourWheelerDrivingLicenseNumber,
    this.panCardImage,
    this.voterIdFrontSide,
    this.voterIdBackSide,
    this.updateBy,
    this.bloodGroupId,
    this.isOnlyRemarkUpdate,
    this.designationId,
    this.daCategoryId,
    this.paymentTypeId,
    this.payFrequencyId,
    this.routeId,
    this.fixAmount,
    this.variableAmount,
    this.fuelAmount,
    this.fixVariable,
    this.fixRateAmount,
    this.caller,
    this.voterId,
    this. alternativeMobileNo,
    this.useCurrentAddressAsPermanentAddress,

  });

  factory SignUpDriverDetailsByMobileNoModel.fromJson(
          Map<String, dynamic> json) =>
      SignUpDriverDetailsByMobileNoModel(
        aadharNumber: json["AadharNumber"],
        panNumber: json["PanNumber"],
        statusId: json["StatusId"],
        driverLocationId: json["DriverLocationId"],
        warehouseId: json["WarehouseId"],
        branchId: json["BranchId"],
        driverLocationCode: json["DriverLocationCode"],
        driverCode: json["DriverCode"],
        fromDate:
            json["FromDate"] == null ? null : DateTime.parse(json["FromDate"]),
        toDate: json["ToDate"] == null ? null : DateTime.parse(json["ToDate"]),
        isApproved: json["IsApproved"],
        status: json["Status"],
        remarks: json["Remarks"],
        signupDriverId: json["SignupDriverId"],
        driverName: json["DriverName"],
        firstName: json["FirstName"],
        middleName: json["MiddleName"],
        lastName: json["LastName"],
        entryDate: json["EntryDate"] == null
            ? null
            : DateTime.parse(json["EntryDate"]),
        dateOfBirth: json["DateOfBirth"] == null
            ? null
            : DateTime.parse(json["DateOfBirth"]),
        aadharCardNumber: json["AadharCardNumber"],
        panCardNumber: json["PanCardNumber"],
        mobileNo: json["MobileNo"],
        emailId: json["EmailId"],
        currentAddress: json["CurrentAddress"],
        permanentAddress: json["PermanentAddress"],
        gender: json["Gender"],
        selfie: json["Selfie"],
        stateId: json["StateId"],
        stateName: json["StateName"],
        cityId: json["CityId"],
        cityName: json["CityName"],
        pincode: json["Pincode"],
        bankId: json["BankId"],
        branchName: json["BranchName"],
        accountHolderName: json["AccountHolderName"],
        accountNumber: json["AccountNumber"],
        ifscCode: json["IFSCCode"],
        passbookCancelCheque: json["PassbookCancelCheque"],
        nomineeName: json["NomineeName"],
        nomineeContactNo: json["NomineeContactNo"],
        nomineeRelation: json["NomineeRelation"],
        business: json["Business"],
        businessId: json["BusinessId"],
        businessSubId: json["BusinessSubId"],
        department: json["Department"],
        departmentId: json["DepartmentId"],
        branchState: json["BranchState"],
        branchStateId: json["BranchStateId"],
        businessUnit: json["BusinessUnit"],
        businessUnitId: json["BusinessUnitId"],
        vehicleTypeId: json["VehicleTypeId"],
        vehicleType: json["VehicleType"],
        haveDrivingLicense: json["HaveDrivingLicense"],
        dlVehicleTypeIds: json["DlVehicleTypeIds"],
        dlTypeId: json["DlTypeId"],
        vehicleNo: json["VehicleNo"],
        rcPhoto: json["RcPhoto"],
        drivingLicenseNumber: json["DrivingLicenseNumber"],
        drivingLicenseIssueDate: json["DrivingLicenseIssueDate"] == null
            ? null
            : DateTime.parse(json["DrivingLicenseIssueDate"]),
        drivingLicenseExpiryDate: json["DrivingLicenseExpiryDate"] == null
            ? null
            : DateTime.parse(json["DrivingLicenseExpiryDate"]),
        drivingLicenseFrontSide: json["DrivingLicenseFrontSide"],
        drivingLicenseBackSide: json["DrivingLicenseBackSide"],
        aadharCardFrontSide: json["AadharCardFrontSide"],
        aadharCardBackSide: json["AadharCardBackSide"],
        imageFile: json["ImageFile"],
        tempId: json["TempId"],
        bgvStatusId: json["BgvStatusId"],
        bgvStatus: json["BgvStatus"],
        agreementStatusId: json["AgreementStatusId"],
        agreementStatus: json["AgreementStatus"],
        triggerAgreement: json["TriggerAgreement"],
        twoWheelerDrivingLicenseNumber: json["TwoWheelerDrivingLicenseNumber"],
        threeWheelerDrivingLicenseNumber:
            json["ThreeWheelerDrivingLicenseNumber"],
        fourWheelerDrivingLicenseNumber:
            json["FourWheelerDrivingLicenseNumber"],
        panCardImage: json["PanCardImage"],
        voterIdFrontSide: json["VoterIdFrontSide"],
        voterIdBackSide: json["VoterIdBackSide"],
        updateBy: json["UpdateBy"],
        bloodGroupId: json["BloodGroupId"],
        isOnlyRemarkUpdate: json["IsOnlyRemarkUpdate"],
        designationId: json["DesignationId"],
        daCategoryId: json["DaCategoryId"],
        paymentTypeId: json["PaymentTypeId"],
        payFrequencyId: json["PayFrequencyId"],
        routeId: json["RouteId"],
        fixAmount: json["FixAmount"],
        variableAmount: json["VariableAmount"],
        fuelAmount: json["FuelAmount"],
        fixVariable: json["FixVariable"],
        fixRateAmount: json["FixRateAmount"],
        caller: json["Caller"],
        voterId: json["VoterId"],
alternativeMobileNo: json["AlternativeMobileNo"],
useCurrentAddressAsPermanentAddress: json["UseCurrentAddressAsPermanentAddress"],
      );

  Map<String, dynamic> toJson() => {
        "AadharNumber": aadharNumber,
        "PanNumber": panNumber,
        "StatusId": statusId,
        "DriverLocationId": driverLocationId,
        "WarehouseId": warehouseId,
        "BranchId": branchId,
        "DriverLocationCode": driverLocationCode,
        "DriverCode": driverCode,
        "FromDate": fromDate?.toIso8601String(),
        "ToDate": toDate?.toIso8601String(),
        "IsApproved": isApproved,
        "Status": status,
        "Remarks": remarks,
        "SignupDriverId": signupDriverId,
        "DriverName": driverName,
        "FirstName": firstName,
        "MiddleName": middleName,
        "LastName": lastName,
        "EntryDate": entryDate?.toIso8601String(),
        "DateOfBirth": dateOfBirth?.toIso8601String(),
        "AadharCardNumber": aadharCardNumber,
        "PanCardNumber": panCardNumber,
        "MobileNo": mobileNo,
        "EmailId": emailId,
        "CurrentAddress": currentAddress,
        "PermanentAddress": permanentAddress,
        "Gender": gender,
        "Selfie": selfie,
        "StateId": stateId,
        "StateName": stateName,
        "CityId": cityId,
        "CityName": cityName,
        "Pincode": pincode,
        "BankId": bankId,
        "BranchName": branchName,
        "AccountHolderName": accountHolderName,
        "AccountNumber": accountNumber,
        "IFSCCode": ifscCode,
        "PassbookCancelCheque": passbookCancelCheque,
        "NomineeName": nomineeName,
        "NomineeContactNo": nomineeContactNo,
        "NomineeRelation": nomineeRelation,
        "Business": business,
        "BusinessId": businessId,
        "BusinessSubId": businessSubId,
        "Department": department,
        "DepartmentId": departmentId,
        "BranchState": branchState,
        "BranchStateId": branchStateId,
        "BusinessUnit": businessUnit,
        "BusinessUnitId": businessUnitId,
        "VehicleTypeId": vehicleTypeId,
        "VehicleType": vehicleType,
        "HaveDrivingLicense": haveDrivingLicense,
        "DlVehicleTypeIds": dlVehicleTypeIds,
        "DlTypeId": dlTypeId,
        "VehicleNo": vehicleNo,
        "RcPhoto": rcPhoto,
        "DrivingLicenseNumber": drivingLicenseNumber,
        "DrivingLicenseIssueDate": drivingLicenseIssueDate?.toIso8601String(),
        "DrivingLicenseExpiryDate": drivingLicenseExpiryDate?.toIso8601String(),
        "DrivingLicenseFrontSide": drivingLicenseFrontSide,
        "DrivingLicenseBackSide": drivingLicenseBackSide,
        "AadharCardFrontSide": aadharCardFrontSide,
        "AadharCardBackSide": aadharCardBackSide,
        "ImageFile": imageFile,
        "TempId": tempId,
        "BgvStatusId": bgvStatusId,
        "BgvStatus": bgvStatus,
        "AgreementStatusId": agreementStatusId,
        "AgreementStatus": agreementStatus,
        "TriggerAgreement": triggerAgreement,
        "TwoWheelerDrivingLicenseNumber": twoWheelerDrivingLicenseNumber,
        "ThreeWheelerDrivingLicenseNumber": threeWheelerDrivingLicenseNumber,
        "FourWheelerDrivingLicenseNumber": fourWheelerDrivingLicenseNumber,
        "PanCardImage": panCardImage,
        "VoterIdFrontSide": voterIdFrontSide,
        "VoterIdBackSide": voterIdBackSide,
        "UpdateBy": updateBy,
        "BloodGroupId": bloodGroupId,
        "IsOnlyRemarkUpdate": isOnlyRemarkUpdate,
        "DesignationId": designationId,
        "DaCategoryId": daCategoryId,
        "PaymentTypeId": paymentTypeId,
        "PayFrequencyId": payFrequencyId,
        "RouteId": routeId,
        "FixAmount": fixAmount,
        "VariableAmount": variableAmount,
        "FuelAmount": fuelAmount,
        "FixVariable": fixVariable,
        "FixRateAmount": fixRateAmount,
        "Caller": caller,
        "VoterId": voterId, "AlternativeMobileNo": alternativeMobileNo,
"UseCurrentAddressAsPermanentAddress": useCurrentAddressAsPermanentAddress,
      };
}
