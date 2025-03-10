import 'dart:io';
import 'dart:ui';

import 'package:abhilaya/controller/auth_controller/signup_controller.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:abhilaya/view/auth/signup_steeper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectOnboarding extends StatefulWidget {
  const SelectOnboarding({Key? key}) : super(key: key);

  @override
  State<SelectOnboarding> createState() => _SelectOnboardingState();
}

class _SelectOnboardingState extends State<SelectOnboarding> {
  var signupController = Get.find<SignupController>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
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
          }},

      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.96,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(16)),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFF9B55),
                                    Color(0xFFE15D29)
                                  ],
                                  begin: Alignment.topCenter,
                                  stops: [0.4, 1.0],
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: SafeArea(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/images/abhi_logo.png",
                                      height:
                                      MediaQuery.sizeOf(context).height *
                                          0.08,
                                      width: MediaQuery.sizeOf(context).width,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: h * 0.02, horizontal: w * 0.025),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  BuildOnBoardingItem(
                                    text: "DA \nOnboarding",
                                    iconPath: "assets/images/DAonboarding.png",
                                    onPressed: () {
                                      signupController.selectedOnBoardingType.value = "DA";

                                      setState(() {
                                        signupController.clearValues();
                                      });
                                      Get.to(SignupSteeperForm());
                                    },
                                  ),
                                  BuildOnBoardingItem(
                                    text: "Vendor \nOnboarding",
                                    iconPath: "assets/images/VendorOnboarding.png",
                                    onPressed: () {
                                      signupController.selectedOnBoardingType.value = "Vendor";
                                      MyToast.myShowToast("Work In Progress");
                                    },
                                  ),
                                  BuildOnBoardingItem(
                                    text: "Vehicle \nOnboarding",
                                    iconPath: "assets/images/vehicleOnboarding.png",
                                    onPressed: () {
                                      signupController.selectedOnBoardingType.value = "Vehicle";
                                      MyToast.myShowToast("Work In Progress");
                                    },
                                  ),
                                  /* Container(
                                    width: w * 0.275,
                                    height: h * 0.145,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0xffE7E5ED)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          signupController.selectedOnBoardingType.value = "DA";
                                          Get.to(SignupSteeperForm());
                                        },
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/DAonboarding.png",
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.08,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: h * 0.005),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "DA     Onboarding",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Color(0xFF7A7A7A),
                                                    fontWeight: FontWeight.w400,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),*/
                                  /* Container(
                                    width: w * 0.275,
                                    height: h * 0.145,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0xffE7E5ED)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          signupController.selectedOnBoardingType.value = "Vendor";
                                          MyToast.myShowToast("Work In Progress");
                                        },
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/VendorOnboarding.png",
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.08,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: h * 0.005),
                                              child: Text(
                                                "Vendor Onboarding",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Color(0xFF7A7A7A),
                                                  fontWeight: FontWeight.w400,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),*/
                                  /*Container(
                                    width: w * 0.275,
                                    height: h * 0.145,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0xffE7E5ED)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          signupController.selectedOnBoardingType.value = "Vehicle";
                                          MyToast.myShowToast(
                                              "Work In Progress");
                                        },
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/vehicleOnboarding.png",
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.08,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: h * 0.005),
                                              child: Text(
                                                "Vehicle Onboarding",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Color(0xFF7A7A7A),
                                                  fontWeight: FontWeight.w400,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildOnBoardingItem ({required void Function()? onPressed,required String iconPath,required String text}) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      width: w * 0.275,

      decoration: BoxDecoration(
        border: Border.all(
            width: 1, color: Color(0xffE7E5ED)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
          onPressed: onPressed,
          child: Column(
            children: [
              Image.asset(
                iconPath,
                height: MediaQuery.sizeOf(context)
                    .height *
                    0.08,
                width: MediaQuery.sizeOf(context)
                    .width,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: h * 0.005),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xFF7A7A7A),
                      fontWeight: FontWeight.w400,
                      overflow:
                      TextOverflow.visible,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )),
    );
  }

}
