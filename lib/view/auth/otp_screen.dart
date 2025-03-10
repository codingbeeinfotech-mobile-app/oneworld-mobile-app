import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/controller/auth_controller/signup_controller.dart';
import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:abhilaya/view/auth/loginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';

import '../../model/response_model/otp_response.dart';
import '../../model/signup_model/registration_req.dart';
import '../../utils/custom_steeper.dart';
import '../../utils/toast.dart';

class OtpScreens extends StatefulWidget {
  const OtpScreens({Key? key}) : super(key: key);

  @override
  State<OtpScreens> createState() => _OtpScreensState();
}

class _OtpScreensState extends State<OtpScreens> {
  var signupController = Get.find<SignupController>();

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFFFC59D)),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white),
  );

  List<Step> stepsList() => [
        Step(
            isActive: signupController.otpPageCurrentStep.value == 0,
            title: const Text(""),
            content: Container(
              color: Colors.red,
            )),
        Step(
            isActive: signupController.otpPageCurrentStep.value >= 1,
            title: const Text(""),
            content: buildSecondStep()),
      ];

  static const int otpResendTimeout = 30;
  late Timer _timer;
  int _start = otpResendTimeout;
  bool _isButtonDisabled = true;
  bool _istimerStarted = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 0),
      () {
        signupController.otpPageCurrentStep.value = 0;
        signupController.signupMobileNumber.value.clear();
      },
    );
  }

  void startTimer() {
    _isButtonDisabled = true;
    _start = otpResendTimeout;
    _istimerStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          _isButtonDisabled = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void resendOtp() async {
    startTimer();
    var rnd = Random();
    signupController.signupOtpSendValue.value = rnd.nextInt(900000) + 100000;
    if (kDebugMode) {
      signupController.signupOtpEntered.value.text =
          signupController.signupOtpSendValue.value.toString();
      setState(() {
        signupController.otpPageCurrentStep.value = 1;
      });
    } else {
      var res = await http.get(Uri.parse(
          "http://www.alots.in/sms-panel/api/http/index.php?username=ONEWORLD&apikey=DD6DB-CF1A0&apirequest=Text&sender=ABLAYA&mobile=${signupController.signupMobileNumber.value.text}&message=Your OTP for order cancellation is ${signupController.signupOtpSendValue.value.toString()}. Thanks, Abhilaya&route=TRANS&TemplateID=1707172492906259944&format=JSON" /* "http://api.bulksmsgateway.in/sendmessage.php?user=Surya769&password=Isourse@123\$&mobile=${signupController.signupMobileNumber.value.text}&message=Hi, Your OTP for Abhilaya Registration is ${signupController.signupOtpSendValue.value.toString()}. Thanks, Isourse&sender=ISOTPL&type=3&template_id=1207171325511576880"*/));
      print("---0=$res");
      if (res.statusCode == 200) {
        var decode = json.decode(res.body);
        var data = SendOtpResponse.fromJson(decode);
        if (data.status == 'success') {
          setState(() {
            signupController.otpPageCurrentStep.value = 1;
            signupController.signupOtpEntered.value.text = '';
          });
        } else {
          MyToast.myShowToast("${data.status} while sending otp");
          //Error Toast
        }
      }
    }
    setState(() {
      signupController.otpPageCurrentStep.value = 1;
    });
    // Get.offAll(const Dashboard());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          showDialog(
              context: context,
              builder: (context) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: AlertDialog(
                      contentPadding: const EdgeInsets.all(20),
                      backgroundColor: Colors.white,
                      title: const Text('Hey User'),
                      content: const Text('Are you sure you want to exit?'),
                      actions: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange.shade500),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange.shade500),
                            onPressed: () {
                              // Get.offAll(LoginPage());
                              exit(0);
                            },
                            child: const Text('Exit')),
                      ],
                    ),
                  ));
          return;
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              NumberStepper(
                totalSteps: stepsList().length,
                width: MediaQuery.of(context).size.width,
                curStep: signupController.otpPageCurrentStep.value,
                stepCompleteColor: Colors.deepOrange,
                currentStepColor: Colors.transparent,
                inactiveColor: Colors.grey.shade200,
                lineWidth: 2.5,
              ),
              signupController.otpPageCurrentStep.value == 0
                  ? buildFirstStep()
                  : signupController.otpPageCurrentStep.value == 1
                      ? buildSecondStep()
                      : signupController.otpPageCurrentStep.value == 2,
            ],
          ),
        ),
      ),
    );
  }

  buildFirstStep() {
    var loginController = Get.find<LoginController>();
    GeneralMethods generalMethods = GeneralMethods();
    return Container(
      height: MediaQuery.of(context).size.height * 0.96,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            bottom: -(MediaQuery.sizeOf(context).height * 0.01),
            left: -(MediaQuery.sizeOf(context).width * 0.01),
            right: -(MediaQuery.sizeOf(context).width * 0.01),
            child: Image.asset(
              "assets/images/login_background.png",
              height: MediaQuery.sizeOf(context).height * 0.42,
              fit: BoxFit.fill,
              width: MediaQuery.sizeOf(context).width,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              color: Colors.white
                  .withOpacity(0.95), // Optional translucent overlay
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              gradient: LinearGradient(
                  colors: [Color(0xFFFF9B55), Color(0xFFE15D29)],
                  begin: Alignment.topCenter,
                  stops: [
                    0.4,
                    30.0,
                  ],
                  end: Alignment.bottomCenter),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  Image.asset(
                    "assets/images/abhi_logo.png",
                    height: MediaQuery.sizeOf(context).height * 0.08,
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.2,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.04,
                  vertical: MediaQuery.sizeOf(context).height * 0.015),
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.03),
              decoration: BoxDecoration(
                  color: Color(0xFFFFEFE6),
                  borderRadius: BorderRadius.circular(12)),
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Welcome to Abhilaya",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 25),
                        ),
                        const SizedBox(height: 5),
                        const Text("Create your Account",
                            style:
                                TextStyle(fontSize: 15, color: Colors.black45)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Enter Mobile No.",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          child: TextFormField(
                            maxLength: 10,
                            controller:
                                signupController.signupMobileNumber.value,
                            focusNode: signupController
                                .signupMobileNumberFocusNode.value,
                            onChanged: (value) {
                              if (value.length == 10) {
                                signupController
                                    .signupMobileNumberFocusNode.value
                                    .unfocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: loginController
                                        .usernameFocusNode.value.hasFocus
                                    ? Colors.black
                                    : Colors.black45,
                                fontSize: 14),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                              hintText: 'Enter Here',
                              counterText: "",
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.black45, fontSize: 14),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFFFC59D), width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFFFC59D), width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color(0xFFFFC59D), width: 1)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 50,
                      child: InkWell(
                        onTap: () async {
                          if (loginController.connectionStatus.value ==
                              "ConnectivityResult.none") {
                            print("YESS");
                            await generalMethods.initConnectivity();
                          } else {
                            if (signupController.signupMobileNumber.value.text
                                        .trim()
                                        .length ==
                                    10 &&
                                !signupController.signupMobileNumber.value.text
                                    .startsWith("0") &&
                                signupController.signupMobileNumber.value.text
                                    .isNumericOnly) {
                              var rnd = Random();
                              signupController.signupOtpSendValue.value =
                                  rnd.nextInt(900000) + 100000;
                              if (kDebugMode) {
                                signupController.signupOtpEntered.value.text =
                                    signupController.signupOtpSendValue.value
                                        .toString();
                                setState(() {
                                  signupController.otpPageCurrentStep.value = 1;
                                });
                                createAccount();   setState(() {

                                });
                              } else {
                                // http://www.alots.in/sms-panel/api/http/index.php?username=ONEWORLD&apikey=DD6DB-CF1A0&apirequest=Text&sender=ABLAYA&mobile=${signupController.signupMobileNumber.value.text}&message=Your OTP for order cancellation is ${signupController.signupOtpSendValue.value.toString()}. Thanks, Abhilaya&route=TRANS&TemplateID=1707172492906259944&format=JSON"

                                var res = await http.get(Uri.parse(
                                    "http://www.alots.in/sms-panel/api/http/index.php?username=ONEWORLD&apikey=DD6DB-CF1A0&apirequest=Text&sender=ABLAYA&mobile=${signupController.signupMobileNumber.value.text}&message=Hi, your otp ${signupController.signupOtpSendValue.value.toString()} for Abhilaya registration . Please use this to complete your signup. Regards, Abhilaya&route=TRANS&TemplateID=1707174013861015096&format=JSON" /* "http://api.bulksmsgateway.in/sendmessage.php?user=Surya769&password=Isourse@123\$&mobile=${signupController.signupMobileNumber.value.text}&message=Hi, Your OTP for Abhilaya Registration is ${signupController.signupOtpSendValue.value.toString()}. Thanks, Isourse&sender=ISOTPL&type=3&template_id=1207171325511576880"*/));
                                print("res6546=-=- $res");
                                if (res.statusCode == 200) {
                                  var decode = json.decode(res.body);
                                  var data = SendOtpResponse.fromJson(decode);
                                  if (data.status == 'success') {
                                    setState(() {
                                      signupController
                                          .otpPageCurrentStep.value = 1;
                                      signupController
                                          .signupOtpEntered.value.text = '';
                                    });
                                  } else {
                                    MyToast.myShowToast(
                                        "${data.status} while sending otp");
                                    //Error Toast
                                  }
                                }
                              }
                              setState(() {
                                signupController.otpPageCurrentStep.value = 1;
                              });
                              // Get.offAll(const Dashboard());
                            } else {
                              MyToast.myShowToast(
                                  "Please enter valid Mobile Number");
                            }
                          }
                          // Dialogs.signUpLoading(context);
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(48),
                            gradient: LinearGradient(
                                colors: [Color(0xFFFF9B55), Color(0xFFE15D29)],
                                begin: Alignment.topCenter,
                                stops: [
                                  0.1,
                                  30.0,
                                ],
                                end: Alignment.bottomCenter),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Generate OTP",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.sizeOf(context).width * 0.04,
                      left: MediaQuery.sizeOf(context).width * 0.04),
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.sizeOf(context).height * 0.02),
                  decoration: BoxDecoration(
                      color: Color(0xFFFFEFE6),
                      border: Border.all(color: Color(0xFFFFC59D)),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const LoginPage());
                        },
                        child: Text(
                          "  Sign In",
                          style: TextStyle(
                              color: Color(0xFFFF9B55),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  void createAccount() async {
    RegistrationReq registrationReq = RegistrationReq(
        cLIENTID: "8",
        cLIENTNAME: "One_World",
        contactNo: signupController.signupMobileNumber.value.text.trim(),
        emailAddress: "",
        employeeId: "",
        name: "",
        password: "",
        sREDesignation: "",
        sREManagerType: "",
        timeStamp: "");
    setState(() {});
    await signupController.getSignupDriverId(registrationReq);
    setState(() {});
    setState(() {});
    setState(() {});
  }

  buildSecondStep() {
    var loginController = Get.find<LoginController>();
    GeneralMethods generalMethods = GeneralMethods();
    if (!_istimerStarted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (signupController.otpPageCurrentStep.value == 1 &&
            _istimerStarted == false) {
          setState(() {
            startTimer();
          });
        }
      });
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.96,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            bottom: -(MediaQuery.sizeOf(context).height * 0.01),
            left: -(MediaQuery.sizeOf(context).width * 0.01),
            right: -(MediaQuery.sizeOf(context).width * 0.01),
            child: Image.asset(
              "assets/images/login_background.png",
              height: MediaQuery.sizeOf(context).height * 0.42,
              fit: BoxFit.fill,
              width: MediaQuery.sizeOf(context).width,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              color: Colors.white
                  .withOpacity(0.95), // Optional translucent overlay
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              gradient: LinearGradient(
                  colors: [Color(0xFFFF9B55), Color(0xFFE15D29)],
                  begin: Alignment.topCenter,
                  stops: [
                    0.4,
                    30.0,
                  ],
                  end: Alignment.bottomCenter),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  Image.asset(
                    "assets/images/abhi_logo.png",
                    height: MediaQuery.sizeOf(context).height * 0.08,
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          // const SizedBox(height:15),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.2,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.04,
                  vertical: MediaQuery.sizeOf(context).height * 0.015),
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.03),
              decoration: BoxDecoration(
                  color: Color(0xFFFFEFE6),
                  borderRadius: BorderRadius.circular(12)),
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Welcome to Abhilaya",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 25),
                        ),
                        const SizedBox(height: 5),
                        const Text("Create your Account",
                            style:
                                TextStyle(fontSize: 15, color: Colors.black45)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Enter Mobile No.",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            InkWell(
                              onTap: () {
                                debugPrint("change number");
                                signupController.otpPageCurrentStep.value = 0;
                                signupController.driverDetailModel = null;
                                setState(() {
                                  signupController.signupMobileNumber.value
                                      .clear();
                                });
                                debugPrint(
                                    "Number ${signupController.otpPageCurrentStep.value}");
                              },
                              child: const Text("Edit Phone",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFF9B55),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          child: TextFormField(
                            readOnly: true,
                            maxLength: 10,
                            controller:
                                signupController.signupMobileNumber.value,
                            focusNode: signupController
                                .signupMobileNumberFocusNode.value,
                            onChanged: (value) {
                              if (value.length == 10) {
                                signupController
                                    .signupMobileNumberFocusNode.value
                                    .unfocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: loginController
                                        .usernameFocusNode.value.hasFocus
                                    ? Colors.black
                                    : Colors.black45,
                                fontSize: 14),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                              hintText: 'Enter Here',
                              counterText: "",
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.black45, fontSize: 14),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.black12, width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.black12, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 1)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Enter OTP",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        const SizedBox(height: 5),
                        Pinput(
                          defaultPinTheme: defaultPinTheme,
                          length: 6,
                          controller: signupController.signupOtpEntered.value,
                          focusNode:
                              signupController.signupOtpEnteredFocusNode.value,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsUserConsentApi,
                          onCompleted: (value) async {
                            debugPrint(
                                "Sent -> ${signupController.signupOtpSendValue.value.toString()} and entered -> ${signupController.signupOtpEntered.value.text}");
                            if (loginController.connectionStatus.value ==
                                "ConnectivityResult.none") {
                              await generalMethods.initConnectivity();
                            } else {
                              if (signupController.signupOtpSendValue.value
                                      .toString() ==
                                  signupController
                                      .signupOtpEntered.value.text) {
                                createAccount();   setState(() {

                                });
                              } else {
                                MyToast.myShowToast("Wrong OTP");
                              }
                            }
                          },
                          listenForMultipleSmsOnAndroid: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Resend in $_start seconds',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black45),
                          ),
                          Visibility(
                            child: TextButton(
                              onPressed: _isButtonDisabled ? null : resendOtp,
                              child: Text(
                                'Resend OTP',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: _isButtonDisabled
                                        ? Colors.black45
                                        : Colors.deepOrange.shade500),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Container(
                    //   height: 50,
                    //   child: InkWell(
                    //     onTap: () async {
                    //       debugPrint(
                    //           "Sent -> ${signupController.signupOtpSendValue.value.toString()} and entered -> ${signupController.signupOtpEntered.value.text}");
                    //       if (loginController.connectionStatus.value ==
                    //           "ConnectivityResult.none") {
                    //         await generalMethods.initConnectivity();
                    //       } else {
                    //         if (signupController.signupOtpSendValue.value
                    //                 .toString() ==
                    //             signupController.signupOtpEntered.value.text) {
                    //
                    //           createAccount();
                    //         } else {
                    //           MyToast.myShowToast("Wrong OTP");
                    //         }
                    //       }
                    //     },
                    //     child: Container(
                    //       width: MediaQuery.sizeOf(context).width * 0.4,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(48),
                    //         gradient: LinearGradient(
                    //             colors: [Color(0xFFFF9B55), Color(0xFFE15D29)],
                    //             begin: Alignment.topCenter,
                    //             stops: [
                    //               0.1,
                    //               30.0,
                    //             ],
                    //             end: Alignment.bottomCenter),
                    //       ),
                    //       child: const Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           Text("Continue",
                    //               style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 15,
                    //                   fontWeight: FontWeight.bold)),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.sizeOf(context).width * 0.04,
                      left: MediaQuery.sizeOf(context).width * 0.04),
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.sizeOf(context).height * 0.02),
                  decoration: BoxDecoration(
                      color: Color(0xFFFFEFE6),
                      border: Border.all(color: Color(0xFFFFC59D)),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const LoginPage());
                        },
                        child: Text(
                          "  Sign In",
                          style: TextStyle(
                              color: Color(0xFFFF9B55),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
