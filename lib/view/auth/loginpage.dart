import 'dart:io';
import 'dart:ui';

import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/general/alert_boxes.dart';
import 'otp_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GeneralMethods generalMethods = GeneralMethods();
  var loginController = Get.find<LoginController>();
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (!didPop) {
            showDialog(
                context: context,
                builder: (context) =>
                    BackdropFilter(
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
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                    borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
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
                // const SizedBox(height:10),
                // Divider(color: Colors.black,thickness: 1,),

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Welcome, Back",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 28),
                            ),
                            const SizedBox(height: 5),
                            const Text("Sign in to your Account",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black45)),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("User Name",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                            const SizedBox(height: 5),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.05,
                              child: TextFormField(
                                  controller: loginController.username.value,
                                  focusNode:
                                  loginController.usernameFocusNode.value,
                                  maxLines: 1,
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
                                    alignLabelWithHint: false,
                                    hintText: 'Username',
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintStyle: TextStyle(
                                        color: Colors.black45, fontSize: 14),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFFFC59D),
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFFFC59D),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Color(0xFFFFC59D),
                                            width: 1)),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Password",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                            const SizedBox(height: 5),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.05,
                              child: TextFormField(
                                style: TextStyle(
                                    color: loginController
                                        .usernameFocusNode.value.hasFocus
                                        ? Colors.black
                                        : Colors.black45,
                                    fontSize: 14),
                                focusNode:
                                loginController.passwordFocusNode.value,
                                controller: loginController.password.value,
                                obscureText: isHidden,
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                    hintStyle: TextStyle(
                                        color: Colors.black45, fontSize: 14),
                                    hintText: 'Password',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFFFC59D),
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFFFC59D),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Color(0xFFFFC59D),
                                            width: 1)),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          isHidden
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 18,
                                          color: isHidden
                                              ? Colors.black45
                                              : Colors.deepOrange.shade500),
                                      onPressed: () {
                                        setState(() {
                                          isHidden = !isHidden;
                                        });
                                      },
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Container(
                          height: 50,
                          child: InkWell(
                            onTap: () async {
                              if (loginController.connectionStatus.value ==
                                  "ConnectivityResult.none") {
                                await generalMethods.initConnectivity();
                              } else {
                                var isLoginDetailsValid =
                                validateLoginDetails();

                                if (isLoginDetailsValid) {
                                  Dialogs.lottieLoading(context,
                                      "assets/lottiee/abhi_loading.json");
                                  await loginController.callLoginApi();
                                  if (loginController.loginResponse != null) {
                                    if (loginController
                                        .loginResponse?.fLAGMSG !=
                                        null &&
                                        loginController
                                            .loginResponse?.fLAGMSG ==
                                            "User Is Already Login on Another Device") {
                                      MyToast.myShowToast(
                                          "User Is Already Login on Another Device");
                                      Navigator.pop(context);
                                    } else if (loginController
                                        .loginResponse!.isLogin.isEmpty ||
                                        (loginController
                                            .loginResponse?.fLAGMSG !=
                                            null &&
                                            loginController
                                                .loginResponse?.fLAGMSG ==
                                                "Please check your credential.")) {
                                      MyToast.myShowToast(
                                          "Please check your credentials or SignUp");
                                      Navigator.pop(context);
                                    } else if (loginController
                                        .loginResponse!.isLogin.isEmpty ||
                                        (loginController
                                            .loginResponse?.fLAGMSG !=
                                            null &&
                                            loginController
                                                .loginResponse?.fLAGMSG ==
                                                "User In-Active.")) {
                                      MyToast.myShowToast(
                                          "Please check!! User is inactive!");
                                      Navigator.pop(context);
                                    } else {
                                      MyToast.myShowToast("Login Successful");
                                      SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'userId',
                                          loginController
                                              .loginResponse!.uSERID);
                                      prefs.setString(
                                          'userName',
                                          loginController
                                              .loginResponse!.uSERNAME);
                                      prefs.setString(
                                          'mobileNo',
                                          loginController
                                              .loginResponse!.mOBILENO);
                                      prefs.setString(
                                          'clientId',
                                          loginController
                                              .loginResponse!.cLIENTID);
                                      prefs.setString(
                                          'clientName',
                                          loginController
                                              .loginResponse!.cLIENTNAME);
                                      prefs.setString(
                                          'companyId',
                                          loginController
                                              .loginResponse!.cOMPANYID);
                                      prefs.setString(
                                          'warehouseId',
                                          loginController
                                              .loginResponse!.wAREHOUSEID);
                                      prefs.setString(
                                          'roleId',
                                          loginController
                                              .loginResponse!.rOLEID);
                                      prefs.setString(
                                          'flagMsg',
                                          loginController
                                              .loginResponse!.fLAGMSG);
                                      prefs.setString(
                                          'isLogin',
                                          loginController
                                              .loginResponse!.isLogin);

                                      Get.offAll(BottomNavBar());
                                      // Get.to(temp());
                                    }
                                  }
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(48),
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFF9B55),
                                      Color(0xFFE15D29)
                                    ],
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
                                  Text("Log In",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
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
                            bottom: 10,
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
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(const OtpScreens());
                              },
                              child: Text(
                                "  Sign Up",
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
          ),
        ),
      ),
       );
  }

  validateLoginDetails() {
    if (loginController.username.value.text.isEmpty) {
      MyToast.myShowToast("Please enter valid Username");
      loginController.usernameFocusNode.value.requestFocus();
      return false;
    } else if (loginController.password.value.text.isEmpty) {
      MyToast.myShowToast("Please enter valid Password");
      loginController.passwordFocusNode.value.requestFocus();
      return false;
    } else {
      return true;
    }
  }
}
