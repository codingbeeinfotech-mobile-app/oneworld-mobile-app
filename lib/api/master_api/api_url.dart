class ApiUrl {
  ///--------------------------------Live------------------------------------------------
  static String baseUrl = "https://blinkit.isoping.com:92/";
   static String baseUrl2 = "https://abhilaya.in:4433/";
   static String baseUrl3 = "https://abhilaya.in:4433/";
   static String baseUrl4 = "https://abhilaya.in:4433/";
   static String baseUrl5 = "https://abhilaya.in:44333/";
   static String baseUrl4WithS = "https://abhilaya.in:4433/";
  static String baseUrl6 = "https://52.172.145.215:4433/";

  ///--------------------------------Test------------------------------------------------
  // static String baseUrl = "https://blinkit.isoping.com:92/";
  // static String baseUrl2 = "https://abhilaya.in:8443/";
  // static String baseUrl3 = "https://abhilaya.in:8443/";
  // static String baseUrl4 = "https://abhilaya.in:8443/";
  // static String baseUrl5 = "https://abhilaya.in:4430/";
  // static String baseUrl4WithS = "https://abhilaya.in:8443/";
  // static String baseUrl6 = "https://52.172.145.215:8443/";




  /// --------------------- PayPhiLive -------------------
  static String payPhiUrl = "https://secure-ptg.payphi.com/";
  static String payPhiSecretKey = "dab36a06ca064106a4ae442e0baac82e";
  static String payPhiMerchantId = "P_32395";

  ///----------Exotel-------
  static String callUrl =
      "https://api.exotel.com/v1/Accounts/ad6521/Calls/connect";

  ///-----------------------------new Url------------------

  //static String baseUrl2 = " https://neha.isopronto.com:8490/";  /* live Url*/
  //static String baseUrl4 = "https://oneworld.isopronto.com";  /*One World Live URL */

  ///---------------------------Test--------------------------------------------------

  //
  // static  String baseUrl = "https://demo.isoping.com:7283/";
  // static String baseUrl2 = "https://demo.isopronto.com:7286/";
  // static String baseUrl3 = "https://demo.isoping.com:7331/";       //printing test
  // // static String baseUrl3 = "https://192.168.222.40:6640/";      //printing development
  // // static String baseUrl4 = "https://demo.isopronto.com:7193/";  //old
  // static String baseUrl4 = "https://demo.isopronto.com:6651/";     //new
  // static String baseUrl4WithS = "https://demo.isopronto.com:6651/";
  // static String baseUrl5  = "https://demo.isoping.com:6671/";

  /// --------------- PayPhiTest -------------------
  // static String payPhiUrl = "https://qa.phicommerce.com/";
  // static String payPhiSecretKey = "abc";
  // static String payPhiMerchantId = "T_24746";
  // public static String NODE_BASE_URL = "https://demo.isoping.com:7331/"; //Node Base Test Url   //public url

  /// ------PayPhi End-points ----------
  static String payPhiQrGenerator = "pg/api/generateQR";
  static String payPhiStatusCheck = "pg/api/command";

  ///6671
  static String getReasonList = "API/TMS/GetRtoNdrData";
  static String getVendorList = "api/TMS/GetVendorList";
  static String getVendorData = "api/TMS/GetVendorData";
  static String submitNprShipments = "api/TMS/submitNonPickupShipment";

  ///7193 = 6651
  static String dashboard = "api/Odn/GetUserDashBaordDetails";

  static String ndrList =
      "api/Odn/GetOdnNdrReturnReason"; // getOdnNdrReturnReason GetOdnNprReason
  static String returnPickupNdrList = "api/Odn/GetOdnNprReason";

  static String isOdnReturnPickingTrackingNoValid =
      "api/Odn/IsOdnReturnPickingTrackingNoValid";
  static String hubOrderSubmit = "api/Odn/HubOrderSubmit";
  static String submitDelivery = "api/Odn/SubmitDelivery";
  static String isDeliveryTrackingNoValid = "api/Odn/IsDeliveryTrackingNoValid";
  static String isPickingTrackingNoValid = "api/Odn/IsPickingTrackingNoValid";
  static String isNdrTrackingNoValid = "api/Odn/IsNdrTrackingNoValid";
  static String submitNdrDelivery = "api/Odn/SubmitNdrDelivery";
  static String getOdnQualityCheckFailedReason =
      "api/Odn/GetOdnQualityFailedReason";
  static String odnReturnSubmitPick = "api/Odn/OdnReturnSubmitPick";
  static String getNotificationDataById = "api/Odn/GetNotificationDataById";
  static String getDutyStatus = "api/Odn/GetDutyStatusbyUser";
  static String getDriverStatus = "api/Odn/GetDriverStatusbyUser";

  // static String deliveryLocationList = "api/Odn/GetDeliveryByLocation";
  // static String getNdrByLocation = "api/Odn/GetNdrByLocation";
  // static String getBulkPickup = "api/Odn/GetBulkPick";
  // static String getPickingOdnReturnByLocation = "api/Odn/GetPickingOdnReturnByLocation";
  static String deliveryLocationList = "api/Odn/GetDeliveryByLocationNew";
  static String getUserList = "api/User/GetUserList";
  static String getNdrByLocation = "api/Odn/GetNdrByLocationNew";
  static String getBulkPickup = "api/Odn/GetBulkPickNew";
  static String isTrackingNumberValidForBulkPickup =
      "api/Odn/IsTrackingNumberValidForBulkPickup";
  static String getPickingOdnReturnByLocation =
      "api/Odn/GetPickingOdnReturnByLocationNew";

  ///7283

  static String master = "api/Odn/GetMasterDataList";
  static String getBloodGroupList = "api/Odn/GetBloodGroupList";
  static String changePassword = 'api/User/ChangePasswordInMainTable';
  static String getDetailsByPinCode = "api/pincode/GetDetailsByPincode";
  static String signUpSubmit = "api/driver/SignUpDriverInsert";

  static String createAccount = "api/values/SubmitSignUp";
  static String getInsuranceDetails = "api/GSP/Get_Insurance_Documents";
  static String getAppVersion = "api/Values/GetUserInfo";
  static String getSignupDriverId = "api/driver/GetSignUpDriverDetailsByMobileNo";
  static String isAadharCardNumberAvailable = "api/driver/IsAadharCardNumberAvailable";
  static String isPanCardNumberAvailable = "api/driver/IsPanCardNumberAvailable";

  ///7286

  static String loginToken = "token";
  static String login = "api/User/UserLogin";
  static String logout = 'api/User/UserLogout';

  ///6640
  static String validatePrintTrackingNumber = "UC/TrackingDetails";

  static String dlVehicleTypeList = "api/general/GetGeneralListById?codeTypeId=137";
  static String vehicleTypeList = "api/general/GetGeneralListById?codeTypeId=115";
  static String dlTypeList = "api/general/GetGeneralListById?codeTypeId=139";




}

/*
    private static final String BASE_URL3 = "http://api.bulksmsgateway.in/"; /*temporay URL for otp */
//  static final String BASE_URL = "http://neha.isopronto.com:8489/";  /* live Url*/
  public static String TP_BASE_URL = "https://blinkit.isoping.com:92/";  //live url
//  private static final String BASE_URL2 = "http://oneworld.isopronto.com/";  /*One World Live URL */
  public static String NODE_BASE_URL = "https://oneworld.isopronto.com:1048/"; //Node Base Test Url
    //-----------------------------new Url------------------
    private static final String BASE_URL2 = "https://oneworld.isopronto.com";  /*One World Live URL */
    static final String BASE_URL = " https://neha.isopronto.com:8490/";  /* live Url*/
 */
