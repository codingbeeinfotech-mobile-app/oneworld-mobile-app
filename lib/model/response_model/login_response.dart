class LoginResponseModel {
  late String uSERNAME;
  late String uSERID;
  late String mOBILENO;
  late String cLIENTID;
  late String cLIENTNAME;
  late String cOMPANYID;
  late String wAREHOUSEID;
  late String rOLEID;
  late String fLAGMSG;
  late String fcmToken;
  late int userTypeId;
  late String isLogin;

  LoginResponseModel(
      {required this.uSERNAME,
      required this.uSERID,
      required this.mOBILENO,
      required this.cLIENTID,
      required this.cLIENTNAME,
      required this.cOMPANYID,
      required this.wAREHOUSEID,
      required this.rOLEID,
      required this.fLAGMSG,
      required this.fcmToken,
      required this.userTypeId,
      required this.isLogin});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    uSERNAME = json['UserName'] ?? '';
    uSERID = json['UserId'] ?? '';
    mOBILENO = json['MobileNo'] ?? '';
    cLIENTID = json['ClientId'] ?? '';
    cLIENTNAME = json['ClientName'] ?? '';
    cOMPANYID = json['CompanyId'] ?? '';
    wAREHOUSEID = json['WareHouseId'] ?? '';
    rOLEID = json['RoleId'] ?? '';
    fLAGMSG = json['FlagMsg'] ?? '';
    fcmToken = json['FcmToken'] ?? '';
    userTypeId = json['UserTypeId'] ?? '';
    isLogin = json['IsLogin'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserName'] = uSERNAME;
    data['UserId'] = uSERID;
    data['MobileNo'] = mOBILENO;
    data['ClientId'] = cLIENTID;
    data['ClientName'] = cLIENTNAME;
    data['CompanyId'] = cOMPANYID;
    data['WareHouseId'] = wAREHOUSEID;
    data['RoleId'] = rOLEID;
    data['FcmToken'] = fcmToken;
    data['UserTypeId'] = userTypeId;
    data['FlagMsg'] = fLAGMSG;
    data['IsLogin'] = isLogin;
    return data;
  }
}
