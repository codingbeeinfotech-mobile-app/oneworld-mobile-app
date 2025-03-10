import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:abhilaya/controller/auth_controller/signup_controller.dart';
import 'package:abhilaya/model/response_model/master_response.dart';
import 'package:abhilaya/utils/auth_utils/signup_success.dart';
import 'package:abhilaya/utils/general/alert_boxes.dart';
import 'package:abhilaya/view/auth/select_onBoarding.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../utils/custom_steeper.dart';
import '../../utils/image_picker.dart';
import '../../utils/toast.dart';

class SignupSteeperForm extends StatefulWidget {
  const SignupSteeperForm({super.key});

  @override
  State<SignupSteeperForm> createState() => _SignupSteeperFormState();
}

class _SignupSteeperFormState extends State<SignupSteeperForm> {
  var signupController = Get.find<SignupController>();

  List<Step> stepsList() => [
        Step(
            isActive: signupController.signupSteeperCurrentPage.value == 0,
            title: SizedBox(
                child: signupController.signupSteeperCurrentPage.value == 0
                    ? Icon(
                        Icons.circle,
                        color: Colors.deepOrange.shade500,
                      )
                    : const Icon(Icons.circle_outlined)),
            content: buildFirstStage()),
        Step(
            isActive: signupController.signupSteeperCurrentPage.value >= 1,
            title: SizedBox(
                // width: 50,
                child: signupController.signupSteeperCurrentPage.value == 1
                    ? const Icon(Icons.circle)
                    : const Icon(Icons.circle_outlined)),
            content: buildSecondStage()),
        Step(
            isActive: signupController.signupSteeperCurrentPage.value >= 2,
            title: SizedBox(
                // width: 50,
                child: signupController.signupSteeperCurrentPage.value == 2
                    ? const Icon(Icons.circle)
                    : const Icon(Icons.circle_outlined)),
            content: buildThirdStage()),
        Step(
            isActive: signupController.signupSteeperCurrentPage.value >= 3,
            title: SizedBox(
                // width: 50,
                child: signupController.signupSteeperCurrentPage.value == 3
                    ? const Icon(Icons.circle)
                    : const Icon(Icons.circle_outlined)),
            content: buildFourthStage()),
        Step(
            isActive: signupController.signupSteeperCurrentPage.value >= 4,
            title: SizedBox(
                // width: 50,
                child: signupController.signupSteeperCurrentPage.value == 4
                    ? const Icon(Icons.circle)
                    : const Icon(Icons.circle_outlined)),
            content: buildFifthStage()),
        Step(
            isActive: signupController.signupSteeperCurrentPage.value >= 5,
            title: SizedBox(
                // width: 50,
                child: signupController.signupSteeperCurrentPage.value == 5
                    ? const Icon(Icons.circle)
                    : const Icon(Icons.circle_outlined)),
            content: buildSixthStage()),
        // Step(
        //     isActive: signupController.signupSteeperCurrentPage.value >= 6,
        //     title: SizedBox(
        //         // width: 50,
        //         child: signupController.signupSteeperCurrentPage.value == 6
        //             ? const Icon(Icons.circle)
        //             : const Icon(Icons.circle_outlined)),
        //     content: buildSeventhStage()),
        // Step(
        //     isActive: signupController.signupSteeperCurrentPage.value >= 7,
        //     title: SizedBox(
        //         // width: 50,
        //         child: signupController.signupSteeperCurrentPage.value == 7
        //             ? const Icon(Icons.circle)
        //             : const Icon(Icons.circle_outlined)),
        //     content: buildEighthStage()),
      ];

  void call() async {
    await signupController.callMasterApi();
    await signupController.getBloodGroup();
    await signupController.getState();
    await signupController.getDlTypeList();
    await signupController.getDlVehicleTypeList();
    await signupController.getVehicleTypeList();
    signupController.getBusinessList();
    signupController.getCity();
    signupController.getDepartmentList();
    signupController.getDepartmentStateList();
    signupController.getBusinessUnitList();
    if (signupController.bankList.isEmpty) {
      signupController.getBank();
    }
    signupController.clearValues();

    signupController.getdriverdata();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      signupController.signupSteeperCurrentPage.value = 0;
      signupController.bankList.clear();
      call();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("signupController.isSignupFromEditable.value ${signupController.isSignupFromEditable.value}");
    return Scaffold(
      body: PopScope(
        canPop: false,
        /*onPopInvoked: (didPop) async {
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
                              child: const Text('cancel')),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange.shade500),
                              onPressed: () {
                                // Get.offAll(LoginPage());
                                exit(0);
                              },
                              child: const Text('exit')),
                        ],
                      ),
                    ));
            return;
          }
        },*/
        child: SingleChildScrollView(
          child: Column(
            children: [
              NumberStepper(
                totalSteps: stepsList().length,
                width: MediaQuery.of(context).size.width,
                curStep: signupController.signupSteeperCurrentPage.value,
                stepCompleteColor: Colors.deepOrange,
                currentStepColor: Colors.transparent,
                inactiveColor: Colors.grey.shade200,
                lineWidth: 2.5,
              ),
              signupController.signupSteeperCurrentPage.value == 0
                  ? buildFirstStage() /*buildFirstStage()*/
                  : signupController.signupSteeperCurrentPage.value == 1
                      ? buildSecondStage()
                      : signupController.signupSteeperCurrentPage.value == 2
                          ? buildThirdStage()
                          : signupController.signupSteeperCurrentPage.value == 3
                              ? buildFourthStage()
                              : signupController
                                          .signupSteeperCurrentPage.value ==
                                      4
                                  ? buildFifthStage()
                                  : signupController
                                              .signupSteeperCurrentPage.value ==
                                          5
                                      ? buildSixthStage() : buildSixthStage()
                                      // : signupController
                                      //             .signupSteeperCurrentPage
                                      //             .value ==
                                      //         6
                                      //     ? buildSeventhStage()
                                      //     : signupController
                                      //                 .signupSteeperCurrentPage
                                      //                 .value ==
                                      //             7
                                      //         ? buildEighthStage()
                                      //         : buildEighthStage(),
            ],
          ),
        ),
      ),
    );
  }

  showRemark() {
    return Column(
      children: [
        if (signupController.driverDetailModel != null &&
            signupController.driverDetailModel!.remarks != null) ...[
          const SizedBox(height: 30),
          Text(
            "Remark : ${signupController.driverDetailModel!.remarks} ",
            style: const TextStyle(
                fontSize: 16, color: Colors.red, fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }

  buildFirstStage() {
    return Obx(() {
      return signupController.masterList.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.deepOrange.shade500,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please wait while form is loading",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height:
                signupController.driverDetailModel != null &&
                    signupController.driverDetailModel!.remarks != null ? MediaQuery.of(context).size.height * 1.44 :
                MediaQuery.of(context).size.height * 1.38,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.18,
                      decoration: const BoxDecoration(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/abhi_logo.png",
                            height: MediaQuery.sizeOf(context).height * 0.08,
                            width: MediaQuery.sizeOf(context).width,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      child: Container(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                signupController
                                            .signupSteeperCurrentPage.value ==
                                        0
                                    ? Get.offAll(const SelectOnboarding())
                                    : Get.offAll(const SelectOnboarding());
                              });
                            },
                            icon: const Icon(Icons.arrow_back)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.sizeOf(context).height * 0.13,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.sizeOf(context).width * 0.04,
                            vertical:
                                MediaQuery.sizeOf(context).height * 0.015),
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.sizeOf(context).width * 0.03),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFFEFE6),
                            borderRadius: BorderRadius.circular(12)),
                        width: MediaQuery.sizeOf(context).width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: const Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Fill Basic Details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 25),
                                    ),
                                    SizedBox(height: 5),
                                    Text("Create your Account",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black45)),
                                  ],
                                ),
                              ),
                              //Remark
                              showRemark(),
                              const SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Personal information",
                                    style: TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 2.5),
                                  Divider(
                                    color: Color(0xffFF9B55),
                                    thickness: 1,
                                  ),
                                  const SizedBox(height: 2.5),
                                 IgnorePointer(
                                   ignoring:  signupController.isSignupFromEditable.value,
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                     RichText(
                                       text: const TextSpan(
                                         children: [
                                           TextSpan(
                                             text: 'First Name',
                                             style: TextStyle(
                                                 fontSize: 13,
                                                 overflow: TextOverflow.ellipsis,
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500),
                                           ),
                                           TextSpan(
                                             text: '*',
                                             style: TextStyle(
                                                 color: Colors.red, fontSize: 15),
                                           ),
                                         ],
                                       ),
                                     ),
                                     const SizedBox(height: 15),
                                     TextFormField(
                                       style: const TextStyle(
                                           fontSize: 13,
                                           overflow: TextOverflow.ellipsis,
                                           color: Colors.black,
                                           fontWeight: FontWeight.w500),
                                       focusNode: signupController
                                           .fristnameFocusNode.value,
                                       controller:
                                       signupController.fristname.value,
                                       inputFormatters: [
                                         FilteringTextInputFormatter.allow(
                                             RegExp(r'[a-zA-Z ]')),
                                       ],
                                       textAlignVertical: TextAlignVertical.center,
                                       decoration: InputDecoration(
                                         contentPadding:
                                         const EdgeInsets.symmetric(
                                             horizontal: 8),
                                         hintText: 'First Name',
                                         hintStyle: const TextStyle(
                                             color: Colors.black45, fontSize: 14),
                                         filled: true,
                                         fillColor: Colors.white,
                                         border: OutlineInputBorder(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             borderSide: const BorderSide(
                                                 color: Color(0xFFFFC59D),
                                                 width: 1)),
                                         focusedBorder: OutlineInputBorder(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             borderSide: const BorderSide(
                                                 color: Color(0xFFFFC59D),
                                                 width: 1)),
                                         enabledBorder: OutlineInputBorder(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             borderSide: const BorderSide(
                                                 color: Color(0xFFFFC59D),
                                                 width: 1)),
                                       ),
                                     ),
                                     const SizedBox(height: 15),
                                     RichText(
                                       text: const TextSpan(
                                         children: [
                                           TextSpan(
                                             text: 'Middle Name',
                                             style: TextStyle(
                                                 fontSize: 13,
                                                 overflow: TextOverflow.ellipsis,
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500),
                                           ),
                                           // TextSpan(
                                           //   text: '*',
                                           //   style: TextStyle(
                                           //       color: Colors.red, fontSize: 15),
                                           // ),
                                         ],
                                       ),
                                     ),
                                     const SizedBox(height: 5),
                                     TextFormField(
                                       style: const TextStyle(
                                           fontSize: 13,
                                           overflow: TextOverflow.ellipsis,
                                           color: Colors.black,
                                           fontWeight: FontWeight.w500),
                                       focusNode: signupController
                                           .middlenameFocusNode.value,
                                       controller:
                                       signupController.middlename.value,
                                       inputFormatters: [
                                         FilteringTextInputFormatter.allow(
                                             RegExp(r'[a-zA-Z ]')),
                                       ],
                                       textAlignVertical: TextAlignVertical.center,
                                       decoration: InputDecoration(
                                         contentPadding:
                                         const EdgeInsets.symmetric(
                                             horizontal: 8),
                                         hintText: 'Middle Name',
                                         hintStyle: const TextStyle(
                                             color: Colors.black45, fontSize: 14),
                                         filled: true,
                                         fillColor: Colors.white,
                                         border: OutlineInputBorder(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             borderSide: const BorderSide(
                                                 color: Color(0xFFFFC59D),
                                                 width: 1)),
                                         focusedBorder: OutlineInputBorder(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             borderSide: const BorderSide(
                                                 color: Color(0xFFFFC59D),
                                                 width: 1)),
                                         enabledBorder: OutlineInputBorder(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             borderSide: const BorderSide(
                                                 color: Color(0xFFFFC59D),
                                                 width: 1)),
                                       ),
                                     ),
                                     const SizedBox(height: 15),
                                     RichText(
                                       text: const TextSpan(
                                         children: [
                                           TextSpan(
                                             text: 'Last Name',
                                             style: TextStyle(
                                                 fontSize: 13,
                                                 overflow: TextOverflow.ellipsis,
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500),
                                           ),
                                           TextSpan(
                                             text: '*',
                                             style: TextStyle(
                                                 color: Colors.red, fontSize: 15),
                                           ),
                                         ],
                                       ),
                                     ),
                                     const SizedBox(height: 5),
                                     TextFormField(
                                       style: const TextStyle(
                                           fontSize: 13,
                                           overflow: TextOverflow.ellipsis,
                                           color: Colors.black,
                                           fontWeight: FontWeight.w500),
                                       focusNode: signupController
                                           .lastnameFocusNode.value,
                                       controller: signupController.lastname.value,
                                       inputFormatters: [
                                         FilteringTextInputFormatter.allow(
                                             RegExp(r'[a-zA-Z ]')),
                                       ],
                                       textAlignVertical: TextAlignVertical.center,
                                       decoration: InputDecoration(
                                         contentPadding:
                                         const EdgeInsets.symmetric(
                                             horizontal: 8),
                                         hintText: 'Last Name',
                                         hintStyle: const TextStyle(
                                             color: Colors.black45, fontSize: 14),
                                         filled: true,
                                         fillColor: Colors.white,
                                         border: OutlineInputBorder(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             borderSide: const BorderSide(
                                                 color: Color(0xFFFFC59D),
                                                 width: 1)),
                                         focusedBorder: OutlineInputBorder(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             borderSide: const BorderSide(
                                                 color: Color(0xFFFFC59D),
                                                 width: 1)),
                                         enabledBorder: OutlineInputBorder(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             borderSide: const BorderSide(
                                                 color: Color(0xFFFFC59D),
                                                 width: 1)),
                                       ),
                                     ),
                                         const SizedBox(height: 15),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           RichText(
                                             text: const TextSpan(
                                               children: [
                                                 TextSpan(
                                                   text: 'Email',
                                                   style: TextStyle(
                                                       fontSize: 13,
                                                       overflow: TextOverflow.ellipsis,
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w500),
                                                 ),
                                                 TextSpan(
                                                   text: '*',
                                                   style: TextStyle(
                                                       color: Colors.red, fontSize: 15),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           const SizedBox(height: 5),
                                           TextFormField(
                                             style: const TextStyle(
                                                 fontSize: 13,
                                                 overflow: TextOverflow.ellipsis,
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500),
                                             focusNode: signupController
                                                 .userEmailFocusNode.value,
                                             controller:
                                             signupController.userEmail.value,
                                             keyboardType: TextInputType.emailAddress,
                                             textAlignVertical: TextAlignVertical.center,
                                             autovalidateMode:
                                             AutovalidateMode.onUserInteraction,
                                             onEditingComplete: () {
                                               _validateEmail(signupController
                                                   .userEmail.value.text);
                                               // if(value.trim().isNotEmpty){
                                               //   Future.delayed(const Duration(seconds: 3),() {
                                               //     _validateEmail(value);
                                               //   },);
                                               // }
                                             },
                                             // onChanged: (value) {
                                             //   if (value.trim().isNotEmpty) {
                                             //     // Cancel the previous timer if still running
                                             //     _emailValidationTimer?.cancel();
                                             //
                                             //     // Start a new timer
                                             //     _emailValidationTimer = Timer(const Duration(seconds: 2), () {
                                             //       _validateEmail(value);
                                             //     });
                                             //   }
                                             //
                                             //   // if(value.trim().isNotEmpty){
                                             //   //   Future.delayed(const Duration(seconds: 3),() {
                                             //   //     _validateEmail(value);
                                             //   //   },);
                                             //   // }
                                             // },
                                             decoration: InputDecoration(
                                               hintText: 'Email',
                                               hintStyle: const TextStyle(
                                                   color: Colors.black45, fontSize: 14),
                                               contentPadding:
                                               const EdgeInsets.symmetric(
                                                   horizontal: 8),
                                               filled: true,
                                               fillColor: Colors.white,
                                               border: OutlineInputBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(10),
                                                   borderSide: const BorderSide(
                                                       color: Color(0xFFFFC59D),
                                                       width: 1)),
                                               focusedBorder: OutlineInputBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(10),
                                                   borderSide: const BorderSide(
                                                       color: Color(0xFFFFC59D),
                                                       width: 1)),
                                               errorBorder: OutlineInputBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(10),
                                                   borderSide: const BorderSide(
                                                       color: Color(0xFFFFC59D),
                                                       width: 1)),
                                               focusedErrorBorder: OutlineInputBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(10),
                                                   borderSide: const BorderSide(
                                                       color: Color(0xFFFFC59D),
                                                       width: 1)),
                                               enabledBorder: OutlineInputBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(10),
                                                   borderSide: const BorderSide(
                                                       color: Color(0xFFFFC59D),
                                                       width: 1)),
                                             ),
                                           ),
                                         ],
                                       ),
                                       const SizedBox(height: 15),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           RichText(
                                             text: const TextSpan(
                                               children: [
                                                 TextSpan(
                                                   text: 'Contact Number',
                                                   style: TextStyle(
                                                       fontSize: 13,
                                                       overflow: TextOverflow.ellipsis,
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w500),
                                                 ),
                                                 TextSpan(
                                                   text: '*',
                                                   style: TextStyle(
                                                       color: Colors.red, fontSize: 15),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           const SizedBox(height: 5),
                                           TextFormField(
                                             maxLength: 10,
                                             controller: signupController
                                                 .signupMobileNumber.value,
                                             focusNode: signupController
                                                 .ContactNumberFocusNode.value,
                                             onChanged: (value) {
                                               if (value.length == 10) {
                                                 signupController
                                                     .ContactNumberFocusNode.value
                                                     .unfocus();
                                               }
                                             },
                                             readOnly: true,
                                             keyboardType: TextInputType.number,
                                             style: const TextStyle(
                                                 fontSize: 13,
                                                 overflow: TextOverflow.ellipsis,
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500),
                                             textAlignVertical: TextAlignVertical.center,
                                             decoration: InputDecoration(
                                               contentPadding:
                                               EdgeInsets.symmetric(horizontal: 8),
                                               hintText: 'Contact Number',
                                               counterText: "",
                                               filled: true,
                                               hintStyle: TextStyle(
                                                   color: Colors.black45, fontSize: 14),
                                               fillColor: Colors.white,
                                               border: OutlineInputBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(10),
                                                   borderSide: const BorderSide(
                                                       color: Color(0xFFFFC59D),
                                                       width: 1)),
                                               focusedBorder: OutlineInputBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(10),
                                                   borderSide: const BorderSide(
                                                       color: Color(0xFFFFC59D),
                                                       width: 1)),
                                               enabledBorder: OutlineInputBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(10),
                                                   borderSide: BorderSide(
                                                       color: Color(0xFFFFC59D),
                                                       width: 1)),
                                             ),
                                           ),
                                           const SizedBox(height: 15),
                                           RichText(
                                             text: const TextSpan(
                                               children: [
                                                 TextSpan(
                                                   text: 'Alternate Contact Number',
                                                   style: TextStyle(
                                                       fontSize: 13,
                                                       overflow: TextOverflow.ellipsis,
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w500),
                                                 ),
                                                 TextSpan(
                                                   text: '*',
                                                   style: TextStyle(
                                                       color: Colors.red, fontSize: 15),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           const SizedBox(height: 5),
                                           TextFormField(
                                             maxLength: 10,
                                             controller: signupController
                                                 .alternateContactNumber.value,
                                             focusNode: signupController
                                                 .alternateContactNumberFocusNode.value,
                                             onChanged: (value) {
                                               if (value.length == 10) {
                                                 signupController
                                                     .alternateContactNumberFocusNode
                                                     .value
                                                     .unfocus();
                                               }
                                             },
                                             keyboardType: TextInputType.number,
                                             style: const TextStyle(
                                                 fontSize: 13,
                                                 overflow: TextOverflow.ellipsis,
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500),
                                             textAlignVertical: TextAlignVertical.center,
                                             decoration: InputDecoration(
                                               contentPadding:
                                               EdgeInsets.symmetric(horizontal: 8),
                                               hintText: 'Alternate Contact Number',
                                               counterText: "",
                                               filled: true,
                                               hintStyle: TextStyle(
                                                   color: Colors.black45, fontSize: 14),
                                               fillColor: Colors.white,
                                               border: OutlineInputBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(10),
                                                   borderSide: const BorderSide(
                                                       color: Color(0xFFFFC59D),
                                                       width: 1)),
                                               focusedBorder: OutlineInputBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(10),
                                                   borderSide: const BorderSide(
                                                       color: Color(0xFFFFC59D),
                                                       width: 1)),
                                               enabledBorder: OutlineInputBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(10),
                                                   borderSide: BorderSide(
                                                       color: Color(0xFFFFC59D),
                                                       width: 1)),
                                             ),
                                           ),
                                         ],
                                       ),
                                       const SizedBox(height: 15),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           RichText(
                                             text: const TextSpan(
                                               children: [
                                                 TextSpan(
                                                   text: 'Date of Birth',
                                                   style: TextStyle(
                                                       fontSize: 13,
                                                       overflow: TextOverflow.ellipsis,
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w500),
                                                 ),
                                                 TextSpan(
                                                   text: '*',
                                                   style: TextStyle(
                                                       color: Colors.red, fontSize: 15),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           const SizedBox(height: 5),
                                           TextFormField(
                                               style: const TextStyle(
                                                   fontSize: 13,
                                                   overflow: TextOverflow.ellipsis,
                                                   color: Colors.black,
                                                   fontWeight: FontWeight.w500),
                                               controller:
                                               signupController.userDob.value,
                                               focusNode: signupController
                                                   .userDobFocusNode.value,
                                               keyboardType: TextInputType.none,
                                               textAlignVertical:
                                               TextAlignVertical.center,
                                               decoration: InputDecoration(
                                                 hintText: 'Date of Birth',
                                                 hintStyle: const TextStyle(
                                                     color: Colors.black45,
                                                     fontSize: 14),
                                                 contentPadding:
                                                 const EdgeInsets.symmetric(
                                                     horizontal: 8),
                                                 filled: true,
                                                 fillColor: Colors.white,
                                                 border: OutlineInputBorder(
                                                     borderRadius:
                                                     BorderRadius.circular(10),
                                                     borderSide: const BorderSide(
                                                         color: Color(0xFFFFC59D),
                                                         width: 1)),
                                                 focusedBorder: OutlineInputBorder(
                                                     borderRadius:
                                                     BorderRadius.circular(10),
                                                     borderSide: const BorderSide(
                                                         color: Color(0xFFFFC59D),
                                                         width: 1)),
                                                 enabledBorder: OutlineInputBorder(
                                                     borderRadius:
                                                     BorderRadius.circular(10),
                                                     borderSide: const BorderSide(
                                                         color: Color(0xFFFFC59D),
                                                         width: 1)),
                                                 suffixIcon: Icon(
                                                   Icons.calendar_month,
                                                   color: Colors.deepOrange.shade500,
                                                 ),
                                               ),
                                               onTap: () async {
                                                 DateTime displayYear = DateTime.now();
                                                 int showYear = displayYear.year;
                                                 final selectedDate =
                                                 await showDatePicker(
                                                   context: context,
                                                   initialEntryMode: DatePickerEntryMode.calendarOnly,
                                                   locale: const Locale('en',
                                                       'GB'), // Ensures dd/MM/yyyy format in the calendar

                                                   initialDate: DateTime.now(),
                                                   firstDate: DateTime(1965),
                                                   lastDate: DateTime.now(),
                                                   builder: (context, child) {
                                                     return Theme(
                                                       data: Theme.of(context).copyWith(
                                                         colorScheme:
                                                         const ColorScheme.light(
                                                           primary: Colors.orangeAccent,
                                                           onPrimary: Colors.white,
                                                           onSurface: Colors.black,
                                                         ),
                                                         textButtonTheme:
                                                         TextButtonThemeData(
                                                           style: TextButton.styleFrom(
                                                             foregroundColor:
                                                             Colors.black45,
                                                           ),
                                                         ),
                                                       ),
                                                       child: child!,
                                                     );
                                                   },
                                                 );
                                                 if (selectedDate != null) {
                                                   final today = DateTime.now();

                                                   final displayDate =
                                                   DateFormat('dd/MM/yyyy')
                                                       .format(selectedDate);

                                                   // Format for API (yyyy-mm-dd)
                                                   final apiDate =
                                                   DateFormat('yyyy-MM-dd')
                                                       .format(selectedDate);
                                                   int age =
                                                       today.year - selectedDate.year;
                                                   if (today.month <
                                                       selectedDate.month ||
                                                       (today.month ==
                                                           selectedDate.month &&
                                                           today.day <
                                                               selectedDate.day)) {
                                                     age--;
                                                   }

                                                   if (age < 18) {
                                                     MyToast.myShowToast(
                                                         'You must be at least 18 years old');
                                                     signupController.userDob.value
                                                         .clear();
                                                   } else {
                                                     signupController.userDob.value
                                                         .text = displayDate;
                                                     signupController
                                                         .userDobDateApiFormat
                                                         .value
                                                         .text = apiDate;
                                                   }
                                                 }
                                               }),
                                         ],
                                       ),
                                       const SizedBox(height: 15),
                                       Column(
                                         mainAxisAlignment:
                                         MainAxisAlignment.spaceBetween,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           RichText(
                                             text: const TextSpan(
                                               children: [
                                                 TextSpan(
                                                   text: 'Gender',
                                                   style: TextStyle(
                                                       fontSize: 13,
                                                       overflow: TextOverflow.ellipsis,
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w500),
                                                 ),
                                                 TextSpan(
                                                   text: '*',
                                                   style: TextStyle(
                                                       color: Colors.red, fontSize: 15),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           const SizedBox(height: 7),
                                           Container(
                                               width: MediaQuery.sizeOf(context).width,
                                               padding: const EdgeInsets.only(
                                                   left: 10, right: 10),
                                               decoration: BoxDecoration(
                                                 color: Colors.white,
                                                 border: Border.all(
                                                   color: const Color(0xFFFFC59D),
                                                 ),
                                                 borderRadius: BorderRadius.circular(10),
                                               ),
                                               child: DropdownButton(
                                                   padding: EdgeInsets.zero,
                                                   focusNode: signupController
                                                       .userGenderFocusNode.value,
                                                   isExpanded: true,
                                                   underline: Container(),
                                                   value:
                                                   signupController.userGender.value,
                                                   items: [
                                                     "Select Gender",
                                                     "Male",
                                                     "Female",
                                                     "Others"
                                                   ].map((items) {
                                                     return DropdownMenuItem(
                                                         value: items,
                                                         child: Text(
                                                           items,
                                                           style: const TextStyle(
                                                               fontSize: 13,
                                                               overflow:
                                                               TextOverflow.ellipsis,
                                                               color: Color(0xff7A7A7A),
                                                               fontWeight:
                                                               FontWeight.w500),
                                                         ));
                                                   }).toList(),
                                                   onChanged: (selected) {
                                                     signupController.userGender.value =
                                                     selected!;
                                                   })),
                                         ],
                                       ),
                                       const SizedBox(height: 15),
                                       RichText(
                                         text: const TextSpan(
                                           children: [
                                             TextSpan(
                                               text: 'Blood Group',
                                               style: TextStyle(
                                                   fontSize: 13,
                                                   overflow:
                                                   TextOverflow.ellipsis,
                                                   color: Colors.black,
                                                   fontWeight: FontWeight.w500),
                                             ),
                                             TextSpan(
                                               text: '*',
                                               style: TextStyle(
                                                   color: Colors.red,
                                                   fontSize: 15),
                                             ),
                                           ],
                                         ),
                                       ),
                                       Container(
                                         padding: const EdgeInsets.only(left: 7),
                                         decoration: BoxDecoration(
                                             border: Border.all(
                                                 color: Color(0xffFFC59D)),
                                             color: Colors.white,
                                             borderRadius:
                                             BorderRadius.circular(10)),
                                         child: Obx(() =>
                                             DropdownButton<BloodType>(
                                               value:
                                               signupController
                                                   .selectedBloodGroupList.isNotEmpty ?
                                               signupController
                                                   .selectedBloodGroupList
                                                   .firstWhere(
                                                     (element) =>
                                                 element.name ==
                                                     signupController
                                                         .selectedBloodGroup
                                                         .value,
                                                 orElse: () => signupController
                                                     .selectedBloodGroupList
                                                     .first,
                                               ) : null,
                                               isExpanded: true,
                                               underline: Container(),
                                               onChanged: (selected) {
                                                 signupController
                                                     .selectedBloodGroup
                                                     .value = selected!.name;
                                                 if (selected.name !=
                                                     "Select Blood Group") {
                                                   signupController
                                                       .selectedBloodGroupId
                                                       .value =
                                                       selected.value.toString();
                                                 } else {
                                                   signupController
                                                       .selectedBloodGroupId
                                                       .value = "";
                                                 }
                                                 print(
                                                     " signupController.selectedBloodGroupId.value ${signupController.selectedBloodGroupId.value}");
                                               },
                                               items: signupController
                                                   .selectedBloodGroupList
                                                   .map((items) {
                                                 return DropdownMenuItem<
                                                     BloodType>(
                                                   value: items,
                                                   child: Text(items.name,
                                                       style: const TextStyle(
                                                           fontSize: 13,
                                                           overflow: TextOverflow
                                                               .ellipsis,
                                                           color:
                                                           Color(0xff7A7A7A),
                                                           fontWeight:
                                                           FontWeight.w500)),
                                                 );
                                               }).toList(),
                                             )),
                                       ),
                                   ],
                                   ),
                                 ),
                                 ],
                                 ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      bool validate = validateFirstStep();
                                      if (validate) {
                                        debugPrint("Validated 1");
                                        setState(() {
                                          signupController
                                              .signupSteeperCurrentPage
                                              .value = 1;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.065,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFF9B55),
                                              Color(0xFFE15D29)
                                            ],
                                            begin: Alignment.topCenter,
                                            stops: [
                                              0.4,
                                              30.0,
                                            ],
                                            end: Alignment.bottomCenter),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Next",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    )
                    // const SizedBox(height:15),
                  ],
                ),
              ),
            );
    });
  } // 1

  void _validateEmail(String email) {
    RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(email.trim())) {
      MyToast.myShowToast("Please enter a valid Email Address");
    }
    // Future.delayed(const Duration(seconds: 1),() {
    //   if (!emailRegExp.hasMatch(email.trim())) {
    //     MyToast.myShowToast("Please enter a valid Email Address");
    //   }
    // },);
  }

  void _validateDLNumber() {
    RegExp reg = RegExp(
        r"^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}" +
            r"|([a-zA-Z]{2}[0-9]{2}[\\/][a-zA-Z]{3}[\\/][0-9]{2}[\\/][0-9]{5})" +
            r"|([a-zA-Z]{2}[0-9]{2}(N)[\\-]{1}((19|20)[0-9][0-9])[\\-][0-9]{7})" +
            r"|([a-zA-Z]{2}[0-9]{14})" +
            r"|([a-zA-Z]{2}[\\-][0-9]{13})$");
    if (!reg.hasMatch(
        signupController.userDLNumber.value.text.trim().toUpperCase())) {
      MyToast.myShowToast("Invalid Driving License Number");
    }
    // Future.delayed(const Duration(seconds: 1),() {
    //   if (!reg.hasMatch(
    //       signupController.userDLNumber.value.text.trim().toUpperCase())) {
    //     MyToast.myShowToast("Invalid Driving License Number");
    //   }
    // },);
  }

  bool validateFirstStep() {
    if (signupController.fristname.value.text.isEmpty ||
        signupController.fristname.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please enter First Name");
      signupController.usernameFocusNode.value.requestFocus();
      return false;
    }
    // if (signupController.middlename.value.text.isEmpty ||
    //     signupController.middlename.value.text.trim().isEmpty) {
    //   MyToast.myShowToast("Middlename can't be empty");
    //   signupController.usernameFocusNode.value.requestFocus();
    //   return false;
    // }
    if (signupController.lastname.value.text.isEmpty ||
        signupController.lastname.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please enter Last Name");
      signupController.usernameFocusNode.value.requestFocus();
      return false;
    }
    if (signupController.userEmail.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please enter Email");
      signupController.userEmailFocusNode.value.requestFocus();
      return false;
    }
    if (signupController.userEmail.value.text.isNotEmpty) {
      RegExp emailRegExp =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegExp.hasMatch(signupController.userEmail.value.text.trim())) {
        MyToast.myShowToast("Please enter a valid Email Address");
        signupController.userEmail.value.clear();
        signupController.userEmailFocusNode.value.requestFocus();
        return false;
      }
    }
    if (signupController.signupMobileNumber.value.text.trim().isEmpty ||
        !signupController.signupMobileNumber.value.text.isNumericOnly ||
        signupController.signupMobileNumber.value.text.length != 10) {
      MyToast.myShowToast("Please enter Contact Number");
      return false;
    }
    if (signupController.alternateContactNumber.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please enter Alternate Contact Number");
      return false;
    }
    if (!signupController.alternateContactNumber.value.text.isNumericOnly) {
      MyToast.myShowToast("Please enter valid Alternate Contact Number");
      return false;
    }
    if (signupController.alternateContactNumber.value.text.length != 10) {
      MyToast.myShowToast("Alternate Contact Number must be 10 digit");
      return false;
    }
    if (signupController.userDob.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please enter Date Of Birth");
      signupController.userDobFocusNode.value.requestFocus();
      return false;
    }

    if (signupController.userGender.value.isEmpty ||
        signupController.userGender.value == "Select Gender") {
      MyToast.myShowToast("Please select Gender");
      signupController.userGenderFocusNode.value.requestFocus();
      return false;
    }

    if (signupController.selectedBloodGroup.value.isEmpty ||
        signupController.selectedBloodGroup.value == "Select Blood Group") {
      MyToast.myShowToast("Please select Blood Group");
      return false;
    }

    return true;
  }

  /// Second  Stage

  buildSecondStage() {
    return Obx(() {
      return signupController.masterList.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.deepOrange.shade500,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please wait while form is loading",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  height: signupController.driverDetailModel != null &&
                          signupController.driverDetailModel!.remarks != null
                      ? MediaQuery.of(context).size.height * 1.1
                      : MediaQuery.of(context).size.height * 1.03,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Stack(children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.18,
                      decoration: const BoxDecoration(
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
                            Image.asset(
                              "assets/images/abhi_logo.png",
                              height: MediaQuery.sizeOf(context).height * 0.08,
                              width: MediaQuery.sizeOf(context).width,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                signupController
                                    .signupSteeperCurrentPage.value = 0;
                              });
                            },
                            icon: const Icon(Icons.arrow_back)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.sizeOf(context).height * 0.13,
                      left: 0,
                      right: 0,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.sizeOf(context).width * 0.04,
                              vertical:
                                  MediaQuery.sizeOf(context).height * 0.015),
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.sizeOf(context).width * 0.03),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFEFE6),
                              borderRadius: BorderRadius.circular(12)),
                          width: MediaQuery.sizeOf(context).width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Fill Basic Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                        SizedBox(height: 5),
                                        Text("Create your Account",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black45)),
                                      ],
                                    ),
                                  ),
                                  //Remark
                                  showRemark(),
                                  const SizedBox(height: 30),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Address Details",
                                        style: TextStyle(
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 2.5),
                                      Divider(
                                        color: Color(0xffFF9B55),
                                        thickness: 1,
                                      ),
                                      const SizedBox(height: 2.5),
                                      IgnorePointer(
                                          ignoring:  signupController.isSignupFromEditable.value,
                                        child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // address
                                            RichText(
                                              text: const TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Current Address',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            TextFormField(
                                              maxLines: 3,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                              focusNode: signupController
                                                  .userCurrentAddressFocusNode.value,
                                              controller: signupController
                                                  .userCurrentAddress.value,
                                              textAlignVertical:
                                              TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                hintText: 'Address',
                                                hintStyle: const TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 14),
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 10),
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.sizeOf(context)
                                                      .width *
                                                      0.06,
                                                  child: Obx(() => Checkbox(
                                                      value: signupController
                                                          .useCurrentAddressAsPermanentAddress
                                                          .value,
                                                      shape:
                                                      const RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: Color(0xFFFFC59D),
                                                          )),
                                                      side: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                      ),
                                                      fillColor:
                                                      const MaterialStatePropertyAll(
                                                          Colors.white),
                                                      checkColor:
                                                      const Color(0xFFFFC59D),
                                                      activeColor:
                                                      Colors.deepOrange.shade500,
                                                      onChanged: (value) {
                                                        signupController
                                                            .useCurrentAddressAsPermanentAddress
                                                            .value = value!;
                                                        if (signupController
                                                            .useCurrentAddressAsPermanentAddress
                                                            .value) {
                                                          signupController
                                                              .userPermanentAddress
                                                              .value
                                                              .text =
                                                              signupController
                                                                  .userCurrentAddress
                                                                  .value
                                                                  .text;
                                                        } else {
                                                          signupController
                                                              .userPermanentAddress
                                                              .value
                                                              .clear();
                                                        }
                                                      })),
                                                ),
                                                const Text(
                                                    "Permanent Address same as  above",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        color: Colors.black45,
                                                        fontWeight: FontWeight.w500))
                                              ],
                                            ),
                                            // parmanent address
                                            const SizedBox(height: 10),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: const TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Permanent Address (As Per Aadhar)',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                      ),
                                                      TextSpan(
                                                        text: '*',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                TextFormField(
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      overflow: TextOverflow.ellipsis,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500),
                                                  focusNode: signupController
                                                      .userPermanentAddressFocusNode
                                                      .value,
                                                  controller: signupController
                                                      .userPermanentAddress.value,
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                    hintText: 'Address',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 14),
                                                    contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 10),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                        borderSide: const BorderSide(
                                                            color: Color(0xFFFFC59D),
                                                            width: 1)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                        borderSide: const BorderSide(
                                                            color: Color(0xFFFFC59D),
                                                            width: 1)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                        borderSide: const BorderSide(
                                                            color: Color(0xFFFFC59D),
                                                            width: 1)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            RichText(
                                              text: const TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Hub Pincode',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            SizedBox(
                                              width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.815,
                                              height:
                                              MediaQuery.sizeOf(context).height *
                                                  0.06,
                                              child: TextFormField(
                                                focusNode: signupController
                                                    .userPinCodeFocusNode.value,
                                                controller: signupController
                                                    .userPinCode.value,
                                                maxLength: 6,
                                                maxLines: 1,
                                                onChanged: (value) async {
                                                  if (value.trim().length == 6) {
                                                    await signupController
                                                        .callGetDetailsByPinCodeDetailsApi(
                                                        value);
                                                  }
                                                },
                                                keyboardType: TextInputType.number,
                                                onFieldSubmitted: (value) async {
                                                  await signupController
                                                      .callGetDetailsByPinCodeDetailsApi(
                                                      value);
                                                  // callPinCodeApi(value);
                                                },
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500),
                                                textAlignVertical:
                                                TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                  hintText: 'Pincode',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14),
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  counterText: "",
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 15),
                                            RichText(
                                              text: const TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'State',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            TextFormField(
                                              readOnly: true,
                                              focusNode: signupController
                                                  .userStateFocusNode.value,
                                              controller: signupController
                                                  .userStateController.value,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                              textAlignVertical:
                                              TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                hintText: 'State',
                                                hintStyle: const TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 14),
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            RichText(
                                              text: const TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'City',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            TextFormField(
                                              readOnly: true,
                                              focusNode: signupController
                                                  .userCityFocusNode.value,
                                              controller: signupController
                                                  .userCityController.value,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                              textAlignVertical:
                                              TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                hintText: 'City',
                                                hintStyle: const TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 14),
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                              ),
                                            ),
                                        ],
                                        ),
                                      ),


                                      ///State and City Dropdown
                                      /* Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton2(
                            focusNode: signupController.userCityFocusNode.value,
                            underline: Container(),
                            isExpanded: true,
                            value: signupController.stateList.isEmpty
                                ? "Select State"
                                : signupController.userCity.value,
                            onChanged: (selected) {
                              signupController.userCity.value = selected!;
                              setState(() {});
                            },
                            items: signupController.cityList
                                .toSet()
                                .toList()
                                .map((items) {
                              return DropdownMenuItem(
                                  value: items,
                                  child: Text(items,
                                      style: TextStyle(color: Colors.black45)));
                            }).toList(),
                            dropdownSearchData: DropdownSearchData(
                                searchController: citySearchController,
                                searchInnerWidgetHeight: 50,
                                searchInnerWidget: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.deepOrange.shade500),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: TextFormField(
                                    controller: stateSearchController,
                                     textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),

                                        hintText: 'Search',
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black45)),
                                        suffixIcon: Icon(
                                          Icons.search,
                                          color: Colors.deepOrange.shade500,
                                          size: 30,
                                        )),
                                  ),
                                )),
                            onMenuStateChange: ((isOpen) {
                              citySearchController.clear();
                              setState(() {});
                            }),
                          ),
                                                ),
                                                 Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton2(
                            focusNode:
                                signupController.userStateFocusNode.value,
                            isExpanded: true,
                            dropdownSearchData: DropdownSearchData(
                                searchController: stateSearchController,
                                searchInnerWidgetHeight: 50,
                                searchInnerWidget: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.deepOrange.shade500),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: TextFormField(
                                    controller: stateSearchController,
                                     textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),

                                        hintText: 'Search',
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black45)),
                                        suffixIcon: Icon(
                                          Icons.search,
                                          color: Colors.deepOrange.shade500,
                                          size: 30,
                                        )),
                                  ),
                                )),
                            onMenuStateChange: ((isOpen) {
                              stateSearchController.clear();
                              setState(() {});
                            }),
                            value: signupController.userState.value,
                            underline: Container(),
                            onChanged: (selected) {
                              signupController.userState.value = selected!;
                              signupController.cityList.clear();
                              var temp = <MasterResponse>[];
                              temp.add(signupController.masterList.firstWhere(
                                  (element) => element.mName == selected));
                              signupController.stateId.value = temp[0].mID;
                              signupController.getCity();
                              signupController.userCity.value = "Select City";
                              setState(() {});
                            },
                            items: signupController.stateList
                                .toSet()
                                .toList()
                                .map((item) {
                              return DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style:
                                        const TextStyle(color: Colors.black45),
                                  ));
                            }).toList(),
                            iconStyleData: const IconStyleData(
                                icon: Icon(
                              Icons.arrow_drop_down,
                            )),
                          ),
                                                ),*/
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              bool validate =
                                                  validateSecondStep();
                                              if (validate) {
                                                debugPrint("Validated 2");
                                                setState(() {
                                                  signupController
                                                      .signupSteeperCurrentPage
                                                      .value = 2;
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.065,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xFFFF9B55),
                                                      Color(0xFFE15D29)
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    stops: [
                                                      0.4,
                                                      30.0,
                                                    ],
                                                    end:
                                                        Alignment.bottomCenter),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Next",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ]),
                          )),
                    ),
                  ])));
    });
  } // 2

  bool validateSecondStep() {
    if (signupController.userCurrentAddress.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please enter Current Address");
      signupController.userCurrentAddressFocusNode.value.requestFocus();
      return false;
    }
    if (signupController.userPermanentAddress.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please enter Permanent Address");
      signupController.userPermanentAddressFocusNode.value.requestFocus();
      return false;
    }
    if (signupController.userPinCode.value.text.trim().isEmpty ||
        !signupController.userPinCode.value.text.isNumericOnly ||
        signupController.userPinCode.value.text.length != 6) {
      MyToast.myShowToast("Please enter Pincode");
      return false;
    }
    if (signupController.userStateController.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please enter State");
      signupController.userStateFocusNode.value.requestFocus();
      return false;
    }
    if (signupController.userCityController.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please enter City");
      signupController.userCityFocusNode.value.requestFocus();
      return false;
    }

    return true;
  }

  /// third Stage

  buildThirdStage() {
    return Obx(() {
      return signupController.masterList.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.deepOrange.shade500,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please wait while form is loading",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: const BoxDecoration(
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
                        Image.asset(
                          "assets/images/abhi_logo.png",
                          height: MediaQuery.sizeOf(context).height * 0.08,
                          width: MediaQuery.sizeOf(context).width,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            signupController.signupSteeperCurrentPage.value = 1;
                          });
                        },
                        icon: const Icon(Icons.arrow_back)),
                  ),
                ),
                Positioned(
                  top: MediaQuery.sizeOf(context).height * 0.13,
                  left: 0,
                  right: 0,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * 0.04,
                          vertical: MediaQuery.sizeOf(context).height * 0.015),
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * 0.03),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFEFE6),
                          borderRadius: BorderRadius.circular(12)),
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Fill Basic Details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 25),
                                    ),
                                    SizedBox(height: 5),
                                    Text("Create your Account",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black45)),
                                  ],
                                ),
                              ),
                              showRemark(),
                              const SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Agreement",
                                    style: TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 2.5),
                                  Divider(
                                    color: Color(0xffFF9B55),
                                    thickness: 1,
                                  ),
                                  const SizedBox(height: 15),
                                  IntrinsicHeight(
                                    child: IgnorePointer(
                                      ignoring:  signupController.isSignupFromEditable.value,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.015,
                                            width:
                                                MediaQuery.sizeOf(context).width *
                                                    0.06,
                                            child: Obx(() => Checkbox(
                                                  value: signupController
                                                      .isTermsAccepted.value,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          side: BorderSide(
                                                    color: Color(0xFFFFC59D),
                                                  )),
                                                  side: const BorderSide(
                                                    color: Color(0xFFFFC59D),
                                                  ),
                                                  checkColor:
                                                      const Color(0xFFFFC59D),
                                                  activeColor: Colors.deepOrange,
                                                  fillColor:
                                                      const MaterialStatePropertyAll(
                                                          Colors.white),
                                                  focusNode: signupController
                                                      .isTermsAcceptedFocusNode
                                                      .value,
                                                  onChanged: (value) {
                                                    signupController
                                                        .isTermsAccepted
                                                        .value = value!;
                                                  },
                                                )),
                                          ),
                                          SizedBox(width: 8),
                                          const Expanded(
                                            child: Text(
                                                "I agree to the terms and conditions of the enrollment",
                                                style: TextStyle(
                                                    color: Colors.black45)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          bool validate = validateThirdStage();
                                          if (validate) {
                                            setState(() {
                                              signupController
                                                  .signupSteeperCurrentPage
                                                  .value = 3;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.065,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFFF9B55),
                                                  Color(0xFFE15D29)
                                                ],
                                                begin: Alignment.topCenter,
                                                stops: [
                                                  0.4,
                                                  30.0,
                                                ],
                                                end: Alignment.bottomCenter),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Next",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                      )),
                ),
              ]));
    });
  } // 3

  bool validateThirdStage() {
    if (!signupController.isTermsAccepted.value) {
      MyToast.myShowToast("Please accept term and condition");
      return false;
    }
    return true;
  }

  /// fourth Stage

  buildFourthStage() {
    return Obx(() {
      return signupController.masterList.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.deepOrange.shade500,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please wait while form is loading",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            )
          : Container(
              height: signupController.driverDetailModel != null &&
                      signupController.driverDetailModel!.remarks != null
                  ? MediaQuery.of(context).size.height * 1.18
                  : MediaQuery.of(context).size.height * 1.12,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: const BoxDecoration(
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
                        Image.asset(
                          "assets/images/abhi_logo.png",
                          height: MediaQuery.sizeOf(context).height * 0.08,
                          width: MediaQuery.sizeOf(context).width,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            signupController.signupSteeperCurrentPage.value = 2;
                          });
                        },
                        icon: const Icon(Icons.arrow_back)),
                  ),
                ),
                Positioned(
                  top: MediaQuery.sizeOf(context).height * 0.13,
                  left: 0,
                  right: 0,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * 0.04,
                          vertical: MediaQuery.sizeOf(context).height * 0.015),
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * 0.03),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFEFE6),
                          borderRadius: BorderRadius.circular(12)),
                      width: MediaQuery.sizeOf(context).width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Fill Basic Details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 25),
                                    ),
                                    SizedBox(height: 5),
                                    Text("Create your Account",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black45)),
                                  ],
                                ),
                              ),
                              showRemark(),
                              const SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "DL Information",
                                    style: TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 2.5),
                                  Divider(
                                    color: Color(0xffFF9B55),
                                    thickness: 1,
                                  ),
                                  /*Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Color(0xffFFC59D)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Obx(()=>
                                               DropdownButton<BloodType>(
                                            value: signupController
                                                .dlVehicleTypeList
                                                .firstWhere(
                                                  (element) =>
                                              element.name ==
                                                  signupController
                                                      .userDlVehicleType
                                                      .value,
                                              orElse: () => signupController
                                                  .dlVehicleTypeList
                                                  .first,
                                            ),
                                            isExpanded: true,
                                            underline: Container(),
                                            onChanged: (selected) {
                                              signupController.userDlVehicleType.value = selected!.name;
                                              if (selected.name !=
                                                  "Select Vehicle Type") {
                                                signupController
                                                    .userDlVehicleTypeId
                                                    .value =
                                                    selected.value.toString();
                                              } else {
                                                signupController
                                                    .userDlVehicleTypeId
                                                    .value = "";
                                              }
                                              print(
                                                  "Selected DL VehicleType Id ${signupController.userDlVehicleTypeId.value}");
                                            },
                                            items: signupController
                                                .dlVehicleTypeList
                                                .map((items) {
                                              return DropdownMenuItem<
                                                  BloodType>(
                                                value: items,
                                                child: Text(items.name,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color:
                                                        Color(0xff7A7A7A),
                                                        fontWeight:
                                                        FontWeight.w500)),
                                              );
                                            }).toList(),
                                          )
                                      )
                                      ),*/
                                  const SizedBox(height: 10),
                    IgnorePointer(
                                  ignoring:  signupController.isSignupFromEditable.value,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Do you have a Driving License
                                      RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Do you have a Driving License?',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                  color: Colors.red, fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          buildRadioTile(
                                              value: "Yes"
                                          ),
                                          SizedBox(width:12.0),
                                          buildRadioTile(
                                              value: "No"
                                          ),
                                        ],
                                      ),
                                      Obx(()=>IgnorePointer(
                                        ignoring: signupController.userHaveDrivingLicence.value == "Yes" ? false : true,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Dl type
                                            RichText(
                                              text: const TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'DL Type',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        overflow: TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red, fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 2.5),
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                decoration: BoxDecoration(
                                                  color: signupController.userHaveDrivingLicence.value == "Yes" ? Colors.white : Colors.grey.withOpacity(0.2),
                                                  border: Border.all(
                                                      color: Color(0xffFFC59D)),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: DropdownButton<BloodType>(
                                                  value: signupController.dLTypeList
                                                      .firstWhere(
                                                        (element) =>
                                                    element.name ==
                                                        signupController
                                                            .userDLType
                                                            .value,
                                                    orElse: () => signupController
                                                        .dLTypeList
                                                        .first,
                                                  ),
                                                  isExpanded: true,
                                                  underline: Container(),
                                                  onChanged: (selected) {
                                                    signupController.userDLType.value = selected!.name;
                                                    if (selected.name !=
                                                        "Select Vehicle Type") {
                                                      signupController
                                                          .userDLTypeId
                                                      =
                                                          selected.value.toString();
                                                    } else {
                                                      signupController
                                                          .userDLTypeId
                                                      = "";
                                                    }

                                                  },
                                                  items: signupController
                                                      .dLTypeList
                                                      .map((items) {
                                                    return DropdownMenuItem<
                                                        BloodType>(
                                                      value: items,
                                                      child: Text(items.name,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              color:
                                                              Color(0xff7A7A7A),
                                                              fontWeight:
                                                              FontWeight.w500)),
                                                    );
                                                  }).toList(),
                                                )
                                            ),
                                            const SizedBox(height: 10),
                                            // Dl number
                                            Obx(() => RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                    "${signupController.userDLType.value == "Select DL Type" ? "" : signupController.userDLType.value.capitalize} DL Number",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            )),
                                            const SizedBox(height: 2.5),
                                            TextFormField(
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                              textCapitalization:
                                              TextCapitalization.characters,
                                              focusNode: signupController
                                                  .userDLNumberFocusNode.value,
                                              controller:
                                              signupController.userDLNumber.value,
                                              maxLength: 16,
                                              onEditingComplete: () {
                                                _validateDLNumber();
                                              },
                                              onChanged: (value) {
                                                if (value.length == 16) {
                                                  signupController
                                                      .userDLNumberFocusNode.value
                                                      .unfocus();
                                                  validateDLNumber2(value);
                                                }
                                              },
                                              onFieldSubmitted: (value) {
                                                validateDLNumber2(value);
                                              },
                                              textAlignVertical: TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                hintText: 'Number',
                                                hintStyle: const TextStyle(
                                                    color: Colors.black45, fontSize: 14),
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                counterText: '',
                                                filled: true,
                                                fillColor:signupController.userHaveDrivingLicence.value == "Yes" ? Colors.white : Colors.grey.withOpacity(0.2),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1)),
                                                // label: Text.rich(
                                                //   TextSpan(
                                                //     children: <InlineSpan>[
                                                //       WidgetSpan(
                                                //         child: Text(
                                                //             "${signupController.userDLType.value} DL Number",
                                                //             style: TextStyle(
                                                //                 color: signupController
                                                //                         .userDLNumberFocusNode
                                                //                         .value
                                                //                         .hasFocus
                                                //                     ? Colors.black
                                                //                     : Colors.black45)),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                              ),
                                            ),
                                            // vehical type
                                            const SizedBox(height: 10),
                                            RichText(
                                              text: const TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Vehicle Type',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        overflow: TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red, fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 2.5),
                                            Container(
                                              padding: const EdgeInsets.only(left: 0, right: 0),
                                              decoration: BoxDecoration(
                                                color: signupController.userHaveDrivingLicence.value == "Yes" ? Colors.white : Colors.grey.withOpacity(0.2),
                                                border: Border.all(color: Color(0xffFFC59D)),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: DropdownSearch<BloodType>.multiSelection(
                                                items: (String filter, LoadProps? loadProps) => signupController.dlVehicleTypeList,
                                                compareFn: (BloodType a, BloodType b) => a.value == b.value,
                                                itemAsString: (BloodType item) => item.name,
                                                selectedItems: signupController.selectedDlVehicleTypeList.value,
                                                decoratorProps: DropDownDecoratorProps(
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                                                    isDense: true,
                                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                                    suffixIconConstraints: BoxConstraints(minWidth: 2.0),
                                                  ),
                                                ),

                                                popupProps: PopupPropsMultiSelection.menu(
                                                  showSearchBox: false,
                                                  checkBoxBuilder: (context, item, isDisabled, isSelected) {
                                                    return Checkbox(
                                                      value: isSelected,
                                                      activeColor: Color(0xffFFC59D),
                                                      onChanged: (value) {},
                                                    );
                                                  },
                                                  validationBuilder: (context, items) {
                                                    return TextButton(
                                                      style: TextButton.styleFrom(backgroundColor: Color(0xffFFC59D)),
                                                      onPressed: () {
                                                        debugPrint("${items.map((e) => e.name).join(", ")}");
                                                        signupController.selectedDlVehicleTypeList.value = items;
                                                        signupController.userDlVehicleType.value = "${items.map((e) => e.name).join(", ")}";
                                                        signupController.userDlVehicleTypeId.value = "${items.map((e) => e.value).join(",")}";
                                                        debugPrint("userDlVehicleTypeId== ${signupController.userDlVehicleTypeId.value}");
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Add",
                                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                                      ),
                                                    );
                                                  },
                                                ),

                                                dropdownBuilder: (context, selectedItems) {
                                                  return Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 4.0),
                                                    child: Text(
                                                      signupController.userDlVehicleType.value.isNotEmpty ? signupController.userDlVehicleType.value : "Select Vehicle Type", // ✅ Convert model to String
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        color: Color(0xff7A7A7A),
                                                      ),
                                                    ),
                                                  );
                                                },

                                                onChanged: (List<BloodType> value) {
                                                  print("Selected Items: ${value.map((e) => e.name).toList()}");
                                                },
                                              ),
                                            ),
                                            // DL Issue Date
                                            const SizedBox(height: 10),
                                            RichText(
                                              text: const TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'DL Issue Date',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        overflow: TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red, fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            TextFormField(
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500),
                                                controller: signupController
                                                    .userDlIssueDate.value,
                                                focusNode: signupController
                                                    .userDlIssueDateFocusNode.value,
                                                keyboardType: TextInputType.none,
                                                textAlignVertical:
                                                TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                  hintText: 'DL Issue Date',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14),
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  filled: true,
                                                  fillColor: signupController.userHaveDrivingLicence.value == "Yes" ? Colors.white : Colors.grey.withOpacity(0.2),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  suffixIcon: Icon(
                                                    Icons.calendar_month,
                                                    color: Colors.deepOrange.shade500,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  DateTime displayYear = DateTime.now();
                                                  int showYear = displayYear.year;
                                                  final selectedDate =
                                                  await showDatePicker(
                                                    context: context,  initialEntryMode: DatePickerEntryMode.calendarOnly,
                                                    locale: const Locale('en',
                                                        'GB'), // Ensures dd/MM/yyyy format in the calendar

                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1965),
                                                    lastDate: DateTime.now(),
                                                    builder: (context, child) {
                                                      return Theme(
                                                        data: Theme.of(context).copyWith(
                                                          colorScheme:
                                                          const ColorScheme.light(
                                                            primary: Colors.orangeAccent,
                                                            onPrimary: Colors.white,
                                                            onSurface: Colors.black,
                                                          ),
                                                          textButtonTheme:
                                                          TextButtonThemeData(
                                                            style: TextButton.styleFrom(
                                                              foregroundColor:
                                                              Colors.black45,
                                                            ),
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                  );
                                                  if (selectedDate != null) {
                                                    final displayDate =
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(selectedDate);

                                                    // Format for API (yyyy-mm-dd)
                                                    final apiDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(selectedDate);

                                                    signupController.userDlIssueDate.value
                                                        .text = displayDate;
                                                    signupController
                                                        .userDlIssueDateApiFormat
                                                        .value
                                                        .text = apiDate;
                                                  }
                                                }),
                                            // DL Expire Date
                                            const SizedBox(height: 10),
                                            RichText(
                                              text: const TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'DL Expire Date',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        overflow: TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red, fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            TextFormField(
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500),
                                                controller: signupController
                                                    .userDlExpireDate.value,
                                                focusNode: signupController
                                                    .userDlExpireDateFocusNode.value,
                                                keyboardType: TextInputType.none,
                                                textAlignVertical:
                                                TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                  hintText: 'DL Expire Date',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14),
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  filled: true,
                                                  fillColor: signupController.userHaveDrivingLicence.value == "Yes" ? Colors.white : Colors.grey.withOpacity(0.2),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  suffixIcon: Icon(
                                                    Icons.calendar_month,
                                                    color: Colors.deepOrange.shade500,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  DateTime displayYear = DateTime.now();
                                                  int showYear = displayYear.year;
                                                  final selectedDate =
                                                  await showDatePicker(
                                                    context: context,  initialEntryMode: DatePickerEntryMode.calendarOnly,
                                                    locale: const Locale('en',
                                                        'GB'), // Ensures dd/MM/yyyy format in the calendar

                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1965),
                                                    lastDate: DateTime(2070),
                                                    builder: (context, child) {
                                                      return Theme(
                                                        data: Theme.of(context).copyWith(
                                                          colorScheme:
                                                          const ColorScheme.light(
                                                            primary: Colors.orangeAccent,
                                                            onPrimary: Colors.white,
                                                            onSurface: Colors.black,
                                                          ),
                                                          textButtonTheme:
                                                          TextButtonThemeData(
                                                            style: TextButton.styleFrom(
                                                              foregroundColor:
                                                              Colors.black45,
                                                            ),
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                  );
                                                  if (selectedDate != null) {
                                                    final displayDate =
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(selectedDate);

                                                    // Format for API (yyyy-mm-dd)
                                                    final apiDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(selectedDate);

                                                    signupController.userDlExpireDate
                                                        .value.text = displayDate;
                                                    signupController
                                                        .userDlExpireDateApiFormat
                                                        .value
                                                        .text = apiDate;
                                                  }
                                                }),
                                            const SizedBox(height: 10),
                                            // Dl Photo
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "DL Photo",
                                                    // "${signupController.userDLType.value.capitalize} DL Photo",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        overflow: TextOverflow.ellipsis,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                        color: Colors.red, fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 2.5),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    _showCameraGalleryDialog(
                                                        context,
                                                        (signupController
                                                            .DLFrontShowImage));
                                                  },
                                                  child: Container(
                                                    height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.085,
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.4,
                                                    decoration: BoxDecoration(
                                                      color: signupController.userHaveDrivingLicence.value == "Yes" ? Colors.white : Colors.black.withOpacity(0.1),
                                                      borderRadius:
                                                      BorderRadius.circular(10.0),
                                                      border: Border.all(
                                                        color: Color(0xffFFC59D),
                                                        style: BorderStyle.solid,
                                                      ),
                                                      boxShadow: signupController.userHaveDrivingLicence.value == "Yes" ? [
                                                        BoxShadow(
                                                          color: Colors.white,
                                                          offset: Offset(0, 0),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ] : null,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Obx(() {
                                                          return signupController
                                                              .userDLFrontSideBase64
                                                              .value
                                                              .isNotEmpty
                                                              ? Image.memory(
                                                            base64Decode(
                                                                signupController
                                                                    .userDLFrontSideBase64
                                                                    .value),
                                                            width:
                                                            75, // Adjust the width as required
                                                            height:
                                                            80, // Adjust the height as required
                                                          )
                                                              : Image.asset(
                                                            "assets/images/snapShortImage.png",
                                                            height:
                                                            MediaQuery.sizeOf(
                                                                context)
                                                                .height *
                                                                0.05,
                                                          );
                                                        }),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                            child: RichText(
                                                              text: const TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: 'DL Front Photo',
                                                                    style: TextStyle(
                                                                        fontSize: 10,
                                                                        overflow: TextOverflow
                                                                            .ellipsis,
                                                                        color: Colors.black,
                                                                        fontWeight:
                                                                        FontWeight.w400),
                                                                  ),
                                                                ],
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _showCameraGalleryDialog(
                                                        context,
                                                        (signupController
                                                            .DLBackShowImage));
                                                  },
                                                  child: Container(
                                                    height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.085,
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.4,
                                                    decoration: BoxDecoration(
                                                      color: signupController.userHaveDrivingLicence.value == "Yes" ? Colors.white : Colors.grey.withOpacity(0.2),
                                                      borderRadius:
                                                      BorderRadius.circular(10.0),
                                                      border: Border.all(
                                                        color: Color(0xffFFC59D),
                                                        style: BorderStyle.solid,
                                                      ),
                                                      boxShadow: signupController.userHaveDrivingLicence.value == "Yes" ? [
                                                        BoxShadow(
                                                          color: Colors.white,
                                                          offset: Offset(0, 0),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ] : null,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Obx(() {
                                                          return signupController
                                                              .userDLBackSideBase64
                                                              .isNotEmpty
                                                              ? Image.memory(
                                                            base64Decode(
                                                                signupController
                                                                    .userDLBackSideBase64
                                                                    .value),
                                                            width: 75,
                                                            height: 80,
                                                          )
                                                              : Image.asset(
                                                            "assets/images/snapShortImage.png",
                                                            height:
                                                            MediaQuery.sizeOf(
                                                                context)
                                                                .height *
                                                                0.05,
                                                          );
                                                        }),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                            child: RichText(
                                                              text: const TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: 'DL Back Photo',
                                                                    style: TextStyle(
                                                                        fontSize: 10,
                                                                        overflow: TextOverflow
                                                                            .ellipsis,
                                                                        color: Colors.black,
                                                                        fontWeight:
                                                                        FontWeight.w400),
                                                                  ),
                                                                ],
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                    ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          bool validate = validateForthStage();
                                          if (validate) {
                                            debugPrint("Validated 4");
                                            setState(() {
                                              signupController
                                                  .signupSteeperCurrentPage
                                                  .value = 4;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              3,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.065,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(40),
                                            gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFFF9B55),
                                                  Color(0xFFE15D29)
                                                ],
                                                begin: Alignment.topCenter,
                                                stops: [
                                                  0.4,
                                                  30.0,
                                                ],
                                                end: Alignment.bottomCenter),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Next",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ]),
                      )),
                ),
              ]));
    });
  } // 4

  buildRadioTile({required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
         width:20,
          child: Obx(()=>Radio(
            value: value,
            activeColor: Colors.deepOrange.shade500,
            groupValue: signupController.userHaveDrivingLicence.value,
            onChanged: (value) {
              signupController.userHaveDrivingLicence.value = value!;
              if(value == "No"){
                signupController.userDLType.value = "Select DL Type";
                signupController.userDLTypeId = "";
                signupController.userDlVehicleType.value = "Select Vehicle Type";
                signupController.userDlVehicleTypeId.value = "";
                signupController.selectedDlVehicleTypeList.clear();
                signupController.userDLNumber.value.clear();
                signupController.userDlIssueDate.value.clear();
                signupController.userDlIssueDateApiFormat.value.clear();
                signupController.userDlExpireDate.value.clear();
                signupController.userDlExpireDateApiFormat.value.clear();
                signupController.userDLFrontSideBase64.value = "";
                signupController.userDLBackSideBase64.value = "";
              }
            },)),
        ),
        SizedBox(width:4.0),
        Text(value)
      ],
    );
  }

  bool validateForthStage() {

    // if (signupController.userDlVehicleType.value.isEmpty ||
    //     signupController.userDlVehicleType.value == "Select Vehicle Type") {
    //   MyToast.myShowToast("Please select Vehicle Type");
    //   return false;
    // }

    if(signupController.userHaveDrivingLicence.value == ""){
      MyToast.myShowToast("Do you have a driving license? Please select 'Yes' or 'No'.");
      return false;
    }

    if(signupController.userHaveDrivingLicence.value == "No"){
      return true;
    }

    if (signupController.userDLType.value.isEmpty ||
        signupController.userDLType.value == "Select DL Type") {
      MyToast.myShowToast("Please select DL Type");
      return false;
    }

    if (signupController.userDlVehicleType.value != "BICYCLE" &&
        (signupController.userDLNumber.value.text.trim().isEmpty ||
            signupController.userDLNumber.value.text.trim().length != 16)) {
      MyToast.myShowToast("Please provide a valid DL Number eg: MH-2020119876543");
      return false;
    }
    if (signupController.userDLNumber.value.text.trim().isEmpty) {
      MyToast.myShowToast("DL Number can't be empty eg: MH-2020119876543");
      return false;
    }
    if (signupController.userDLNumber.value.text.trim().isNotEmpty) {
      RegExp reg = RegExp(
          r"^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}" +
              r"|([a-zA-Z]{2}[0-9]{2}[\\/][a-zA-Z]{3}[\\/][0-9]{2}[\\/][0-9]{5})" +
              r"|([a-zA-Z]{2}[0-9]{2}(N)[\\-]{1}((19|20)[0-9][0-9])[\\-][0-9]{7})" +
              r"|([a-zA-Z]{2}[0-9]{14})" +
              r"|([a-zA-Z]{2}[\\-][0-9]{13})$");
      if (!reg.hasMatch(
          signupController.userDLNumber.value.text.trim().toUpperCase())) {
        MyToast.myShowToast("Invalid Driving License Number");
        return false;
      }

      if(signupController.selectedDlVehicleTypeList.isEmpty){
        MyToast.myShowToast("Please select Vehicle Type");
        return false;
      }

      // var isDlValid = validateDLNumber();
      // if (!isDlValid) {
      //   MyToast.myShowToast("Please provide a valid DL Number ");
      //   return false;
      // }
    }
    if (signupController.userDlIssueDate.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please select DL Issue Date");
      return false;
    }

    if (signupController.userDlExpireDate.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please select DL Expire Date");
      return false;
    }

    if (signupController.userDlExpireDate.value.text.trim().isNotEmpty &&
        signupController.userDlIssueDate.value.text.trim().isNotEmpty) {
      DateTime? issueDate =
          _parseDate(signupController.userDlIssueDate.value.text.trim());
      DateTime? expireDate =
          _parseDate(signupController.userDlExpireDate.value.text.trim());

      // Ensure both dates are valid before comparison
      if (issueDate == null || expireDate == null) {
        MyToast.myShowToast("Invalid date format. Please enter a valid Date.");
        return false;
      }

      if (expireDate.isBefore(issueDate)) {
        MyToast.myShowToast(
            "DL Expire Date cannot be before the DL Issue Date");
        return false;
      }
    }

    if (signupController.userDLFrontSideBase64.value.isEmpty) {
      MyToast.myShowToast("Please upload DL Front Photo");
      return false;
    }
    if (signupController.userDLBackSideBase64.value.isEmpty) {
      MyToast.myShowToast("Please upload DL Back Photo");
      return false;
    }
/*    if (signupController.userVehicleType.value != "BICYCLE" &&
        signupController.userIssueDate.value.text.isEmpty) {
      MyToast.myShowToast("Issue Date can't be empty ");
      return false;
    }
    if (signupController.userVehicleType.value != "BICYCLE" &&
        signupController.userExpiryDate.value.text.isEmpty) {
      MyToast.myShowToast("Expiry Date can't be empty ");
      return false;
    }*/
    /*  if (signupController.voterDLFrontImageList.isEmpty ||
        signupController.voterDLBackImageList.isEmpty) {
      MyToast.myShowToast("Driving License/Voter Id image can't be empty ");
      return false;
    }
    if (signupController.voterDLBackImageList.isEmpty) {
      MyToast.myShowToast("Driving License/Voter Id image can't be empty ");
      return false;
    }*/
    return true;
  }

  // Helper function to parse DD/MM/YYYY date format
  DateTime? _parseDate(String dateString) {
    try {
      List<String> parts = dateString.split("/");
      if (parts.length != 3) return null;
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }


  buildFifthStage() {
    return Obx(() {
      return signupController.masterList.isEmpty
          ? SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.deepOrange.shade500,
            ),
            const SizedBox(height: 10),
            const Text(
              "Please wait while form is loading",
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      )
          : Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: const BoxDecoration(
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
                    Image.asset(
                      "assets/images/abhi_logo.png",
                      height: MediaQuery.sizeOf(context).height * 0.08,
                      width: MediaQuery.sizeOf(context).width,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: Container(
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        signupController.signupSteeperCurrentPage.value = 3;
                      });
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.13,
              left: 0,
              right: 0,
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.04,
                      vertical: MediaQuery.sizeOf(context).height * 0.015),
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.03),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFEFE6),
                      borderRadius: BorderRadius.circular(12)),
                  width: MediaQuery.sizeOf(context).width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Fill Basic Details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 25),
                                ),
                                SizedBox(height: 5),
                                Text("Create your Account",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black45)),
                              ],
                            ),
                          ),
                          showRemark(),
                          const SizedBox(height: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Vehicle Information",
                                style: TextStyle(
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2.5),
                              Divider(
                                color: Color(0xffFF9B55),
                                thickness: 1,
                              ),
                              IgnorePointer(
                                  ignoring:  signupController.isSignupFromEditable.value,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // vehical type
                                    const SizedBox(height: 10),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Vehicle Type',
                                            style: TextStyle(
                                                fontSize: 13,
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(
                                            text: '*',
                                            style: TextStyle(
                                                color: Colors.red, fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2.5),
                                    Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Color(0xffFFC59D)),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: DropdownButton<BloodType>(
                                          value: signupController.vehicleTypeList
                                              .firstWhere(
                                                (element) =>
                                            element.name ==
                                                signupController
                                                    .userVehicleType
                                                    .value,
                                            orElse: () => signupController
                                                .vehicleTypeList
                                                .first,
                                          ),
                                          isExpanded: true,
                                          underline: Container(),
                                          onChanged: (selected) {
                                            signupController.userVehicleType.value = selected!.name;
                                            if (selected.name !=
                                                "Select Vehicle Type") {
                                              signupController
                                                  .userVehicleTypeId
                                                  .value =
                                                  selected.value.toString();
                                            } else {
                                              signupController
                                                  .userVehicleTypeId
                                                  .value = "";
                                            }
                                            print(
                                                " User Vehicle Type Id ${signupController.userVehicleTypeId.value}");

                                            if(signupController.userVehicleType.value == "On-foot" || signupController.userVehicleType.value.trim() == "Bicycle"){
                                              signupController.userVehicleNumber.value.clear();
                                              signupController.userRcBase64.value = "";
                                            }

                                          },
                                          items: signupController
                                              .vehicleTypeList
                                              .map((items) {
                                            return DropdownMenuItem<
                                                BloodType>(
                                              value: items,
                                              child: Text(items.name,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      color:
                                                      Color(0xff7A7A7A),
                                                      fontWeight:
                                                      FontWeight.w500)),
                                            );
                                          }).toList(),
                                        )
                                    ),
                                    const SizedBox(height: 10),
                                    IgnorePointer(
                                      ignoring: signupController.userVehicleType.value == "On-foot" || signupController.userVehicleType.value.trim() == "Bicycle" ? true : false,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                  "Vehicle Number",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 2.5),
                                          TextFormField(
                                            style: const TextStyle(
                                                fontSize: 13,
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                            textCapitalization:
                                            TextCapitalization.characters,
                                            focusNode: signupController
                                                .userVehicleNumberFocusNode.value,
                                            controller:
                                            signupController.userVehicleNumber.value,
                                            maxLength: 16,
                                            onEditingComplete: () {

                                            },
                                            onChanged: (value) {

                                            },
                                            onFieldSubmitted: (value) {

                                            },
                                            textAlignVertical: TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              hintText: 'Number',
                                              hintStyle: const TextStyle(
                                                  color: Colors.black45, fontSize: 14),
                                              contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              counterText: '',
                                              filled: true,
                                              fillColor:signupController.userVehicleType.value == "On-foot" || signupController.userVehicleType.value.trim() == "Bicycle" ? Colors.grey.withOpacity(0.2) :  Colors.white ,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFFFFC59D),
                                                      width: 1)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFFFFC59D),
                                                      width: 1)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFFFFC59D),
                                                      width: 1)),
                                              // label: Text.rich(
                                              //   TextSpan(
                                              //     children: <InlineSpan>[
                                              //       WidgetSpan(
                                              //         child: Text(
                                              //             "${signupController.userDLType.value} DL Number",
                                              //             style: TextStyle(
                                              //                 color: signupController
                                              //                         .userDLNumberFocusNode
                                              //                         .value
                                              //                         .hasFocus
                                              //                     ? Colors.black
                                              //                     : Colors.black45)),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "RC Photo",
                                                  // "${signupController.userDLType.value.capitalize} DL Photo",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      overflow: TextOverflow.ellipsis,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                      color: Colors.red, fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 2.5),
                                          GestureDetector(
                                            onTap: () {
                                              _showCameraGalleryDialog(context, (signupController.RcShowImage));
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.085,
                                              decoration: BoxDecoration(
                                                color: signupController.userVehicleType.value == "On-foot" || signupController.userVehicleType.value.trim() == "Bicycle" ? Colors.grey.withOpacity(0.2) :  Colors.white ,
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  color: Color(0xffFFC59D),
                                                  style: BorderStyle.solid,
                                                ),
                                                boxShadow: signupController.userVehicleType.value == "On-foot" || signupController.userVehicleType.value.trim() == "Bicycle" ? null : [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(0, 0),
                                                    blurRadius: 1.0,
                                                    spreadRadius: 1.0,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Obx(() {
                                                    return signupController
                                                        .userRcBase64
                                                        .value
                                                        .isNotEmpty
                                                        ? Image.memory(
                                                      base64Decode(
                                                          signupController
                                                              .userRcBase64
                                                              .value),
                                                      width:
                                                      75, // Adjust the width as required
                                                      height:
                                                      80, // Adjust the height as required
                                                    )
                                                        : Image.asset(
                                                      "assets/images/snapShortImage.png",
                                                      height:
                                                      MediaQuery.sizeOf(
                                                          context)
                                                          .height *
                                                          0.05,
                                                    );
                                                  }),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: RichText(
                                                        text: const TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'RC Photo',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  color: Colors.black,
                                                                  fontWeight:
                                                                  FontWeight.w400),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      bool validate = validateVehicleStage();
                                      if (validate) {
                                        debugPrint("Validated 5");
                                        setState(() {
                                          signupController
                                              .signupSteeperCurrentPage
                                              .value = 5;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          3,
                                      height: MediaQuery.of(context)
                                          .size
                                          .height *
                                          0.065,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(40),
                                        gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFF9B55),
                                              Color(0xFFE15D29)
                                            ],
                                            begin: Alignment.topCenter,
                                            stops: [
                                              0.4,
                                              30.0,
                                            ],
                                            end: Alignment.bottomCenter),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Next",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ]),
                  )),
            ),
          ]));
    });
  }//5

  bool validateVehicleStage() {
    if (signupController.userVehicleType.value.isEmpty ||
        signupController.userVehicleType.value == "Select Vehicle Type") {
      MyToast.myShowToast("Please select Vehicle Type");
      return false;
    }

    if(signupController.userVehicleType.value == "On-foot" || signupController.userVehicleType.value.trim() == "Bicycle"){
      return true;
    }

    if(signupController.userVehicleNumber.value.text.trim().isEmpty){
      MyToast.myShowToast("Please enter Vehicle Number");
      return false;
    }

    String vehicleNumber = signupController.userVehicleNumber.value.text.toUpperCase();

    RegExp vehicleRegExp = RegExp(
      r"^(?:"
      r"[A-Z]{2}\s?[0-9]{1,2}\s?[A-Z]{1,3}\s?[0-9]{4}|"        // Private & Commercial (MH 12 AB 1234)
      r"[A-Z]{2}\s?[0-9]{1,2}\s?EV\s?[0-9]{4}|"                 // Electric Vehicles (DL 14 EV 9876)
      r"TEMP\s?[0-9]{4}|"                                       // Temporary Vehicles (TEMP 5678)
      r"CD\s?[0-9]{1,2}\s?[0-9]{3}|"                           // Diplomatic Vehicles (CD 34 678)
      r"[0-9]{2}[A-Z]\s?[0-9]{3}[A-Z]?"                        // Military Vehicles (10A 123B)
      r"|[A-Z]{2}\s?BH\s?[0-9]{4}\s?[A-Z]{2}|"                 // Bharat Series (HR BH 2025 XX)
      r"[A-Z]{2}\s?VA\s?[0-9]{4}"                              // Vintage Vehicles (DL VA 1947)
      r")$",
      caseSensitive: false,
    );

    if (!vehicleRegExp.hasMatch(vehicleNumber)) {
      MyToast.myShowToast("Enter a valid vehicle number (e.g., MH 12 AB 1234, KA 05 CD 6789, TEMP 5678, etc.)");
      return false;
    }

    // RegExp vehicleRegExp = RegExp(r"^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$");
    //
    // if (!vehicleRegExp.hasMatch(signupController.userVehicleNumber.value.text.toUpperCase())) {
    //   MyToast.myShowToast("Enter a valid vehicle number (e.g., GJ01AB1234)");
    //   return false;
    // }

    if (signupController.userRcBase64.value.isEmpty) {
      MyToast.myShowToast("Please upload Rc Photo");
      return false;
    }
    return true;
  }


  /// FifthStage

  buildSixthStage() {
    return Obx(() {
      return signupController.masterList.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.deepOrange.shade500,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please wait while form is loading",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  height: signupController.driverDetailModel != null &&
                          signupController.driverDetailModel!.remarks != null
                      ? MediaQuery.of(context).size.height * 1.16
                      : MediaQuery.of(context).size.height * 1.11,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Stack(children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.18,
                      decoration: const BoxDecoration(
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
                            Image.asset(
                              "assets/images/abhi_logo.png",
                              height: MediaQuery.sizeOf(context).height * 0.08,
                              width: MediaQuery.sizeOf(context).width,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                signupController
                                    .signupSteeperCurrentPage.value = 4;
                              });
                            },
                            icon: const Icon(Icons.arrow_back)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.sizeOf(context).height * 0.13,
                      left: 0,
                      right: 0,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.sizeOf(context).width * 0.04,
                              vertical:
                                  MediaQuery.sizeOf(context).height * 0.015),
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.sizeOf(context).width * 0.03),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFEFE6),
                              borderRadius: BorderRadius.circular(12)),
                          width: MediaQuery.sizeOf(context).width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Fill Basic Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                        SizedBox(height: 5),
                                        Text("Create your Account",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black45)),
                                      ],
                                    ),
                                  ),
                                  showRemark(),
                                  const SizedBox(height: 30),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Document uploads",
                                        style: TextStyle(
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 2.5),
                                      Divider(
                                        color: Color(0xffFF9B55),
                                        thickness: 1,
                                      ),
                                      IgnorePointer(
                                        ignoring: signupController.isSignupFromEditable.value,
                                          child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // aadhar card
                                              const SizedBox(height: 2.5),
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Aadhar Card Number",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    TextSpan(
                                                      text: '*',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 2.5),
                                              TextFormField(
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500),
                                                focusNode: signupController
                                                    .userAadhaarNumberFocusNode.value,
                                                controller: signupController
                                                    .userAadhaarNumber.value,
                                                keyboardType: TextInputType.number,
                                                onChanged: (value) {
                                                  if (value.trim().length == 12) {
                                                    signupController
                                                        .userAadhaarNumberFocusNode
                                                        .value
                                                        .unfocus(); setState(() {

                                                    });
                                                    signupController.checkAadharCardNumberAvailable();
                                                    setState(() {

                                                    });
                                                  }
                                                },
                                                maxLength: 12,
                                                textAlignVertical:
                                                TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                  hintText: 'Number',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14),
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  counterText: "",
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  // label: Text.rich(
                                                  //   TextSpan(
                                                  //     children: <InlineSpan>[
                                                  //       WidgetSpan(
                                                  //         child: Text('Aadhaar Number',
                                                  //             style: TextStyle(
                                                  //               color: signupController
                                                  //                       .userAadhaarNumberFocusNode
                                                  //                       .value
                                                  //                       .hasFocus
                                                  //                   ? Color(0xffC7C7CC)
                                                  //                   : Color(0xffC7C7CC),
                                                  //             )),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showCameraGalleryDialog(
                                                          context,
                                                          (signupController
                                                              .aadhaarFrontShowImage));
                                                    },
                                                    child: Container(
                                                      height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.085,
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.4,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                        border: Border.all(
                                                          color: Color(0xffFFC59D),
                                                          style: BorderStyle.solid,
                                                        ),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Colors.white,
                                                            offset: Offset(0, 0),
                                                            blurRadius: 1.0,
                                                            spreadRadius: 1.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 18,
                                                          ),
                                                          Obx(() {
                                                            return signupController
                                                                .aadhaarFrontImageBase64
                                                                .value
                                                                .isNotEmpty
                                                                ? Image.memory(
                                                              base64Decode(
                                                                  signupController
                                                                      .aadhaarFrontImageBase64
                                                                      .value),
                                                              width: 75,
                                                              height: 80,
                                                            )
                                                                : Image.asset(
                                                              "assets/images/snapShortImage.png",
                                                              height: MediaQuery
                                                                  .sizeOf(
                                                                  context)
                                                                  .height *
                                                                  0.05,
                                                            );
                                                          }),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Flexible(
                                                                    child: RichText(
                                                                      textAlign:
                                                                      TextAlign.left,
                                                                      text: const TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                            'Aadhaar Photo (Front)',
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                10,
                                                                                overflow:
                                                                                TextOverflow
                                                                                    .ellipsis,
                                                                                color: Colors
                                                                                    .black,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w400),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showCameraGalleryDialog(
                                                          context,
                                                          (signupController
                                                              .aadhaarBackShowImage));
                                                    },
                                                    child: Container(
                                                      height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.085,
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.4,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                        border: Border.all(
                                                          color: Color(0xffFFC59D),
                                                          style: BorderStyle.solid,
                                                        ),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Colors.white,
                                                            offset: Offset(0, 0),
                                                            blurRadius: 1.0,
                                                            spreadRadius: 1.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Obx(() {
                                                            return signupController
                                                                .aadhaarBackImageBase64
                                                                .value
                                                                .isNotEmpty
                                                                ? Image.memory(
                                                              base64Decode(
                                                                  signupController
                                                                      .aadhaarBackImageBase64
                                                                      .value),
                                                              width: 75,
                                                              height: 80,
                                                            )
                                                                : signupController
                                                                .aadhaarBackImageList
                                                                .isNotEmpty
                                                                ? Image.file(
                                                              File(signupController
                                                                  .aadhaarBackImage
                                                                  .path),
                                                              width: 75,
                                                              height: 80,
                                                            )
                                                                : Image.asset(
                                                              "assets/images/snapShortImage.png",
                                                              height: MediaQuery.sizeOf(
                                                                  context)
                                                                  .height *
                                                                  0.05,
                                                            );
                                                          }),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Flexible(
                                                                    child: RichText(
                                                                      textAlign:
                                                                      TextAlign.left,
                                                                      text: const TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                            'Aadhaar Photo (Back)',
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                10,
                                                                                overflow:
                                                                                TextOverflow
                                                                                    .ellipsis,
                                                                                color: Colors
                                                                                    .black,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w400),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              // pan card number
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "PAN Card Number",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    TextSpan(
                                                      text: '*',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 2.5),
                                              TextFormField(
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    overflow: TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500),
                                                textCapitalization:
                                                TextCapitalization.characters,
                                                maxLength: 10,
                                                focusNode: signupController
                                                    .userPanNumberFocusNode.value,
                                                controller: signupController
                                                    .userPanNumber.value,
                                                onChanged: (value) {
                                                  if (value.trim().length == 10) {
                                                    signupController
                                                        .userPanNumberFocusNode.value
                                                        .unfocus();
                                                    validatePanCard(value); setState(() {

                                                    });
                                                    signupController.checkPanCardNumberAvailable(); setState(() {

                                                    });
                                                  }
                                                },
                                                textAlignVertical:
                                                TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                  hintText: 'Number',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14),
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  filled: true,
                                                  counterText: '',
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: const BorderSide(
                                                          color: Color(0xFFFFC59D),
                                                          width: 1)),
                                                  // label: Text.rich(
                                                  //   TextSpan(
                                                  //     children: <InlineSpan>[
                                                  //       WidgetSpan(
                                                  //         child: Text('Pan Card Number',
                                                  //             style: TextStyle(
                                                  //                 color: signupController
                                                  //                         .userPanNumberFocusNode
                                                  //                         .value
                                                  //                         .hasFocus
                                                  //                     ? Color(
                                                  //                         0xffC7C7CC)
                                                  //                     : Color(
                                                  //                         0xffC7C7CC))),
                                                  //       ),
                                                  //       const WidgetSpan(
                                                  //         child: Text(
                                                  //           ' *',
                                                  //           style: TextStyle(
                                                  //               color: Colors.red),
                                                  //         ),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                /*           mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,*/
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showCameraGalleryDialog(
                                                          context,
                                                          (signupController
                                                              .panCardShowImage));
                                                    },
                                                    child: Container(
                                                      height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.085,
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.815,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                        border: Border.all(
                                                          color: Color(0xffFFC59D),
                                                          style: BorderStyle.solid,
                                                        ),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Colors.white,
                                                            offset: Offset(0, 0),
                                                            blurRadius: 1.0,
                                                            spreadRadius: 1.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Obx(() {
                                                            return signupController
                                                                .panCardImageBase64
                                                                .value
                                                                .isNotEmpty
                                                                ? Image.memory(
                                                              base64Decode(
                                                                  signupController
                                                                      .panCardImageBase64
                                                                      .value),
                                                              width: 75,
                                                              height: 80,
                                                            )
                                                                : signupController
                                                                .panCardImageList
                                                                .isNotEmpty
                                                                ? Image.file(
                                                              File(signupController
                                                                  .panCardImage
                                                                  .path),
                                                              width: 75,
                                                              height: 80,
                                                            )
                                                                : Image.asset(
                                                              "assets/images/snapShortImage.png",
                                                              height: MediaQuery.sizeOf(
                                                                  context)
                                                                  .height *
                                                                  0.05,
                                                            );
                                                          }),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: RichText(
                                                                      text: const TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                            'PAN Card',
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                10,
                                                                                overflow:
                                                                                TextOverflow
                                                                                    .ellipsis,
                                                                                color: Colors
                                                                                    .black,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w400),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  /*                 GestureDetector(
                                            onTap: () {
                                              _showCameraGalleryDialog(
                                                  context,
                                                  (signupController
                                                      .panCardBackShowImage));
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.085,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  color: Color(0xffFFC59D),
                                                  style: BorderStyle.solid,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(0, 0),
                                                    blurRadius: 1.0,
                                                    spreadRadius: 1.0,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Obx(() {
                                                    return signupController
                                                            .panCardBackImageList
                                                            .isNotEmpty
                                                        ? Image.file(
                                                            File(signupController
                                                                .panCardBackImage
                                                                .path),
                                                            width: 75,
                                                            height: 80,
                                                          )
                                                        : Image.asset(
                                                            "assets/images/snapShortImage.png",
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                0.05,
                                                          );
                                                  }),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        child: RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: const TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'PAN Card (Back)',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),*/
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              // voterID
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Voter Id Number',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 2.5),
                                              TextFormField(
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textCapitalization:
                                                TextCapitalization.characters,
                                                maxLength: 10,
                                                focusNode: signupController
                                                    .voterIdFocusNode.value,
                                                controller:
                                                signupController.voterId.value,
                                                onChanged: (value) {
                                                  // if (value.trim().length == 10) {
                                                  //   signupController
                                                  //       .voterIdFocusNode.value
                                                  //       .unfocus(); // ✅ Corrected
                                                  //   validateVoterId(value);
                                                  // }
                                                },
                                                textAlignVertical:
                                                TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                  hintText: 'Number',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14),
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  filled: true,
                                                  counterText: '',
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFFFC59D),
                                                        width: 1),
                                                  ),
                                                  // label: Text.rich(
                                                  //   TextSpan(
                                                  //     children: <InlineSpan>[
                                                  //       WidgetSpan(
                                                  //         child: Text(
                                                  //           'Voter ID Number',
                                                  //           style: TextStyle(
                                                  //             color: signupController
                                                  //                     .voterIdFocusNode
                                                  //                     .value
                                                  //                     .hasFocus
                                                  //                 ? Color(0xffC7C7CC)
                                                  //                 : Color(0xffC7C7CC),
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showCameraGalleryDialog(
                                                          context,
                                                          (signupController
                                                              .voterFrontShowImage));
                                                    },
                                                    child: Container(
                                                      height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.085,
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.4,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                        border: Border.all(
                                                          color: Color(0xffFFC59D),
                                                          style: BorderStyle.solid,
                                                        ),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Colors.white,
                                                            offset: Offset(0, 0),
                                                            blurRadius: 1.0,
                                                            spreadRadius: 1.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Obx(() {
                                                            return signupController
                                                                .userVoterDLFrontSideBase64
                                                                .value
                                                                .isNotEmpty
                                                                ? Image.memory(
                                                              base64Decode(
                                                                  signupController
                                                                      .userVoterDLFrontSideBase64
                                                                      .value),
                                                              width: 75,
                                                              height: 80,
                                                            )
                                                                : Image.asset(
                                                              "assets/images/snapShortImage.png",
                                                              height: MediaQuery
                                                                  .sizeOf(
                                                                  context)
                                                                  .height *
                                                                  0.05,
                                                            );
                                                          }),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Flexible(
                                                                    child: RichText(
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                      text: const TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                            'Voter ID (Front)',
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                10,
                                                                                overflow:
                                                                                TextOverflow
                                                                                    .ellipsis,
                                                                                color: Colors
                                                                                    .black,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w400),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showCameraGalleryDialog(
                                                          context,
                                                          (signupController
                                                              .voterBackShowImage));
                                                    },
                                                    child: Container(
                                                      height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.085,
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.4,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                        border: Border.all(
                                                          color: Color(0xffFFC59D),
                                                          style: BorderStyle.solid,
                                                        ),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Colors.white,
                                                            offset: Offset(0, 0),
                                                            blurRadius: 1.0,
                                                            spreadRadius: 1.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Obx(() {
                                                            return signupController
                                                                .userVoterDLBackSideBase64
                                                                .value
                                                                .isNotEmpty
                                                                ? Image.memory(
                                                              base64Decode(
                                                                  signupController
                                                                      .userVoterDLBackSideBase64
                                                                      .value),
                                                              width: 80,
                                                              height: 75,
                                                            )
                                                                : Image.asset(
                                                              "assets/images/snapShortImage.png",
                                                              height: MediaQuery
                                                                  .sizeOf(
                                                                  context)
                                                                  .height *
                                                                  0.05,
                                                            );
                                                          }),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Flexible(
                                                                    child: RichText(
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                      text: const TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                            ' Voter ID (Back)',
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                10,
                                                                                overflow:
                                                                                TextOverflow
                                                                                    .ellipsis,
                                                                                color: Colors
                                                                                    .black,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w400),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              // selfie
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Selfie  ',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    TextSpan(
                                                      text: '*',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 2.5),
                                              GestureDetector(
                                                onTap: () {
                                                  _showCameraGalleryDialog(
                                                      context,
                                                      (signupController
                                                          .selfieShowImage));
                                                },
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                      0.085,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.circular(10.0),
                                                    border: Border.all(
                                                      color: Color(0xffFFC59D),
                                                      style: BorderStyle.solid,
                                                    ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.white,
                                                        offset: Offset(0, 0),
                                                        blurRadius: 1.0,
                                                        spreadRadius: 1.0,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Obx(() {
                                                        return signupController
                                                            .selfieImageBase64
                                                            .value
                                                            .isNotEmpty
                                                            ? Image.memory(
                                                          base64Decode(
                                                              signupController
                                                                  .selfieImageBase64
                                                                  .value),
                                                          width: 75,
                                                          height: 80,
                                                        )
                                                            : Image.asset(
                                                          "assets/images/snapShortImage.png",
                                                          height:
                                                          MediaQuery.sizeOf(
                                                              context)
                                                              .height *
                                                              0.05,
                                                        );
                                                      }),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                          child: RichText(
                                                            text: const TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: 'Selfie  ',
                                                                  style: TextStyle(
                                                                      fontSize: 10,
                                                                      overflow: TextOverflow
                                                                          .ellipsis,
                                                                      color: Colors.black,
                                                                      fontWeight:
                                                                      FontWeight.w400),
                                                                ),
                                                              ],
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                          ),
                                      ),
                                      ///  btn
                                      const SizedBox(height: 10),
                                      !signupController.isSignupFromEditable.value ?
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              bool validate =
                                              validateSixthStage();
                                              if (validate) {
                                                debugPrint("Validated");   Dialogs.lottieLoading(context,
                                                    "assets/lottiee/abhi_loading.json");

                                                await signupController
                                                    .callSignUpSubmitApi(
                                                    context);

                                                if (signupController
                                                    .submitApiResponse
                                                    .value !=
                                                    null) {
                                                  Navigator.popUntil(
                                                    context,
                                                        (Route<dynamic> route) =>
                                                    route.isFirst,
                                                  );
                                                  if (signupController
                                                      .submitApiResponse
                                                      .value!
                                                      .insertId !=
                                                      0) {
                                                    MyToast.myShowToast(
                                                        "Successfully inserted");
                                                    signupController
                                                        .signupSteeperCurrentPage
                                                        .value = 0;
                                                    Get.offAll(
                                                            () => SignUpSuccess());
                                                  } else {
                                                    MyToast.myShowToast(
                                                        signupController
                                                            .submitApiResponse
                                                            .value!
                                                            .responseMsg);
                                                    // Get.to(const SignUpSuccess());
                                                  }
                                                }
                                                // print("after submitted");
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  3,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.065,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(40),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xFFFF9B55),
                                                      Color(0xFFE15D29)
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    stops: [
                                                      0.4,
                                                      30.0,
                                                    ],
                                                    end:
                                                    Alignment.bottomCenter),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ) : const SizedBox.shrink(),
                                    ],
                                  ),
                                ]),
                          )),
                    ),
                  ])));
    });
  } // 6

  bool validateSixthStage() {
    if (signupController.userAadhaarNumber.value.text.trim().isEmpty){
      MyToast.myShowToast("Please enter Aadhar Card Number");
      return false;
    }
    if (signupController.userAadhaarNumber.value.text.trim().isEmpty ||
        signupController.userAadhaarNumber.value.text.trim().length != 12 ||
        !signupController.userAadhaarNumber.value.text.trim().isNumericOnly) {
      MyToast.myShowToast("Please enter valid Aadhar Card Number");
      return false;
    }

    if(!signupController.isAadharNumberAvailable){
      MyToast.myShowToast("Already exists with other Mobile Number.");
      return false;
    }

    if (signupController.aadhaarFrontImageBase64.value.isEmpty) {
      MyToast.myShowToast("Please upload Aadhar Card Front Photo");
      return false;
    }
    if (signupController.aadhaarBackImageBase64.isEmpty) {
      MyToast.myShowToast("Please upload Aadhar Card Back Photo");
      return false;
    }
    if (signupController.userPanNumber.value.text.trim().isEmpty) {
      MyToast.myShowToast("Please enter PAN Card Number");
      return false;
    }
    // if (signupController.voterId.value.text.trim().isEmpty) {
    //   MyToast.myShowToast("Please enter Voter ID Number");
    //   return false;
    // }
    if (signupController.userPanNumber.value.text.isNotEmpty) {
      RegExp reg = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
      if (!reg.hasMatch(
          signupController.userPanNumber.value.text.trim().toUpperCase())) {
        MyToast.myShowToast("Please enter valid PAN Card Number");
        signupController.userPanNumber.value.clear();
        return false;
      }
    }

    if(!signupController.isPanNumberAvailable){
      MyToast.myShowToast("Already exists with other Mobile Number.");
      return false;
    }

    if (signupController.panCardImageBase64.value.isEmpty) {
      MyToast.myShowToast("Please upload PAN Card");
      return false;
    }
    /*  if (signupController.panCardBackImageList.isEmpty) {
      MyToast.myShowToast("Pan Card image can't be empty ");
      return false;
    }*/
    if (signupController.selfieImageBase64.value.isEmpty) {
      MyToast.myShowToast("Please upload Selfie");
      return false;
    }

    if (signupController.userPanNumber.value.text.isEmpty ||
        signupController.userPanNumber.value.text.trim().length != 10) {
      MyToast.myShowToast("Please enter valid PAN Card Number");
      return false;
    }

    /*  if (signupController.selectedBusiness.value.isEmpty ||
        signupController.selectedBusiness.value == "Select your Business") {
      signupController.selectedBusinessFocusNode.requestFocus();
      MyToast.myShowToast("Select your Business");
      return false;
    } else if (signupController.selectedDepartment.value.isEmpty ||
        signupController.selectedDepartment.value == "Select your Department") {
      signupController.selectedDepartmentFocusNode.requestFocus();
      MyToast.myShowToast("Select your Department");
      return false;
    } else if (signupController.selectedDepartmentState.value.isEmpty ||
        signupController.selectedDepartmentState.value == "Select your State") {
      signupController.selectedDepartmentStateFocusNode.requestFocus();
      MyToast.myShowToast("Select your State");
      return false;
    } else if (signupController.selectedBusinessUnit.value.isEmpty ||
        signupController.selectedBusinessUnit.value ==
            "Select your Business Unit") {
      signupController.selectedBusinessUnitFocusNode.requestFocus();
      MyToast.myShowToast("Select your Business Unit");
      return false;
    }*/
    return true;
  }

  /// sixthStage

  // buildSixthStage() {
  //   return Obx(() {
  //     return signupController.masterList.isEmpty
  //         ? SizedBox(
  //             height: MediaQuery.of(context).size.height,
  //             width: MediaQuery.of(context).size.width,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 CircularProgressIndicator(
  //                   color: Colors.deepOrange.shade500,
  //                 ),
  //                 const SizedBox(height: 10),
  //                 const Text(
  //                   "Please wait while form is loading",
  //                   style: TextStyle(fontSize: 15),
  //                 )
  //               ],
  //             ),
  //           )
  //         : SingleChildScrollView(
  //             scrollDirection: Axis.vertical,
  //             child: Container(
  //                 height: signupController.driverDetailModel != null &&
  //                         signupController.driverDetailModel!.remarks != null
  //                     ? MediaQuery.of(context).size.height * 1.08
  //                     : MediaQuery.of(context).size.height * 1.03,
  //                 width: MediaQuery.of(context).size.width,
  //                 color: Colors.white,
  //                 child: Stack(children: [
  //                   Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     height: MediaQuery.of(context).size.height * 0.18,
  //                     decoration: const BoxDecoration(
  //                       borderRadius:
  //                           BorderRadius.vertical(bottom: Radius.circular(16)),
  //                       gradient: LinearGradient(
  //                           colors: [Color(0xFFFF9B55), Color(0xFFE15D29)],
  //                           begin: Alignment.topCenter,
  //                           stops: [
  //                             0.4,
  //                             30.0,
  //                           ],
  //                           end: Alignment.bottomCenter),
  //                     ),
  //                     child: SafeArea(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         children: [
  //                           Image.asset(
  //                             "assets/images/abhi_logo.png",
  //                             height: MediaQuery.sizeOf(context).height * 0.08,
  //                             width: MediaQuery.sizeOf(context).width,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     child: Container(
  //                       child: IconButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               signupController
  //                                   .signupSteeperCurrentPage.value = 4;
  //                             });
  //                           },
  //                           icon: const Icon(Icons.arrow_back)),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     top: MediaQuery.sizeOf(context).height * 0.13,
  //                     left: 0,
  //                     right: 0,
  //                     child: Container(
  //                         padding: EdgeInsets.symmetric(
  //                             horizontal:
  //                                 MediaQuery.sizeOf(context).width * 0.04,
  //                             vertical:
  //                                 MediaQuery.sizeOf(context).height * 0.015),
  //                         margin: EdgeInsets.symmetric(
  //                             horizontal:
  //                                 MediaQuery.sizeOf(context).width * 0.03),
  //                         decoration: BoxDecoration(
  //                             color: const Color(0xFFFFEFE6),
  //                             borderRadius: BorderRadius.circular(12)),
  //                         width: MediaQuery.sizeOf(context).width,
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 SizedBox(
  //                                   width: MediaQuery.of(context).size.width,
  //                                   child: const Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.center,
  //                                     children: [
  //                                       Text(
  //                                         "Fill Basic Details",
  //                                         style: TextStyle(
  //                                             fontWeight: FontWeight.w500,
  //                                             color: Colors.black,
  //                                             fontSize: 25),
  //                                       ),
  //                                       SizedBox(height: 5),
  //                                       Text("Create your Account",
  //                                           style: TextStyle(
  //                                               fontSize: 15,
  //                                               color: Colors.black45)),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 showRemark(),
  //                                 const SizedBox(height: 30),
  //                                 Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       "Bank Details",
  //                                       style: TextStyle(
  //                                           fontSize: 16,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           color: Colors.black,
  //                                           fontWeight: FontWeight.w500),
  //                                     ),
  //                                     const SizedBox(height: 2.5),
  //                                     Divider(
  //                                       color: Color(0xffFF9B55),
  //                                       thickness: 1,
  //                                     ),
  //                                     // Bank selected
  //                                     const SizedBox(height: 10),
  //                                     RichText(
  //                                       text: const TextSpan(
  //                                         children: [
  //                                           TextSpan(
  //                                             text: 'Select Bank',
  //                                             style: TextStyle(
  //                                                 fontSize: 13,
  //                                                 overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                 color: Colors.black,
  //                                                 fontWeight: FontWeight.w500),
  //                                           ),
  //                                           TextSpan(
  //                                             text: '*',
  //                                             style: TextStyle(
  //                                                 color: Colors.red,
  //                                                 fontSize: 15),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 2.5),
  //                                     /* Container(
  //                                       decoration: BoxDecoration(
  //                                           border: Border.all(
  //                                               color: Color(0xffFFC59D)),
  //                                           color: Colors.white,
  //                                           borderRadius:
  //                                               BorderRadius.circular(10)),
  //                                       child: Obx(()=>DropdownButton2(
  //                                         dropdownStyleData: DropdownStyleData(
  //                                             maxHeight:
  //                                             MediaQuery.sizeOf(context)
  //                                                 .height *
  //                                                 0.50,
  //                                             decoration: BoxDecoration(
  //                                                 borderRadius:
  //                                                 BorderRadius.circular(
  //                                                     10))),
  //                                         isExpanded: true,
  //                                         underline: Container(),
  //                                         // value: signupController
  //                                         //     .selectedBank.value,
  //                                         onChanged: (selected) {
  //                                           signupController
  //                                               .selectedBank.value = selected!;
  //
  //                                           if (selected != "Select Bank") {
  //                                             var temp = <MasterResponse>[];
  //                                             temp.add(signupController
  //                                                 .masterList
  //                                                 .firstWhere((element) =>
  //                                             element.mName ==
  //                                                 selected &&
  //                                                 element.mTypeID == 116));
  //                                             signupController
  //                                                 .selectedBankId.value =
  //                                                 temp[0].mID.toString();
  //                                             debugPrint(
  //                                                 "Selected Bank Details : ${temp[0]}");
  //                                           } else {
  //                                             signupController
  //                                                 .selectedBankId.value = "";
  //                                           }
  //
  //                                           debugPrint(
  //                                               "selected bank id ${signupController.selectedBankId.value}");
  //                                         },
  //                                         dropdownSearchData:
  //                                         DropdownSearchData(
  //                                             searchController: null,
  //                                             searchInnerWidgetHeight: 50,
  //                                             searchInnerWidget: Container(
  //                                               padding:
  //                                               const EdgeInsets.all(
  //                                                   10),
  //                                               decoration: BoxDecoration(
  //                                                   border: Border.all(
  //                                                       color: Colors
  //                                                           .deepOrange
  //                                                           .shade500),
  //                                                   borderRadius:
  //                                                   BorderRadius
  //                                                       .circular(15)),
  //                                               child: TextFormField(
  //                                                 controller: signupController.serachBankController.value,
  //                                                 textAlignVertical:
  //                                                 TextAlignVertical
  //                                                     .center,
  //                                                 onChanged: (value) {
  //
  //                                                   signupController.filterBanks(value);
  //
  //                                                   // if(value.trim().isNotEmpty) {
  //                                                   //   setState(() {
  //                                                   //     signupController.filterBankList.value = signupController.bankList
  //                                                   //         .where((bank) => bank.toLowerCase().contains(value.toLowerCase()))
  //                                                   //         .toList();
  //                                                   //   });
  //                                                   // }else{
  //                                                   //   signupController.filterBankList.clear();
  //                                                   // }
  //                                                   // setState(() {
  //                                                   //
  //                                                   // });
  //
  //                                                 },
  //                                                 decoration:
  //                                                 InputDecoration(
  //                                                     contentPadding:
  //                                                     const EdgeInsets
  //                                                         .symmetric(
  //                                                         horizontal:
  //                                                         8),
  //                                                     hintText:
  //                                                     'Search',
  //                                                     isDense: true,
  //                                                     border: const OutlineInputBorder(
  //                                                         borderSide:
  //                                                         BorderSide(
  //                                                             color:
  //                                                             Color(0xff7A7A7A))),
  //                                                     suffixIcon: Icon(
  //                                                       Icons.search,
  //                                                       color: Colors
  //                                                           .deepOrange
  //                                                           .shade500,
  //                                                       size: 30,
  //                                                     )),
  //                                               ),
  //                                             )),
  //                                         onMenuStateChange: ((isOpen) {
  //                                           */
  //                                     /*
  //                                           bankSearchController.clear();*/
  //                                     /*
  //                                           null;
  //                                           setState(() {});
  //                                         }),
  //                                         items: signupController.filterBankList.isEmpty ? signupController.bankList
  //                                             .toSet()
  //                                             .toList()
  //                                             .map((items) {
  //                                           return DropdownMenuItem(
  //                                               value: items,
  //                                               child: Text(items,
  //                                                   style: const TextStyle(
  //                                                       fontSize: 14,
  //                                                       overflow: TextOverflow
  //                                                           .ellipsis,
  //                                                       color:
  //                                                       Color(0xff7A7A7A),
  //                                                       fontWeight:
  //                                                       FontWeight.w500)));
  //                                         }).toList() : signupController.filterBankList
  //                                             .toSet()
  //                                             .toList()
  //                                             .map((items) {
  //                                           return DropdownMenuItem(
  //                                               value: items,
  //                                               child: Text(items,
  //                                                   style: const TextStyle(
  //                                                       fontSize: 14,
  //                                                       overflow: TextOverflow
  //                                                           .ellipsis,
  //                                                       color:
  //                                                       Color(0xff7A7A7A),
  //                                                       fontWeight:
  //                                                       FontWeight.w500)));
  //                                         }).toList(),
  //                                       )),
  //                                     ),*/
  //
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                         border: Border.all(
  //                                             color: Color(0xffFFC59D)),
  //                                         color: Colors.white,
  //                                         borderRadius:
  //                                             BorderRadius.circular(10),
  //                                       ),
  //                                       child: Obx(
  //                                         () => DropdownButton2(
  //                                           dropdownStyleData:
  //                                               DropdownStyleData(
  //                                             maxHeight:
  //                                                 MediaQuery.sizeOf(context)
  //                                                         .height *
  //                                                     0.50,
  //                                             decoration: BoxDecoration(
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(
  //                                                         10)),
  //                                           ),
  //                                           isExpanded: true,
  //                                           underline: Container(),
  //                                           value: signupController
  //                                                   .filterBankList.isNotEmpty
  //                                               ? null
  //                                               : signupController.selectedBank
  //                                                       .value.isNotEmpty
  //                                                   ? signupController
  //                                                       .selectedBank.value
  //                                                   : null,
  //                                           onChanged: (selected) {
  //                                             signupController.selectedBank
  //                                                 .value = selected!;
  //
  //                                             if (selected != "Select Bank") {
  //                                               var temp = signupController
  //                                                   .masterList
  //                                                   .where((element) =>
  //                                                       element.mName ==
  //                                                           selected &&
  //                                                       element.mTypeID == 116)
  //                                                   .toList();
  //
  //                                               if (temp.isNotEmpty) {
  //                                                 signupController
  //                                                         .selectedBankId
  //                                                         .value =
  //                                                     temp[0].mID.toString();
  //                                                 debugPrint(
  //                                                     "Selected Bank Details : ${temp[0]}");
  //                                               }
  //                                             } else {
  //                                               signupController
  //                                                   .selectedBankId.value = "";
  //                                             }
  //
  //                                             debugPrint(
  //                                                 "selected bank id ${signupController.selectedBankId.value}");
  //                                           },
  //                                           dropdownSearchData:
  //                                               DropdownSearchData(
  //                                             searchController: signupController
  //                                                 .serachBankController.value,
  //                                             searchInnerWidgetHeight: 50,
  //                                             searchInnerWidget: Container(
  //                                               padding:
  //                                                   const EdgeInsets.all(10),
  //                                               decoration: BoxDecoration(
  //                                                 border: Border.all(
  //                                                     color: Colors
  //                                                         .deepOrange.shade500),
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(15),
  //                                               ),
  //                                               child: TextFormField(
  //                                                 controller: signupController
  //                                                     .serachBankController
  //                                                     .value,
  //                                                 textAlignVertical:
  //                                                     TextAlignVertical.center,
  //                                                 onChanged: (value) {
  //                                                   signupController
  //                                                       .filterBanks(value);
  //                                                   // if (value.trim().isNotEmpty) {
  //                                                   //   signupController.filterBankList.value = signupController.bankList
  //                                                   //       .where((bank) => bank.toLowerCase().contains(value.toLowerCase()))
  //                                                   //       .toList();
  //                                                   // } else {
  //                                                   //   signupController.filterBankList.value = signupController.bankList;
  //                                                   // }
  //                                                 },
  //                                                 decoration: InputDecoration(
  //                                                   contentPadding:
  //                                                       const EdgeInsets
  //                                                           .symmetric(
  //                                                           horizontal: 8),
  //                                                   hintText: 'Search',
  //                                                   isDense: true,
  //                                                   border:
  //                                                       const OutlineInputBorder(
  //                                                     borderSide: BorderSide(
  //                                                         color: Color(
  //                                                             0xff7A7A7A)),
  //                                                   ),
  //                                                   suffixIcon: Icon(
  //                                                     Icons.search,
  //                                                     color: Colors
  //                                                         .deepOrange.shade500,
  //                                                     size: 30,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           onMenuStateChange: (isOpen) {
  //                                             debugPrint("Is Menu ${isOpen}");
  //                                             signupController
  //                                                 .serachBankController.value
  //                                                 .clear();
  //                                             if (isOpen == false) {
  //                                               signupController.filterBankList
  //                                                   .clear();
  //                                               // signupController.filterBankList.addAll(signupController.bankList);
  //                                             }
  //                                           },
  //                                           items: signupController
  //                                                   .filterBankList.isNotEmpty
  //                                               ? signupController
  //                                                   .filterBankList
  //                                                   .map(
  //                                                     (items) =>
  //                                                         DropdownMenuItem(
  //                                                       value: items,
  //                                                       child: Text(
  //                                                         items,
  //                                                         style:
  //                                                             const TextStyle(
  //                                                           fontSize: 14,
  //                                                           overflow:
  //                                                               TextOverflow
  //                                                                   .ellipsis,
  //                                                           color: Color(
  //                                                               0xff7A7A7A),
  //                                                           fontWeight:
  //                                                               FontWeight.w500,
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                   )
  //                                                   .toList()
  //                                               : signupController.bankList
  //                                                   .map(
  //                                                     (items) =>
  //                                                         DropdownMenuItem(
  //                                                       value: items,
  //                                                       child: Text(
  //                                                         items,
  //                                                         style:
  //                                                             const TextStyle(
  //                                                           fontSize: 14,
  //                                                           overflow:
  //                                                               TextOverflow
  //                                                                   .ellipsis,
  //                                                           color: Color(
  //                                                               0xff7A7A7A),
  //                                                           fontWeight:
  //                                                               FontWeight.w500,
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                   )
  //                                                   .toList(),
  //                                         ),
  //                                       ),
  //                                     ),
  //
  //                                     const SizedBox(height: 10),
  //
  //                                     ///Branch Name
  //                                     RichText(
  //                                       text: const TextSpan(
  //                                         children: [
  //                                           TextSpan(
  //                                             text: 'Branch Name',
  //                                             style: TextStyle(
  //                                                 fontSize: 13,
  //                                                 overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                 color: Colors.black,
  //                                                 fontWeight: FontWeight.w500),
  //                                           ),
  //                                           TextSpan(
  //                                             text: '*',
  //                                             style: TextStyle(
  //                                                 color: Colors.red,
  //                                                 fontSize: 15),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 2.5),
  //                                     TextFormField(
  //                                       style: const TextStyle(
  //                                           fontSize: 13,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           color: Colors.black,
  //                                           fontWeight: FontWeight.w500),
  //                                       inputFormatters: [
  //                                         FilteringTextInputFormatter.allow(
  //                                             RegExp(r'[a-zA-Z ]')),
  //                                       ],
  //                                       focusNode: signupController
  //                                           .branchNameFocusNode.value,
  //                                       controller:
  //                                           signupController.branchName.value,
  //                                       textAlignVertical:
  //                                           TextAlignVertical.center,
  //                                       decoration: InputDecoration(
  //                                         hintText: "Name",
  //                                         contentPadding:
  //                                             const EdgeInsets.symmetric(
  //                                                 horizontal: 8),
  //                                         filled: true,
  //                                         fillColor: Colors.white,
  //                                         border: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         focusedBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         enabledBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         // label: Text.rich(
  //                                         //   TextSpan(
  //                                         //     children: <InlineSpan>[
  //                                         //       WidgetSpan(
  //                                         //         child: Text('Branch Name',
  //                                         //             style: TextStyle(
  //                                         //                 color: signupController
  //                                         //                         .branchNameFocusNode
  //                                         //                         .value
  //                                         //                         .hasFocus
  //                                         //                     ? Color(
  //                                         //                         0xff7A7A7A)
  //                                         //                     : Color(
  //                                         //                         0xff7A7A7A))),
  //                                         //       ),
  //                                         //       const WidgetSpan(
  //                                         //         child: Text(
  //                                         //           ' *',
  //                                         //           style: TextStyle(
  //                                         //               fontSize: 13,
  //                                         //               overflow: TextOverflow
  //                                         //                   .ellipsis,
  //                                         //               color: Colors.red,
  //                                         //               fontWeight:
  //                                         //                   FontWeight.w500),
  //                                         //         ),
  //                                         //       ),
  //                                         //     ],
  //                                         //   ),
  //                                         // ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 10),
  //
  //                                     ///Account Holder Name
  //                                     RichText(
  //                                       text: const TextSpan(
  //                                         children: [
  //                                           TextSpan(
  //                                             text: 'Account Holder Name',
  //                                             style: TextStyle(
  //                                                 fontSize: 13,
  //                                                 overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                 color: Colors.black,
  //                                                 fontWeight: FontWeight.w500),
  //                                           ),
  //                                           TextSpan(
  //                                             text: '*',
  //                                             style: TextStyle(
  //                                                 color: Colors.red,
  //                                                 fontSize: 15),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 2.5),
  //                                     TextFormField(
  //                                       style: const TextStyle(
  //                                           fontSize: 13,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           color: Colors.black,
  //                                           fontWeight: FontWeight.w500),
  //                                       inputFormatters: [
  //                                         FilteringTextInputFormatter.allow(
  //                                             RegExp(r'[a-zA-Z ]')),
  //                                       ],
  //                                       focusNode: signupController
  //                                           .accountHolderNameFocusNode.value,
  //                                       controller: signupController
  //                                           .accountHolderName.value,
  //                                       textAlignVertical:
  //                                           TextAlignVertical.center,
  //                                       decoration: InputDecoration(
  //                                         hintText: "Name",
  //                                         contentPadding:
  //                                             const EdgeInsets.symmetric(
  //                                                 horizontal: 8),
  //                                         filled: true,
  //                                         fillColor: Colors.white,
  //                                         border: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         focusedBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         enabledBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         // label: Text.rich(
  //                                         //   TextSpan(
  //                                         //     children: <InlineSpan>[
  //                                         //       WidgetSpan(
  //                                         //         child: Text(
  //                                         //             'Account Holder Name',
  //                                         //             style: TextStyle(
  //                                         //                 color: signupController
  //                                         //                         .accountHolderNameFocusNode
  //                                         //                         .value
  //                                         //                         .hasFocus
  //                                         //                     ? Colors.black
  //                                         //                     : Colors
  //                                         //                         .black45)),
  //                                         //       ),
  //                                         //       const WidgetSpan(
  //                                         //         child: Text(
  //                                         //           ' *',
  //                                         //           style: TextStyle(
  //                                         //               fontSize: 13,
  //                                         //               overflow: TextOverflow
  //                                         //                   .ellipsis,
  //                                         //               color: Colors.red,
  //                                         //               fontWeight:
  //                                         //                   FontWeight.w500),
  //                                         //         ),
  //                                         //       ),
  //                                         //     ],
  //                                         //   ),
  //                                         // ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 10),
  //
  //                                     ///Account Number
  //                                     RichText(
  //                                       text: const TextSpan(
  //                                         children: [
  //                                           TextSpan(
  //                                             text: 'Account Number',
  //                                             style: TextStyle(
  //                                                 fontSize: 13,
  //                                                 overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                 color: Colors.black,
  //                                                 fontWeight: FontWeight.w500),
  //                                           ),
  //                                           TextSpan(
  //                                             text: '*',
  //                                             style: TextStyle(
  //                                                 color: Colors.red,
  //                                                 fontSize: 15),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 2.5),
  //                                     TextFormField(
  //                                       style: const TextStyle(
  //                                           fontSize: 13,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           color: Colors.black,
  //                                           fontWeight: FontWeight.w500),
  //                                       keyboardType: TextInputType.number,
  //                                       focusNode: signupController
  //                                           .accountNumberFocusNode.value,
  //                                       controller: signupController
  //                                           .accountNumber.value,
  //                                       textAlignVertical:
  //                                           TextAlignVertical.center,
  //                                       decoration: InputDecoration(
  //                                         hintText: "Number",
  //                                         contentPadding:
  //                                             const EdgeInsets.symmetric(
  //                                                 horizontal: 8),
  //                                         filled: true,
  //                                         fillColor: Colors.white,
  //                                         border: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         focusedBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         enabledBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         // label: Text.rich(
  //                                         //   TextSpan(
  //                                         //     children: <InlineSpan>[
  //                                         //       WidgetSpan(
  //                                         //         child: Text('Account Number',
  //                                         //             style: TextStyle(
  //                                         //                 color: signupController
  //                                         //                         .accountNumberFocusNode
  //                                         //                         .value
  //                                         //                         .hasFocus
  //                                         //                     ? Colors.black
  //                                         //                     : Colors
  //                                         //                         .black45)),
  //                                         //       ),
  //                                         //       const WidgetSpan(
  //                                         //         child: Text(
  //                                         //           ' *',
  //                                         //           style: TextStyle(
  //                                         //               color: Colors.red),
  //                                         //         ),
  //                                         //       ),
  //                                         //     ],
  //                                         //   ),
  //                                         // ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 10),
  //
  //                                     ///IFSC Code
  //                                     RichText(
  //                                       text: const TextSpan(
  //                                         children: [
  //                                           TextSpan(
  //                                             text: 'IFSC Code',
  //                                             style: TextStyle(
  //                                                 fontSize: 13,
  //                                                 overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                 color: Colors.black,
  //                                                 fontWeight: FontWeight.w500),
  //                                           ),
  //                                           TextSpan(
  //                                             text: '*',
  //                                             style: TextStyle(
  //                                                 color: Colors.red,
  //                                                 fontSize: 15),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 2.5),
  //                                     TextFormField(
  //                                       maxLength: 11,
  //                                       style: const TextStyle(
  //                                           fontSize: 13,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           color: Colors.black,
  //                                           fontWeight: FontWeight.w500),
  //                                       focusNode: signupController
  //                                           .ifscCodeFocusNode.value,
  //                                       controller:
  //                                           signupController.ifscCode.value,
  //                                       keyboardType: TextInputType.text,
  //                                       inputFormatters: [
  //                                         FilteringTextInputFormatter.allow(
  //                                             RegExp(r'[a-zA-Z0-9]')),
  //                                       ],
  //                                       onChanged: (value) {
  //                                         if (value.trim().length == 11) {
  //                                           validateIfscCode();
  //                                           signupController
  //                                               .ifscCodeFocusNode.value
  //                                               .unfocus();
  //                                         }
  //                                       },
  //                                       onFieldSubmitted: (value) {
  //                                         validateIfscCode();
  //                                       },
  //                                       textAlignVertical:
  //                                           TextAlignVertical.center,
  //                                       decoration: InputDecoration(
  //                                         hintText: "IFSC Code",
  //                                         contentPadding:
  //                                             const EdgeInsets.symmetric(
  //                                                 horizontal: 8),
  //                                         counterText: '',
  //                                         filled: true,
  //                                         fillColor: Colors.white,
  //                                         border: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         focusedBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         enabledBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         // label: Text.rich(
  //                                         //   TextSpan(
  //                                         //     children: <InlineSpan>[
  //                                         //       WidgetSpan(
  //                                         //         child: Text('IFSC Code',
  //                                         //             style: TextStyle(
  //                                         //                 color: signupController
  //                                         //                         .ifscCodeFocusNode
  //                                         //                         .value
  //                                         //                         .hasFocus
  //                                         //                     ? Colors.black
  //                                         //                     : Colors
  //                                         //                         .black45)),
  //                                         //       ),
  //                                         //       const WidgetSpan(
  //                                         //         child: Text(
  //                                         //           ' *',
  //                                         //           style: TextStyle(
  //                                         //               color: Colors.red),
  //                                         //         ),
  //                                         //       ),
  //                                         //     ],
  //                                         //   ),
  //                                         // ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 10),
  //
  //                                     ///Passbook image
  //                                     RichText(
  //                                       text: const TextSpan(
  //                                         children: [
  //                                           TextSpan(
  //                                             text: 'PassBook/Cancelled Cheque',
  //                                             style: TextStyle(
  //                                                 fontSize: 13,
  //                                                 overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                 color: Colors.black,
  //                                                 fontWeight: FontWeight.w500),
  //                                           ),
  //                                           TextSpan(
  //                                             text: '*',
  //                                             style: TextStyle(
  //                                                 color: Colors.red,
  //                                                 fontSize: 15),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 2.5),
  //                                     GestureDetector(
  //                                       onTap: () {
  //                                         _showCameraGalleryDialog(
  //                                             context,
  //                                             (signupController
  //                                                 .passbookShowImage));
  //                                       },
  //                                       child: Container(
  //                                         width: MediaQuery.of(context)
  //                                                 .size
  //                                                 .width /
  //                                             1,
  //                                         height: MediaQuery.of(context)
  //                                                 .size
  //                                                 .height *
  //                                             0.085,
  //                                         decoration: BoxDecoration(
  //                                           color: Colors.white,
  //                                           borderRadius:
  //                                               BorderRadius.circular(10.0),
  //                                           border: Border.all(
  //                                             color: Colors.black45,
  //                                             style: BorderStyle.solid,
  //                                           ),
  //                                           boxShadow: const [
  //                                             BoxShadow(
  //                                               color: Colors.white,
  //                                               offset: Offset(0, 0),
  //                                               blurRadius: 1.0,
  //                                               spreadRadius: 1.0,
  //                                             ),
  //                                           ],
  //                                         ),
  //                                         child: Row(
  //                                           children: [
  //                                             const SizedBox(
  //                                               width: 20,
  //                                             ),
  //                                             Obx(() {
  //                                               return signupController
  //                                                       .passbookImageBase64
  //                                                       .value
  //                                                       .isNotEmpty
  //                                                   ? Image.memory(
  //                                                       base64Decode(
  //                                                           signupController
  //                                                               .passbookImageBase64
  //                                                               .value),
  //                                                       width:
  //                                                           75, // Adjust the width as required
  //                                                       height:
  //                                                           80, // Adjust the height as required
  //                                                     )
  //                                                   : Image.asset(
  //                                                       "assets/images/snapShortImage.png",
  //                                                       height:
  //                                                           MediaQuery.sizeOf(
  //                                                                       context)
  //                                                                   .height *
  //                                                               0.05,
  //                                                     );
  //                                             }),
  //                                             const SizedBox(
  //                                               width: 10,
  //                                             ),
  //                                             Expanded(
  //                                                 child: Row(
  //                                               mainAxisAlignment:
  //                                                   MainAxisAlignment.center,
  //                                               children: [
  //                                                 RichText(
  //                                                   text: const TextSpan(
  //                                                     children: [
  //                                                       TextSpan(
  //                                                         text:
  //                                                             'Passbook  \n Cancel Cheque',
  //                                                         style: TextStyle(
  //                                                             fontSize: 13,
  //                                                             overflow:
  //                                                                 TextOverflow
  //                                                                     .ellipsis,
  //                                                             color:
  //                                                                 Colors.black,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .w500),
  //                                                       ),
  //                                                       TextSpan(
  //                                                         text: '*',
  //                                                         style: TextStyle(
  //                                                             color: Colors.red,
  //                                                             fontSize: 15),
  //                                                       ),
  //                                                     ],
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ))
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //
  //                                     ///btn
  //                                     const SizedBox(height: 10),
  //                                     Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.center,
  //                                       children: [
  //                                         InkWell(
  //                                           onTap: () {
  //                                             bool validate =
  //                                                 validateSixthStage();
  //                                             if (validate) {
  //                                               debugPrint("Validated 6");
  //                                               setState(() {
  //                                                 signupController
  //                                                     .signupSteeperCurrentPage
  //                                                     .value = 6;
  //                                               });
  //                                             }
  //                                           },
  //                                           child: Container(
  //                                             width: MediaQuery.of(context)
  //                                                     .size
  //                                                     .width /
  //                                                 3,
  //                                             height: MediaQuery.of(context)
  //                                                     .size
  //                                                     .height *
  //                                                 0.065,
  //                                             padding: const EdgeInsets.all(10),
  //                                             decoration: BoxDecoration(
  //                                               borderRadius:
  //                                                   BorderRadius.circular(40),
  //                                               gradient: const LinearGradient(
  //                                                   colors: [
  //                                                     Color(0xFFFF9B55),
  //                                                     Color(0xFFE15D29)
  //                                                   ],
  //                                                   begin: Alignment.topCenter,
  //                                                   stops: [
  //                                                     0.4,
  //                                                     30.0,
  //                                                   ],
  //                                                   end:
  //                                                       Alignment.bottomCenter),
  //                                             ),
  //                                             child: Align(
  //                                               alignment: Alignment.center,
  //                                               child: Text(
  //                                                 "Next",
  //                                                 style: TextStyle(
  //                                                     color: Colors.white,
  //                                                     fontSize: 16),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         )
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ]),
  //                         )),
  //                   ),
  //                 ])));
  //   });
  // } // 6

  // bool validateSixthStage() {
  //   if (signupController.selectedBank.value.isEmpty ||
  //       signupController.selectedBank.value == "Select Bank") {
  //     MyToast.myShowToast("Please select Bank");
  //     return false;
  //   }
  //
  //   if (signupController.branchName.value.text.trim().isEmpty) {
  //     signupController.branchNameFocusNode.value.requestFocus();
  //     MyToast.myShowToast("Please enter Branch Name");
  //     return false;
  //   }
  //
  //   if (signupController.accountHolderName.value.text.trim().isEmpty) {
  //     signupController.accountHolderNameFocusNode.value.requestFocus();
  //     MyToast.myShowToast("Please enter Account Holder Name");
  //     return false;
  //   }
  //   if (signupController.accountNumber.value.text.trim().isEmpty ||
  //       !signupController.accountNumber.value.text.trim().isNumericOnly) {
  //     signupController.accountNumberFocusNode.value.requestFocus();
  //     MyToast.myShowToast("Please enter Account Number");
  //     return false;
  //   }
  //
  //   if (signupController.ifscCode.value.text.trim().isEmpty ||
  //       signupController.ifscCode.value.text.trim().length != 11) {
  //     signupController.ifscCodeFocusNode.value.requestFocus();
  //     MyToast.myShowToast("Please enter IFSC Code");
  //     return false;
  //   }
  //
  //   RegExp ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
  //   if (!ifscRegex
  //       .hasMatch(signupController.ifscCode.value.text.trim().toUpperCase())) {
  //     MyToast.myShowToast("Please enter valid IFSC Code");
  //     signupController.ifscCode.value.clear();
  //
  //     return false;
  //   }
  //
  //   if (signupController.passbookImageBase64.value.isEmpty) {
  //     // signupController.nomineeNameFocusNode.value.requestFocus();
  //     MyToast.myShowToast("Please upload Passbook/Cancel Cheque photo");
  //     return false;
  //   }
  //
  //   return true;
  // }

  ///SeventhStage

  // buildSeventhStage() {
  //   TextEditingController deptStateSearchController = TextEditingController();
  //   TextEditingController businessUnitSearchController =
  //       TextEditingController();
  //   return Obx(() {
  //     return signupController.masterList.isEmpty
  //         ? SizedBox(
  //             height: MediaQuery.of(context).size.height,
  //             width: MediaQuery.of(context).size.width,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 CircularProgressIndicator(
  //                   color: Colors.deepOrange.shade500,
  //                 ),
  //                 const SizedBox(height: 10),
  //                 const Text(
  //                   "Please wait while form is loading",
  //                   style: TextStyle(fontSize: 15),
  //                 )
  //               ],
  //             ),
  //           )
  //         : SingleChildScrollView(
  //             scrollDirection: Axis.vertical,
  //             child: Container(
  //                 height: MediaQuery.of(context).size.height,
  //                 width: MediaQuery.of(context).size.width,
  //                 color: Colors.white,
  //                 child: Stack(children: [
  //                   Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     height: MediaQuery.of(context).size.height * 0.18,
  //                     decoration: const BoxDecoration(
  //                       borderRadius:
  //                           BorderRadius.vertical(bottom: Radius.circular(16)),
  //                       gradient: LinearGradient(
  //                           colors: [Color(0xFFFF9B55), Color(0xFFE15D29)],
  //                           begin: Alignment.topCenter,
  //                           stops: [
  //                             0.4,
  //                             30.0,
  //                           ],
  //                           end: Alignment.bottomCenter),
  //                     ),
  //                     child: SafeArea(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         children: [
  //                           Image.asset(
  //                             "assets/images/abhi_logo.png",
  //                             height: MediaQuery.sizeOf(context).height * 0.08,
  //                             width: MediaQuery.sizeOf(context).width,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     child: Container(
  //                       child: IconButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               signupController
  //                                   .signupSteeperCurrentPage.value = 5;
  //                             });
  //                           },
  //                           icon: const Icon(Icons.arrow_back)),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     top: MediaQuery.sizeOf(context).height * 0.13,
  //                     left: 0,
  //                     right: 0,
  //                     child: Container(
  //                         padding: EdgeInsets.symmetric(
  //                             horizontal:
  //                                 MediaQuery.sizeOf(context).width * 0.04,
  //                             vertical:
  //                                 MediaQuery.sizeOf(context).height * 0.015),
  //                         margin: EdgeInsets.symmetric(
  //                             horizontal:
  //                                 MediaQuery.sizeOf(context).width * 0.03),
  //                         decoration: BoxDecoration(
  //                             color: const Color(0xFFFFEFE6),
  //                             borderRadius: BorderRadius.circular(12)),
  //                         width: MediaQuery.sizeOf(context).width,
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 SizedBox(
  //                                   width: MediaQuery.of(context).size.width,
  //                                   child: const Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.center,
  //                                     children: [
  //                                       Text(
  //                                         "Fill Basic Details",
  //                                         style: TextStyle(
  //                                             fontWeight: FontWeight.w500,
  //                                             color: Colors.black,
  //                                             fontSize: 25),
  //                                       ),
  //                                       SizedBox(height: 5),
  //                                       Text("Create your Account",
  //                                           style: TextStyle(
  //                                               fontSize: 15,
  //                                               color: Colors.black45)),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 showRemark(),
  //                                 const SizedBox(height: 30),
  //                                 Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       "Nominee Details",
  //                                       style: TextStyle(
  //                                           fontSize: 16,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           color: Colors.black,
  //                                           fontWeight: FontWeight.w500),
  //                                     ),
  //                                     const SizedBox(height: 2.5),
  //                                     Divider(
  //                                       color: Color(0xffFF9B55),
  //                                       thickness: 1,
  //                                     ),
  //                                     const SizedBox(height: 10),
  //
  //                                     ///Nominee Name
  //                                     RichText(
  //                                       text: const TextSpan(
  //                                         children: [
  //                                           TextSpan(
  //                                             text: 'Nominee Name',
  //                                             style: TextStyle(
  //                                                 fontSize: 13,
  //                                                 overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                 color: Colors.black,
  //                                                 fontWeight: FontWeight.w500),
  //                                           ),
  //                                           TextSpan(
  //                                             text: '*',
  //                                             style: TextStyle(
  //                                                 color: Colors.red,
  //                                                 fontSize: 15),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 2.5),
  //                                     TextFormField(
  //                                       style: const TextStyle(
  //                                           fontSize: 13,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           color: Colors.black,
  //                                           fontWeight: FontWeight.w500),
  //                                       focusNode: signupController
  //                                           .nomineeNameFocusNode.value,
  //                                       inputFormatters: [
  //                                         FilteringTextInputFormatter.allow(
  //                                             RegExp(r'[a-zA-Z ]')),
  //                                       ],
  //                                       controller:
  //                                           signupController.nomineeName.value,
  //                                       textAlignVertical:
  //                                           TextAlignVertical.center,
  //                                       decoration: InputDecoration(
  //                                         hintText: "Name",
  //                                         contentPadding:
  //                                             const EdgeInsets.symmetric(
  //                                                 horizontal: 8),
  //                                         filled: true,
  //                                         fillColor: Colors.white,
  //                                         border: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         focusedBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         enabledBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         // label: Text.rich(
  //                                         //   TextSpan(
  //                                         //     children: <InlineSpan>[
  //                                         //       WidgetSpan(
  //                                         //         child: Text('Nominee Name',
  //                                         //             style: TextStyle(
  //                                         //                 color: signupController
  //                                         //                         .nomineeNameFocusNode
  //                                         //                         .value
  //                                         //                         .hasFocus
  //                                         //                     ? Colors.black
  //                                         //                     : Colors
  //                                         //                         .black45)),
  //                                         //       ),
  //                                         //       const WidgetSpan(
  //                                         //         child: Text(
  //                                         //           ' *',
  //                                         //           style: TextStyle(
  //                                         //               color: Colors.red),
  //                                         //         ),
  //                                         //       ),
  //                                         //     ],
  //                                         //   ),
  //                                         // ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 10),
  //
  //                                     ///Nominee Contact Number
  //                                     RichText(
  //                                       text: const TextSpan(
  //                                         children: [
  //                                           TextSpan(
  //                                             text: 'Nominee Contact Number',
  //                                             style: TextStyle(
  //                                                 fontSize: 13,
  //                                                 overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                 color: Colors.black,
  //                                                 fontWeight: FontWeight.w500),
  //                                           ),
  //                                           TextSpan(
  //                                             text: '*',
  //                                             style: TextStyle(
  //                                                 color: Colors.red,
  //                                                 fontSize: 15),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 2.5),
  //                                     TextFormField(
  //                                       style: const TextStyle(
  //                                           fontSize: 13,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           color: Colors.black,
  //                                           fontWeight: FontWeight.w500),
  //                                       maxLength: 10,
  //                                       focusNode: signupController
  //                                           .nomineeContactNumberFocusNode
  //                                           .value,
  //                                       controller: signupController
  //                                           .nomineeContactNumber.value,
  //                                       keyboardType: TextInputType.number,
  //                                       onChanged: (value) {
  //                                         if (value.length == 10) {
  //                                           signupController
  //                                               .nomineeContactNumberFocusNode
  //                                               .value
  //                                               .unfocus();
  //                                         }
  //                                       },
  //                                       textAlignVertical:
  //                                           TextAlignVertical.center,
  //                                       decoration: InputDecoration(
  //                                         hintText: "Number",
  //                                         contentPadding:
  //                                             const EdgeInsets.symmetric(
  //                                                 horizontal: 8),
  //                                         counterText: '',
  //                                         filled: true,
  //                                         fillColor: Colors.white,
  //                                         border: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         focusedBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         enabledBorder: OutlineInputBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             borderSide: const BorderSide(
  //                                                 color: Color(0xFFFFC59D),
  //                                                 width: 1)),
  //                                         // label: Text.rich(
  //                                         //   TextSpan(
  //                                         //     children: <InlineSpan>[
  //                                         //       WidgetSpan(
  //                                         //         child: Text(
  //                                         //             'Nominee Contact Number',
  //                                         //             style: TextStyle(
  //                                         //                 color: signupController
  //                                         //                         .nomineeContactNumberFocusNode
  //                                         //                         .value
  //                                         //                         .hasFocus
  //                                         //                     ? Colors.black
  //                                         //                     : Colors
  //                                         //                         .black45)),
  //                                         //       ),
  //                                         //       const WidgetSpan(
  //                                         //         child: Text(
  //                                         //           ' *',
  //                                         //           style: TextStyle(
  //                                         //               color: Colors.red),
  //                                         //         ),
  //                                         //       ),
  //                                         //     ],
  //                                         //   ),
  //                                         // ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 10),
  //
  //                                     ///Nominee relation
  //                                     RichText(
  //                                       text: const TextSpan(
  //                                         children: [
  //                                           TextSpan(
  //                                             text: 'Select Nominee Relation',
  //                                             style: TextStyle(
  //                                                 fontSize: 13,
  //                                                 overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                 color: Colors.black,
  //                                                 fontWeight: FontWeight.w500),
  //                                           ),
  //                                           TextSpan(
  //                                             text: '*',
  //                                             style: TextStyle(
  //                                                 color: Colors.red,
  //                                                 fontSize: 15),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 2.5),
  //                                     Container(
  //                                       padding: const EdgeInsets.only(left: 7),
  //                                       decoration: BoxDecoration(
  //                                           border: Border.all(
  //                                               color: Color(0xffFFC59D)),
  //                                           color: Colors.white,
  //                                           borderRadius:
  //                                               BorderRadius.circular(10)),
  //                                       child: DropdownButton(
  //                                         value: signupController
  //                                             .selectedNomineeRelation.value,
  //                                         isExpanded: true,
  //                                         underline: Container(),
  //                                         onChanged: (selected) {
  //                                           signupController
  //                                               .selectedNomineeRelation
  //                                               .value = selected!;
  //                                         },
  //                                         items: [
  //                                           "Select Nominee Relation",
  //                                           "Father",
  //                                           "Mother",
  //                                           "Husband",
  //                                           "Wife",
  //                                           "Brother",
  //                                           "Sister",
  //                                           "Other"
  //                                         ].map((items) {
  //                                           return DropdownMenuItem(
  //                                               value: items,
  //                                               child: Text(items,
  //                                                   style: const TextStyle(
  //                                                       fontSize: 13,
  //                                                       overflow: TextOverflow
  //                                                           .ellipsis,
  //                                                       color:
  //                                                           Color(0xff7A7A7A),
  //                                                       fontWeight:
  //                                                           FontWeight.w500)));
  //                                         }).toList(),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 16),
  //                                     /* const SizedBox(height: 16),
  //                                     Column(
  //                                       crossAxisAlignment: CrossAxisAlignment.start,
  //                                       children: [
  //                                         Text(
  //                                           "Branch Code Details",
  //                                           style: TextStyle(
  //                                               fontSize: 16,
  //                                               overflow: TextOverflow.ellipsis,
  //                                               color: Colors.black,
  //                                               fontWeight: FontWeight.w500),
  //                                         ),
  //                                         const SizedBox(height: 2.5),
  //                                         Divider(
  //                                           color: Color(0xffFF9B55),
  //                                           thickness: 1,
  //                                         ),
  //                                         const SizedBox(height: 10),
  //                                         */
  //                                     /* Container(
  //                                                          decoration: BoxDecoration(
  //                                                              border: Border.all(color: Colors.black45),
  //                                                              color: Colors.white,
  //                                                              borderRadius: BorderRadius.circular(10)),
  //                                                          child: DropdownButton2(
  //                                                            focusNode:
  //                                                            signupController.userStateFocusNode.value,
  //                                                            isExpanded: true,
  //                                                            dropdownSearchData: DropdownSearchData(
  //                                                                searchController: stateSearchController,
  //                                                                searchInnerWidgetHeight: 50,
  //                                                                searchInnerWidget: Container(
  //                                                                  padding: const EdgeInsets.all(10),
  //                                                                  decoration: BoxDecoration(
  //                                                                    // border: Border.all(color: Colors.deepOrange.shade500),
  //                                                                      borderRadius: BorderRadius.circular(15)),
  //                                                                  child: TextFormField(
  //                                                                    controller: stateSearchController,
  //                                                                     textAlignVertical: TextAlignVertical.center,
  //                                                               decoration: InputDecoration(
  //                                                                 contentPadding:
  //                                                                     EdgeInsets.symmetric(horizontal: 8),
  //
  //                                                                        hintText: 'Search',
  //                                                                        isDense: true,
  //                                                                        border: const OutlineInputBorder(
  //                                                                            borderSide: BorderSide(
  //                                                                                color: Colors.black45)),
  //                                                                        suffixIcon: Icon(
  //                                                                          Icons.search,
  //                                                                          color: Colors.deepOrange.shade500,
  //                                                                          size: 30,
  //                                                                        )),
  //                                                                  ),
  //                                                                )),
  //                                                            onMenuStateChange: ((isOpen) {
  //                                                              stateSearchController.clear();
  //                                                              setState(() {});
  //                                                            }),
  //                                                            value: signupController.userState.value,
  //                                                            underline: Container(),
  //                                                            onChanged: (selected) {
  //                                                              signupController.userState.value = selected!;
  //                                                              signupController.cityList.clear();
  //                                                              var temp = <MasterResponse>[];
  //                                                              temp.add(signupController.masterList.firstWhere(
  //                                                                      (element) => element.mName == selected));
  //                                                              signupController.stateId.value = temp[0].mID;
  //                                                              signupController.getCity();
  //                                                              signupController.userCity.value = "Select City";
  //                                                              setState(() {});
  //                                                            },
  //                                                            items: signupController.stateList
  //                                                                .toSet()
  //                                                                .toList()
  //                                                                .map((item) {
  //                                                              return DropdownMenuItem(
  //                                                                  value: item,
  //                                                                  child: Text(
  //                                                                    item,
  //                                                                    style:
  //                                                                    const TextStyle(color: Colors.black45),
  //                                                                  ));
  //                                                            }).toList(),
  //                                                            iconStyleData: const IconStyleData(
  //                                                                icon: Icon(
  //                                                                  Icons.arrow_drop_down,
  //                                                                )),
  //                                                          ),
  //                                                        ), */
  //                                     /*
  //                                         RichText(
  //                                           text: const TextSpan(
  //                                             children: [
  //                                               TextSpan(
  //                                                 text: 'Select Your Business',
  //                                                 style: TextStyle(
  //                                                     fontSize: 13,
  //                                                     overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                     color: Colors.black,
  //                                                     fontWeight: FontWeight.w500),
  //                                               ),
  //                                               TextSpan(
  //                                                 text: '*',
  //                                                 style: TextStyle(
  //                                                     color: Colors.red,
  //                                                     fontSize: 15),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 2.5),
  //                                         Container(
  //                                           padding: const EdgeInsets.only(left: 7),
  //                                           decoration: BoxDecoration(
  //                                               border: Border.all(
  //                                                   color: Color(0xffFFC59D)),
  //                                               color: Colors.white,
  //                                               borderRadius:
  //                                               BorderRadius.circular(10)),
  //                                           child: DropdownButton(
  //                                             isExpanded: true,
  //                                             underline: Container(),
  //                                             value: signupController.selectedBusiness.value,
  //                                             onChanged: (selected) {
  //                                               setState(() {
  //                                                 signupController.departmentList.clear();
  //
  //                                                 signupController.selectedBusiness.value =
  //                                                 selected!;
  //                                                 if (selected != "Select your Business") {
  //                                                   var temp = <MasterResponse>[];
  //                                                   temp.add(signupController.masterList
  //                                                       .firstWhere((element) =>
  //                                                   element.mName == selected &&
  //                                                       element.mTypeID == 117));
  //                                                   signupController.selectedBusinessId.value =
  //                                                       temp[0].mID.toString();
  //
  //                                                   debugPrint(
  //                                                       "business id ${signupController.selectedBusinessId.value}");
  //                                                 }
  //
  //                                                 signupController.getDepartmentList();
  //                                                 signupController.selectedDepartment.value =
  //                                                 "Select your Department";
  //                                                 signupController.selectedDepartmentState.value =
  //                                                 "Select your State";
  //                                                 signupController.selectedBusinessUnit.value =
  //                                                 "Select your Business Unit";
  //                                               });
  //                                             },
  //                                             items: signupController.businessList
  //                                                 .toSet()
  //                                                 .toList()
  //                                                 .map((items) {
  //                                               return DropdownMenuItem(
  //                                                   value: items,
  //                                                   child: Text(items,
  //                                                       style: const TextStyle(
  //                                                           fontSize: 13,
  //                                                           overflow: TextOverflow
  //                                                               .ellipsis,
  //                                                           color:
  //                                                           Color(0xff7A7A7A),
  //                                                           fontWeight:
  //                                                           FontWeight.w500)));
  //                                             }).toList(),
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 15),
  //                                         RichText(
  //                                           text: const TextSpan(
  //                                             children: [
  //                                               TextSpan(
  //                                                 text: 'Select Your Department',
  //                                                 style: TextStyle(
  //                                                     fontSize: 13,
  //                                                     overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                     color: Colors.black,
  //                                                     fontWeight: FontWeight.w500),
  //                                               ),
  //                                               TextSpan(
  //                                                 text: '*',
  //                                                 style: TextStyle(
  //                                                     color: Colors.red,
  //                                                     fontSize: 15),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 2.5),
  //                                         Container(
  //                                           padding: const EdgeInsets.only(left: 7),
  //                                           decoration: BoxDecoration(
  //                                               border: Border.all(
  //                                                   color: Color(0xffFFC59D)),
  //                                               color: Colors.white,
  //                                               borderRadius:
  //                                               BorderRadius.circular(10)),
  //                                           child: DropdownButton(
  //                                             isExpanded: true,
  //                                             underline: Container(),
  //                                             value: signupController.selectedDepartment.value,
  //                                             onChanged: (selected) {
  //                                               setState(() {
  //                                                 signupController.departmentStateList.clear();
  //                                                 signupController.selectedDepartment.value =
  //                                                 selected!;
  //                                                 if (selected != "Select your Department") {
  //                                                   var temp = <MasterResponse>[];
  //                                                   temp.add(signupController.masterList
  //                                                       .firstWhere((element) =>
  //                                                   element.mName == selected &&
  //                                                       element.mParentID.toString() ==
  //                                                           signupController
  //                                                               .selectedBusinessId.value));
  //                                                   signupController.selectedDepartmentId.value =
  //                                                       temp[0].mID.toString();
  //                                                 }
  //                                                 signupController.getDepartmentStateList();
  //                                                 signupController.selectedDepartmentState.value =
  //                                                 "Select your State";
  //                                                 signupController.selectedBusinessUnit.value =
  //                                                 "Select your Business Unit";
  //                                                 debugPrint(
  //                                                     "dept id ${signupController.selectedDepartmentId.value}");
  //                                               });
  //                                             },
  //                                             items: signupController.departmentList
  //                                                 .toSet()
  //                                                 .toList()
  //                                                 .map((items) {
  //                                               return DropdownMenuItem(
  //                                                   value: items,
  //                                                   child: Text(items,
  //                                                       style: const TextStyle(
  //                                                           fontSize: 13,
  //                                                           overflow: TextOverflow
  //                                                               .ellipsis,
  //                                                           color:
  //                                                           Color(0xff7A7A7A),
  //                                                           fontWeight:
  //                                                           FontWeight.w500)));
  //                                             }).toList(),
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 15),
  //                                         RichText(
  //                                           text: const TextSpan(
  //                                             children: [
  //                                               TextSpan(
  //                                                 text: 'Select Your State',
  //                                                 style: TextStyle(
  //                                                     fontSize: 13,
  //                                                     overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                     color: Colors.black,
  //                                                     fontWeight: FontWeight.w500),
  //                                               ),
  //                                               TextSpan(
  //                                                 text: '*',
  //                                                 style: TextStyle(
  //                                                     color: Colors.red,
  //                                                     fontSize: 15),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 2.5),
  //                                         Container(
  //                                           // padding: const EdgeInsets.only(left: 7),
  //                                           decoration: BoxDecoration(
  //                                               border: Border.all(
  //                                                   color: Color(0xffFFC59D)),
  //                                               color: Colors.white,
  //                                               borderRadius:
  //                                               BorderRadius.circular(10)),
  //                                           child: DropdownButton2(
  //                                             value:
  //                                             signupController.selectedDepartmentState.value,
  //                                             underline: Container(),
  //                                             menuItemStyleData: MenuItemStyleData(
  //                                               padding: EdgeInsets.symmetric(horizontal: 8)
  //                                             ),
  //                                             isExpanded: true,
  //                                             dropdownSearchData: DropdownSearchData(
  //                                                 searchController: deptStateSearchController,
  //                                                 searchInnerWidgetHeight: 50,
  //                                                 searchInnerWidget: Container(
  //                                                   padding: const EdgeInsets.all(10),
  //                                                   decoration: BoxDecoration(
  //                                                     // border: Border.all(color: Colors.deepOrange.shade500),
  //                                                       borderRadius: BorderRadius.circular(15)),
  //                                                   child: TextFormField(
  //                                                     controller: deptStateSearchController,
  //                                                     textAlignVertical: TextAlignVertical.center,
  //                                                     decoration: InputDecoration(
  //                                                         contentPadding:
  //                                                         const EdgeInsets.symmetric(
  //                                                             horizontal: 8),
  //                                                         hintText: 'Search',
  //                                                         isDense: true,
  //                                                         border: const OutlineInputBorder(
  //                                                             borderSide: BorderSide(
  //                                                                 color: Colors.black45)),
  //                                                         suffixIcon: Icon(
  //                                                           Icons.search,
  //                                                           color: Colors.deepOrange.shade500,
  //                                                           size: 30,
  //                                                         )),
  //                                                   ),
  //                                                 )),
  //                                             onMenuStateChange: ((isOpen) {
  //                                               deptStateSearchController.clear();
  //                                               setState(() {});
  //                                             }),
  //                                             onChanged: (selected) {
  //                                               signupController.businessUnitList.clear();
  //                                               signupController.selectedDepartmentState.value =
  //                                               selected!;
  //                                               signupController.selectedBusinessUnit.value =
  //                                               "Select your Business Unit";
  //
  //                                               if (selected != "Select your State") {
  //                                                 var temp = <MasterResponse>[];
  //                                                 temp.add(signupController.masterList.firstWhere(
  //                                                         (element) =>
  //                                                     element.mName == selected &&
  //                                                         element.mParentID.toString() ==
  //                                                             signupController
  //                                                                 .selectedDepartmentId.value));
  //                                                 signupController.selectedDepartmentStateId
  //                                                     .value = temp[0].mID.toString();
  //                                               }
  //                                               signupController.getBusinessUnitList();
  //                                               signupController.selectedBusinessUnit.value =
  //                                               "Select your Business Unit";
  //                                               debugPrint(
  //                                                   "state id ${signupController.selectedDepartmentStateId.value}");
  //                                             },
  //                                             items: signupController.departmentStateList
  //                                                 .toSet()
  //                                                 .toList()
  //                                                 .map((items) {
  //                                               return DropdownMenuItem(
  //                                                   value: items,
  //                                                   child: Text(items,
  //                                                       style: const TextStyle(
  //                                                           fontSize: 13,
  //                                                           overflow: TextOverflow
  //                                                               .ellipsis,
  //                                                           color:
  //                                                           Color(0xff7A7A7A),
  //                                                           fontWeight:
  //                                                           FontWeight.w500)));
  //                                             }).toList(),
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 15),
  //                                         RichText(
  //                                           text: const TextSpan(
  //                                             children: [
  //                                               TextSpan(
  //                                                 text: 'Select Your Business Unit',
  //                                                 style: TextStyle(
  //                                                     fontSize: 13,
  //                                                     overflow:
  //                                                     TextOverflow.ellipsis,
  //                                                     color: Colors.black,
  //                                                     fontWeight: FontWeight.w500),
  //                                               ),
  //                                               TextSpan(
  //                                                 text: '*',
  //                                                 style: TextStyle(
  //                                                     color: Colors.red,
  //                                                     fontSize: 15),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 2.5),
  //                                         Container(
  //                                           // padding: const EdgeInsets.only(left: 7),
  //                                           decoration: BoxDecoration(
  //                                               border: Border.all(
  //                                                   color: Color(0xffFFC59D)),
  //                                               color: Colors.white,
  //                                               borderRadius:
  //                                               BorderRadius.circular(10)),
  //                                           child: DropdownButton2(
  //                                             value: signupController.selectedBusinessUnit.value,
  //                                             underline: Container(),
  //                                             isExpanded: true,
  //                                             menuItemStyleData: MenuItemStyleData(
  //                                                 padding: EdgeInsets.symmetric(horizontal: 8)
  //                                             ),
  //                                             dropdownSearchData: DropdownSearchData(
  //                                                 searchController: businessUnitSearchController,
  //                                                 searchInnerWidgetHeight: 50,
  //                                                 searchInnerWidget: Container(
  //                                                   padding: const EdgeInsets.all(10),
  //                                                   decoration: BoxDecoration(
  //                                                     // border: Border.all(color: Colors.deepOrange.shade500),
  //                                                       borderRadius: BorderRadius.circular(15)),
  //                                                   child: TextFormField(
  //                                                     controller: businessUnitSearchController,
  //                                                     textAlignVertical: TextAlignVertical.center,
  //                                                     decoration: InputDecoration(
  //                                                         contentPadding:
  //                                                         const EdgeInsets.symmetric(
  //                                                             horizontal: 8),
  //                                                         hintText: 'Search',
  //                                                         isDense: true,
  //                                                         border: const OutlineInputBorder(
  //                                                             borderSide: BorderSide(
  //                                                                 color: Colors.black45)),
  //                                                         suffixIcon: Icon(
  //                                                           Icons.search,
  //                                                           color: Colors.deepOrange.shade500,
  //                                                           size: 30,
  //                                                         )),
  //                                                   ),
  //                                                 )),
  //                                             onMenuStateChange: ((isOpen) {
  //                                               businessUnitSearchController.clear();
  //                                               setState(() {});
  //                                             }),
  //                                             onChanged: (selected) {
  //                                               signupController.selectedBusinessUnit.value =
  //                                               selected!;
  //                                               var temp = <MasterResponse>[];
  //                                               temp.add(signupController.masterList.firstWhere(
  //                                                       (element) =>
  //                                                   element.mName == selected &&
  //                                                       element.mParentID.toString() ==
  //                                                           signupController
  //                                                               .selectedDepartmentStateId
  //                                                               .value));
  //                                               signupController.selectedBusinessUnitId.value =
  //                                                   temp[0].mID.toString();
  //
  //                                               debugPrint(
  //                                                   "Unit id ${signupController.selectedBusinessUnitId.value}");
  //                                             },
  //                                             items: signupController.businessUnitList
  //                                                 .toSet()
  //                                                 .toList()
  //                                                 .map((items) {
  //                                               return DropdownMenuItem(
  //                                                   value: items,
  //                                                   child: Text(items,
  //                                                       style: const TextStyle(
  //                                                           fontSize: 13,
  //                                                           overflow: TextOverflow
  //                                                               .ellipsis,
  //                                                           color:
  //                                                           Color(0xff7A7A7A),
  //                                                           fontWeight:
  //                                                           FontWeight.w500)));
  //                                             }).toList(),
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 15),
  //                                         // Row(
  //                                         //   children: [
  //                                         //     Expanded(
  //                                         //       child: InkWell(
  //                                         //         onTap: () {
  //                                         //           setState(() {
  //                                         //             signupController
  //                                         //                 .signupSteeperCurrentPage.value = 1;
  //                                         //             // Get.back();
  //                                         //           });
  //                                         //         },
  //                                         //         child: Container(
  //                                         //           padding: const EdgeInsets.all(10),
  //                                         //           decoration: BoxDecoration(
  //                                         //             borderRadius: BorderRadius.circular(10),
  //                                         //             gradient: LinearGradient(
  //                                         //                 colors: [
  //                                         //                   Colors.deepOrange,
  //                                         //                   Colors.deepOrange.shade500
  //                                         //                 ],
  //                                         //                 begin: Alignment.topLeft,
  //                                         //                 end: Alignment.bottomCenter),
  //                                         //           ),
  //                                         //           child: const Row(
  //                                         //             mainAxisAlignment: MainAxisAlignment.center,
  //                                         //             crossAxisAlignment:
  //                                         //             CrossAxisAlignment.center,
  //                                         //             children: [
  //                                         //               Icon(
  //                                         //                 Icons.arrow_back,
  //                                         //                 color: Colors.white,
  //                                         //               ),
  //                                         //               SizedBox(width: 10),
  //                                         //               Text(
  //                                         //                 "Back",
  //                                         //                 style: TextStyle(
  //                                         //                     color: Colors.white, fontSize: 18),
  //                                         //               ),
  //                                         //               SizedBox(width: 10),
  //                                         //             ],
  //                                         //           ),
  //                                         //         ),
  //                                         //       ),
  //                                         //     ),
  //                                         //     const SizedBox(width: 15),
  //                                         //
  //                                         //   ],
  //                                         // )
  //                                       ],
  //                                     ),*/
  //                                     Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.center,
  //                                       children: [
  //                                         InkWell(
  //                                           onTap: () {
  //                                             bool validate =
  //                                                 validateSeventhStage();
  //                                             if (validate) {
  //                                               debugPrint("Validated 7");
  //                                               setState(() {
  //                                                 signupController
  //                                                     .signupSteeperCurrentPage
  //                                                     .value = 7;
  //                                               });
  //                                             }
  //                                           },
  //                                           child: Container(
  //                                             width: MediaQuery.of(context)
  //                                                     .size
  //                                                     .width /
  //                                                 3,
  //                                             height: MediaQuery.of(context)
  //                                                     .size
  //                                                     .height *
  //                                                 0.065,
  //                                             padding: const EdgeInsets.all(10),
  //                                             decoration: BoxDecoration(
  //                                               borderRadius:
  //                                                   BorderRadius.circular(40),
  //                                               gradient: const LinearGradient(
  //                                                   colors: [
  //                                                     Color(0xFFFF9B55),
  //                                                     Color(0xFFE15D29)
  //                                                   ],
  //                                                   begin: Alignment.topCenter,
  //                                                   stops: [
  //                                                     0.4,
  //                                                     30.0,
  //                                                   ],
  //                                                   end:
  //                                                       Alignment.bottomCenter),
  //                                             ),
  //                                             child: Align(
  //                                               alignment: Alignment.center,
  //                                               child: Text(
  //                                                 "Next",
  //                                                 style: TextStyle(
  //                                                     color: Colors.white,
  //                                                     fontSize: 16),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         )
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ]),
  //                         )),
  //                   ),
  //                 ])));
  //   });
  // } // 7

  bool validateSeventhStage() {
     if (signupController.nomineeName.value.text.trim().isEmpty  ) {
      signupController.nomineeNameFocusNode.value.requestFocus();
      MyToast.myShowToast("Please enter Nominee Name");
      return false;
    }
     if (signupController.nomineeName.value.text.trim().isEmpty ||
         signupController.nomineeName.value.text.trim() ==
             signupController.accountHolderName.value.text.trim()) {
       signupController.nomineeNameFocusNode.value.requestFocus();
       MyToast.myShowToast("Please enter valid Nominee Name, eg : Rajesh Kumar");
       return false;
     }
     // if(signupController.nomineeName.value.text.trim().isNotEmpty || signupController.nomineeName.value.text.trim() != signupController.accountHolderName.value.text.trim()){
    //   RegExp nameRegExp = RegExp(r'^[A-Za-z\s]+$');
    //
    //   if (!nameRegExp.hasMatch(signupController.nomineeName.value.text)) {
    //     signupController.nomineeNameFocusNode.value.requestFocus();
    //     MyToast.myShowToast("Please enter a valid Nominee Name (only letters allowed)");
    //     return false;
    //   }
    // }

    if (signupController.nomineeContactNumber.value.text.trim().isEmpty ||
        signupController.nomineeContactNumber.value.text
            .trim()
            .startsWith('0') ||
        signupController.nomineeContactNumber.value.text.trim().length != 10) {
      signupController.nomineeContactNumberFocusNode.value.requestFocus();
      MyToast.myShowToast("Please enter Nominee Contact Number");
      return false;
    }

    if (signupController.nomineeContactNumber.value.text.trim() ==
        signupController.signupMobileNumber.value.text.trim()) {
      MyToast.myShowToast("Nominee Number and SignUp Number can't be same");
      return false;
    }

    if (signupController.selectedNomineeRelation.value.isEmpty ||
        signupController.selectedNomineeRelation.value ==
            "Select Nominee Relation") {
      // signupController.nomineeNameFocusNode.value.requestFocus();
      MyToast.myShowToast("Please select Nominee Relation");
      return false;
    }

    // if (signupController.selectedBusiness.value.isEmpty ||
    //     signupController.selectedBusiness.value == "Select your Business") {
    //   MyToast.myShowToast("Please select your business");
    //   return false;
    // }
    //
    // if (signupController.selectedDepartment.value.isEmpty ||
    //     signupController.selectedDepartment.value == "Select your Department") {
    //   MyToast.myShowToast("Please select your department");
    //   return false;
    // }
    //
    // if (signupController.selectedDepartmentState.value.isEmpty ||
    //     signupController.selectedDepartmentState.value == "Select your State") {
    //   MyToast.myShowToast("Please select your state");
    //   return false;
    // }
    //
    // if (signupController.selectedBusinessUnit.value.trim().isEmpty ||
    //     signupController.selectedBusinessUnit.value ==
    //         "Select your Business Unit") {
    //   MyToast.myShowToast("Please select your business unit");
    //   return false;
    // }

    /*  if (signupController.designation.value.text.trim().isEmpty) {
      signupController.designationFocusNode.value.requestFocus();
      MyToast.myShowToast("Designation can't be empty");
      Navigator.pop(context);
      return false;
    }

    if (signupController.approverName.value.text.trim().isEmpty) {
      signupController.approverNameFocusNode.value.requestFocus();
      MyToast.myShowToast("Approver name can't be empty");
      Navigator.pop(context);
      return false;
    }

    if (signupController.approverEmpId.value.text.trim().isEmpty ||
        !signupController.approverEmpId.value.text.trim().isNumericOnly) {
      signupController.approverEmpIdFocusNode.value.requestFocus();
      MyToast.myShowToast("Approver Emp Id can't be empty");
      Navigator.pop(context);
      return false;
    }

    if (signupController.accountNumber.value.text.trim().isEmpty ||
        !signupController.accountNumber.value.text.trim().isNumericOnly) {
      signupController.accountNumberFocusNode.value.requestFocus();
      MyToast.myShowToast("Please Provide a valid Account Number");
      Navigator.pop(context);
      return false;
    }

    if (signupController.approverName.value.text.trim().isEmpty ||
        !signupController.approverName.value.text.trim().isNumericOnly) {
      signupController.approverNameFocusNode.value.requestFocus();
      MyToast.myShowToast("Please Provide a valid Account Number");
      Navigator.pop(context);
      return false;
    }*/

    return true;
  }

  ///EighthStage

  buildEighthStage() {
    return Obx(() {
      return signupController.masterList.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.deepOrange.shade500,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please wait while form is loading",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Stack(children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.18,
                      decoration: const BoxDecoration(
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
                            Image.asset(
                              "assets/images/abhi_logo.png",
                              height: MediaQuery.sizeOf(context).height * 0.08,
                              width: MediaQuery.sizeOf(context).width,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                signupController
                                    .signupSteeperCurrentPage.value = 6;
                              });
                            },
                            icon: const Icon(Icons.arrow_back)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.sizeOf(context).height * 0.13,
                      left: 0,
                      right: 0,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.sizeOf(context).width * 0.04,
                              vertical:
                                  MediaQuery.sizeOf(context).height * 0.015),
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.sizeOf(context).width * 0.03),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFEFE6),
                              borderRadius: BorderRadius.circular(12)),
                          width: MediaQuery.sizeOf(context).width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Fill Basic Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                        SizedBox(height: 5),
                                        Text("Create your Account",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black45)),
                                      ],
                                    ),
                                  ),
                                  showRemark(),
                                  const SizedBox(height: 30),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Health Information",
                                        style: TextStyle(
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 2.5),
                                      Divider(
                                        color: Color(0xffFF9B55),
                                        thickness: 1,
                                      ),
                                      const SizedBox(height: 15),

                                      /// Blood Group

                                      RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Blood Group',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 7),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xffFFC59D)),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Obx(() =>
                                            DropdownButton<BloodType>(
                                              value: signupController
                                                  .selectedBloodGroupList
                                                  .firstWhere(
                                                (element) =>
                                                    element.name ==
                                                    signupController
                                                        .selectedBloodGroup
                                                        .value,
                                                orElse: () => signupController
                                                    .selectedBloodGroupList
                                                    .first,
                                              ),
                                              isExpanded: true,
                                              underline: Container(),
                                              onChanged: (selected) {
                                                signupController
                                                    .selectedBloodGroup
                                                    .value = selected!.name;
                                                if (selected.name !=
                                                    "Select Blood Group") {
                                                  signupController
                                                          .selectedBloodGroupId
                                                          .value =
                                                      selected.value.toString();
                                                } else {
                                                  signupController
                                                      .selectedBloodGroupId
                                                      .value = "";
                                                }
                                                print(
                                                    " signupController.selectedBloodGroupId.value ${signupController.selectedBloodGroupId.value}");
                                              },
                                              items: signupController
                                                  .selectedBloodGroupList
                                                  .map((items) {
                                                return DropdownMenuItem<
                                                    BloodType>(
                                                  value: items,
                                                  child: Text(items.name,
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color:
                                                              Color(0xff7A7A7A),
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                );
                                              }).toList(),
                                            )),
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              bool validate =
                                                  validateEighthStage();
                                              if (validate) {
                                                debugPrint("Validated");   Dialogs.lottieLoading(context,
                                                    "assets/lottiee/abhi_loading.json");

                                                await signupController
                                                    .callSignUpSubmitApi(
                                                        context);

                                                if (signupController
                                                        .submitApiResponse
                                                        .value !=
                                                    null) {
                                                  Navigator.popUntil(
                                                    context,
                                                    (Route<dynamic> route) =>
                                                        route.isFirst,
                                                  );
                                                  if (signupController
                                                          .submitApiResponse
                                                          .value!
                                                          .insertId !=
                                                      0) {
                                                    MyToast.myShowToast(
                                                        "Successfully inserted");
                                                    signupController
                                                        .signupSteeperCurrentPage
                                                        .value = 0;
                                                    Get.offAll(
                                                        () => SignUpSuccess());
                                                  } else {
                                                    MyToast.myShowToast(
                                                        signupController
                                                            .submitApiResponse
                                                            .value!
                                                            .responseMsg);
                                                    // Get.to(const SignUpSuccess());
                                                  }
                                                }
                                                // print("after submitted");
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.065,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xFFFF9B55),
                                                      Color(0xFFE15D29)
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    stops: [
                                                      0.4,
                                                      30.0,
                                                    ],
                                                    end:
                                                        Alignment.bottomCenter),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                          )),
                    ),
                  ])));
    });
  } // 8

  bool validateEighthStage() {
    Dialogs.signUpLoading(context);

    if (signupController.selectedBloodGroup.value.isEmpty ||
        signupController.selectedBloodGroup.value == "Select Blood Group") {
      MyToast.myShowToast("Please select Blood Group");
      return false;
    }
    return true;
  }

  void _showCameraGalleryDialog(
      BuildContext context, Function(ImageSource) onTapCallback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Camera"),
                onTap: () {
                  onTapCallback(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
                onTap: () {
                  onTapCallback(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget callImageAdder(
      Rx<Uint8List?> ImageBytes, Rx<File?> SelectedImage, String title) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black45)),
      child: InkWell(
        onTap: () {
          PickImage().showImagePickerOption(ImageBytes, SelectedImage, context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            ImageBytes.value!.isEmpty
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/add-image.png'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: MemoryImage(ImageBytes.value!),
                                fit: BoxFit.fill))),
                  ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: const TextStyle(
                              fontSize: 13,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        const TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  void validateIfscCode() {
    RegExp ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!ifscRegex
        .hasMatch(signupController.ifscCode.value.text.trim().toUpperCase())) {
      MyToast.myShowToast("Please provide a valid IFSC Code");
      signupController.ifscCode.value.clear();
    }
  }

  void validatePanCard(String value) {
    RegExp reg = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!reg.hasMatch(
        signupController.userPanNumber.value.text.trim().toUpperCase())) {
      MyToast.myShowToast("please enter a valid Pan Card Number");
      signupController.userPanNumber.value.clear();
    }
    // else{
    //   MyToast.myShowToast("Valid Pan Card");
    // }
  }
  void validateVoterId(String value) {
    RegExp reg = RegExp(r'^[A-Z]{3}[0-9]{7}$');
    if (!reg.hasMatch(
        signupController.voterId.value.text.trim().toUpperCase())) {
      MyToast.myShowToast("please enter a valid Voter ID");
      signupController.voterId.value.clear();
    }
    // else{
    //   MyToast.myShowToast("Valid Pan Card");
    // }
  }
  bool validateDLNumber() {
    RegExp reg = RegExp(
        r"^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}" +
            r"|([a-zA-Z]{2}[0-9]{2}[\\/][a-zA-Z]{3}[\\/][0-9]{2}[\\/][0-9]{5})" +
            r"|([a-zA-Z]{2}[0-9]{2}(N)[\\-]{1}((19|20)[0-9][0-9])[\\-][0-9]{7})" +
            r"|([a-zA-Z]{2}[0-9]{14})" +
            r"|([a-zA-Z]{2}[\\-][0-9]{13})$");
    if (!reg.hasMatch(
        signupController.userDLNumber.value.text.trim().toUpperCase())) {
      MyToast.myShowToast("Invalid Driving License Number");
      // signupController.userDLNumber.value.clear();
      return false;
    }
    return true;
  }

  void validateDLNumber2(String dlNumber) {
    RegExp reg = RegExp(
        r"^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}" +
            r"|([a-zA-Z]{2}[0-9]{2}[\\/][a-zA-Z]{3}[\\/][0-9]{2}[\\/][0-9]{5})" +
            r"|([a-zA-Z]{2}[0-9]{2}(N)[\\-]{1}((19|20)[0-9][0-9])[\\-][0-9]{7})" +
            r"|([a-zA-Z]{2}[0-9]{14})" +
            r"|([a-zA-Z]{2}[\\-][0-9]{13})" +
            r"|([A-Z]{2}[0-9][ -_](19|20)[0-9]{2}[0-9]{7})$");

    if (!reg.hasMatch(dlNumber.toUpperCase())) {
      MyToast.myShowToast("Invalid Driving License Number");
      signupController.userDLNumber.value.clear();
    }
  }

//////////// old code commented

// buildSecondStep() {
//   return Obx(() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Column(
//         children: [
//           SizedBox(
//             width: MediaQuery.of(context).size.width,
//             // height: MediaQuery.of(context).size.height/3.5,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           signupController.signupSteeperCurrentPage.value = 0;
//                         });
//                       },
//                       icon: const Icon(Icons.arrow_back)),
//                 ),
//                 Expanded(
//                     child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       "assets/images/abhi_logo.png",
//                       height: 120,
//                       width: 200,
//                     )
//                   ],
//                 ))
//               ],
//             ),
//           ),
//           Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: SizedBox(
//                 height: 25,
//                 width: MediaQuery.of(context).size.width,
//                 child: Center(
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: stepsList().length,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       return Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.circle,
//                             color: index ==
//                                     signupController
//                                         .signupSteeperCurrentPage.value
//                                 ? Colors.deepOrange
//                                 : Colors.grey,
//                             size: index ==
//                                     signupController
//                                         .signupSteeperCurrentPage.value
//                                 ? 25
//                                 : 15,
//                           ),
//                           if (index !=
//                               4) // Add line if it's not the last circle
//                             Row(
//                               children: [
//                                 const SizedBox(width: 7),
//                                 // Adjust the spacing as needed
//                                 Container(
//                                   width: 30,
//                                   // Set the width of the horizontal line
//                                   height: 2,
//                                   // Set the height of the horizontal line
//                                   color: index ==
//                                           signupController
//                                               .signupSteeperCurrentPage.value
//                                       ? Colors.deepOrange
//                                       : Colors
//                                           .grey, // Set the color of the horizontal line
//                                 ),
//                                 const SizedBox(width: 7),
//                                 // Adjust the spacing as needed
//                               ],
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               )),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Card(
//               elevation: 10,
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Verification Details',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black, // Adjusted color
//                       ),
//                     ),
//                     Divider(
//                       color: Colors.grey.shade500,
//                       thickness: 2,
//                     ),
//                     const SizedBox(height: 15),
//                     const SizedBox(height: 15),
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       focusNode:
//                           signupController.userAadhaarNumberFocusNode.value,
//                       controller: signupController.userAadhaarNumber.value,
//                       keyboardType: TextInputType.number,
//                       onChanged: (value) {
//                         if (value.trim().length == 12) {
//                           signupController.userAadhaarNumberFocusNode.value
//                               .unfocus();
//                         }
//                       },
//                       maxLength: 12,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         hintText: 'Number',
//                         hintStyle: const TextStyle(
//                             color: Colors.black45, fontSize: 14),
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         counterText: "",
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Aadhaar Card Number',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .userAadhaarNumberFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     const SizedBox(height: 15),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 signupController
//                                     .signupSteeperCurrentPage.value = 0;
//                                 Get.back();
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: LinearGradient(
//                                     colors: [
//                                       Colors.deepOrange,
//                                       Colors.deepOrange.shade500
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomCenter),
//                               ),
//                               child: const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.arrow_back,
//                                     color: Colors.white,
//                                   ),
//                                   SizedBox(width: 10),
//                                   Text(
//                                     "Back",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 18),
//                                   ),
//                                   SizedBox(width: 10),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 15),
//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               bool validate = validateSecondStep();
//                               if (validate) {
//                                 debugPrint("Validated 2");
//                                 setState(() {
//                                   signupController
//                                       .signupSteeperCurrentPage.value = 2;
//                                 });
//                               }
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: LinearGradient(
//                                     colors: [
//                                       Colors.deepOrange,
//                                       Colors.deepOrange.shade500
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomCenter),
//                               ),
//                               child: const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Continue",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 18),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Icon(
//                                     Icons.arrow_forward,
//                                     color: Colors.white,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )
//
//           // const SizedBox(height:15),
//         ],
//       ),
//     );
//   });
// }
//
// buildThirdStep() {
//   TextEditingController deptStateSearchController = TextEditingController();
//   TextEditingController businessUnitSearchController =
//       TextEditingController();
//   return Obx(() {
//     return SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               // height: MediaQuery.of(context).size.height/3.5,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             signupController.signupSteeperCurrentPage.value =
//                                 1;
//                           });
//                         },
//                         icon: const Icon(Icons.arrow_back)),
//                   ),
//                   Expanded(
//                       child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         "assets/images/abhi_logo.png",
//                         height: 120,
//                         width: 200,
//                       )
//                     ],
//                   ))
//                 ],
//               ),
//             ),
//             Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: SizedBox(
//                   height: 25,
//                   width: MediaQuery.of(context).size.width,
//                   child: Center(
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: stepsList().length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         print("current index $index");
//                         return Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.circle,
//                               color: index ==
//                                       signupController
//                                           .signupSteeperCurrentPage.value
//                                   ? Colors.deepOrange
//                                   : Colors.grey,
//                               size: index ==
//                                       signupController
//                                           .signupSteeperCurrentPage.value
//                                   ? 25
//                                   : 15,
//                             ),
//                             if (index !=
//                                 4) // Add line if it's not the last circle
//                               Row(
//                                 children: [
//                                   const SizedBox(width: 7),
//                                   // Adjust the spacing as needed
//                                   Container(
//                                     width: 30,
//                                     // Set the width of the horizontal line
//                                     height: 2,
//                                     // Set the height of the horizontal line
//                                     color: index ==
//                                             signupController
//                                                 .signupSteeperCurrentPage
//                                                 .value
//                                         ? Colors.deepOrange
//                                         : Colors
//                                             .grey, // Set the color of the horizontal line
//                                   ),
//                                   const SizedBox(width: 7),
//                                   // Adjust the spacing as needed
//                                 ],
//                               ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 )),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Card(
//                 elevation: 10,
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Branch Code Details',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black, // Adjusted color
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.grey.shade500,
//                         thickness: 2,
//                       ),
//                       const SizedBox(height: 15),
//                       /* Container(
//                      decoration: BoxDecoration(
//                          border: Border.all(color: Colors.black45),
//                          color: Colors.white,
//                          borderRadius: BorderRadius.circular(10)),
//                      child: DropdownButton2(
//                        focusNode:
//                        signupController.userStateFocusNode.value,
//                        isExpanded: true,
//                        dropdownSearchData: DropdownSearchData(
//                            searchController: stateSearchController,
//                            searchInnerWidgetHeight: 50,
//                            searchInnerWidget: Container(
//                              padding: const EdgeInsets.all(10),
//                              decoration: BoxDecoration(
//                                // border: Border.all(color: Colors.deepOrange.shade500),
//                                  borderRadius: BorderRadius.circular(15)),
//                              child: TextFormField(
//                                controller: stateSearchController,
//                                 textAlignVertical: TextAlignVertical.center,
//                           decoration: InputDecoration(
//                             contentPadding:
//                                 EdgeInsets.symmetric(horizontal: 8),
//
//                                    hintText: 'Search',
//                                    isDense: true,
//                                    border: const OutlineInputBorder(
//                                        borderSide: BorderSide(
//                                            color: Colors.black45)),
//                                    suffixIcon: Icon(
//                                      Icons.search,
//                                      color: Colors.deepOrange.shade500,
//                                      size: 30,
//                                    )),
//                              ),
//                            )),
//                        onMenuStateChange: ((isOpen) {
//                          stateSearchController.clear();
//                          setState(() {});
//                        }),
//                        value: signupController.userState.value,
//                        underline: Container(),
//                        onChanged: (selected) {
//                          signupController.userState.value = selected!;
//                          signupController.cityList.clear();
//                          var temp = <MasterResponse>[];
//                          temp.add(signupController.masterList.firstWhere(
//                                  (element) => element.mName == selected));
//                          signupController.stateId.value = temp[0].mID;
//                          signupController.getCity();
//                          signupController.userCity.value = "Select City";
//                          setState(() {});
//                        },
//                        items: signupController.stateList
//                            .toSet()
//                            .toList()
//                            .map((item) {
//                          return DropdownMenuItem(
//                              value: item,
//                              child: Text(
//                                item,
//                                style:
//                                const TextStyle(color: Colors.black45),
//                              ));
//                        }).toList(),
//                        iconStyleData: const IconStyleData(
//                            icon: Icon(
//                              Icons.arrow_drop_down,
//                            )),
//                      ),
//                    ), */
//                       Container(
//                         padding: const EdgeInsets.only(left: 10),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black),
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: DropdownButton(
//                           isExpanded: true,
//                           underline: Container(),
//                           value: signupController.selectedBusiness.value,
//                           onChanged: (selected) {
//                             setState(() {
//                               signupController.departmentList.clear();
//
//                               signupController.selectedBusiness.value =
//                                   selected!;
//                               if (selected != "Select your Business") {
//                                 var temp = <MasterResponse>[];
//                                 temp.add(signupController.masterList
//                                     .firstWhere((element) =>
//                                         element.mName == selected &&
//                                         element.mTypeID == 117));
//                                 signupController.selectedBusinessId.value =
//                                     temp[0].mID.toString();
//
//                                 debugPrint(
//                                     "business id ${signupController.selectedBusinessId.value}");
//                               }
//
//                               signupController.getDepartmentList();
//                               signupController.selectedDepartment.value =
//                                   "Select your Department";
//                               signupController.selectedDepartmentState.value =
//                                   "Select your State";
//                               signupController.selectedBusinessUnit.value =
//                                   "Select your Business Unit";
//                             });
//                           },
//                           items: signupController.businessList
//                               .toSet()
//                               .toList()
//                               .map((items) {
//                             return DropdownMenuItem(
//                                 value: items,
//                                 child: Text(items,
//                                     style: const TextStyle(
//                                         fontSize: 13,
//                                         overflow: TextOverflow.ellipsis,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w500)));
//                           }).toList(),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Container(
//                         padding: const EdgeInsets.only(left: 10),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black),
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: DropdownButton(
//                           isExpanded: true,
//                           underline: Container(),
//                           value: signupController.selectedDepartment.value,
//                           onChanged: (selected) {
//                             setState(() {
//                               signupController.departmentStateList.clear();
//                               signupController.selectedDepartment.value =
//                                   selected!;
//                               if (selected != "Select your Department") {
//                                 var temp = <MasterResponse>[];
//                                 temp.add(signupController.masterList
//                                     .firstWhere((element) =>
//                                         element.mName == selected &&
//                                         element.mParentID.toString() ==
//                                             signupController
//                                                 .selectedBusinessId.value));
//                                 signupController.selectedDepartmentId.value =
//                                     temp[0].mID.toString();
//                               }
//                               signupController.getDepartmentStateList();
//                               signupController.selectedDepartmentState.value =
//                                   "Select your State";
//                               signupController.selectedBusinessUnit.value =
//                                   "Select your Business Unit";
//                               debugPrint(
//                                   "dept id ${signupController.selectedDepartmentId.value}");
//                             });
//                           },
//                           items: signupController.departmentList
//                               .toSet()
//                               .toList()
//                               .map((items) {
//                             return DropdownMenuItem(
//                                 value: items,
//                                 child: Text(
//                                   items,
//                                   style: const TextStyle(
//                                       fontSize: 13,
//                                       overflow: TextOverflow.ellipsis,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w500),
//                                 ));
//                           }).toList(),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Container(
//                         // padding: const EdgeInsets.only(left:10),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black),
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: DropdownButton2(
//                           value:
//                               signupController.selectedDepartmentState.value,
//                           underline: Container(),
//                           isExpanded: true,
//                           dropdownSearchData: DropdownSearchData(
//                               searchController: deptStateSearchController,
//                               searchInnerWidgetHeight: 50,
//                               searchInnerWidget: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                     // border: Border.all(color: Colors.deepOrange.shade500),
//                                     borderRadius: BorderRadius.circular(15)),
//                                 child: TextFormField(
//                                   controller: deptStateSearchController,
//                                   textAlignVertical: TextAlignVertical.center,
//                                   decoration: InputDecoration(
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 8),
//                                       hintText: 'Search',
//                                       isDense: true,
//                                       border: const OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.black45)),
//                                       suffixIcon: Icon(
//                                         Icons.search,
//                                         color: Colors.deepOrange.shade500,
//                                         size: 30,
//                                       )),
//                                 ),
//                               )),
//                           onMenuStateChange: ((isOpen) {
//                             deptStateSearchController.clear();
//                             setState(() {});
//                           }),
//                           onChanged: (selected) {
//                             signupController.businessUnitList.clear();
//                             signupController.selectedDepartmentState.value =
//                                 selected!;
//                             signupController.selectedBusinessUnit.value =
//                                 "Select your Business Unit";
//
//                             if (selected != "Select your State") {
//                               var temp = <MasterResponse>[];
//                               temp.add(signupController.masterList.firstWhere(
//                                   (element) =>
//                                       element.mName == selected &&
//                                       element.mParentID.toString() ==
//                                           signupController
//                                               .selectedDepartmentId.value));
//                               signupController.selectedDepartmentStateId
//                                   .value = temp[0].mID.toString();
//                             }
//                             signupController.getBusinessUnitList();
//                             signupController.selectedBusinessUnit.value =
//                                 "Select your Business Unit";
//                             debugPrint(
//                                 "state id ${signupController.selectedDepartmentStateId.value}");
//                           },
//                           items: signupController.departmentStateList
//                               .toSet()
//                               .toList()
//                               .map((items) {
//                             return DropdownMenuItem(
//                                 value: items,
//                                 child: Text(items,
//                                     style: const TextStyle(
//                                         fontSize: 13,
//                                         overflow: TextOverflow.ellipsis,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w500)));
//                           }).toList(),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Container(
//                         // padding: const EdgeInsets.only(left:10),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black),
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: DropdownButton2(
//                           value: signupController.selectedBusinessUnit.value,
//                           underline: Container(),
//                           isExpanded: true,
//                           dropdownSearchData: DropdownSearchData(
//                               searchController: businessUnitSearchController,
//                               searchInnerWidgetHeight: 50,
//                               searchInnerWidget: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                     // border: Border.all(color: Colors.deepOrange.shade500),
//                                     borderRadius: BorderRadius.circular(15)),
//                                 child: TextFormField(
//                                   controller: businessUnitSearchController,
//                                   textAlignVertical: TextAlignVertical.center,
//                                   decoration: InputDecoration(
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 8),
//                                       hintText: 'Search',
//                                       isDense: true,
//                                       border: const OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.black45)),
//                                       suffixIcon: Icon(
//                                         Icons.search,
//                                         color: Colors.deepOrange.shade500,
//                                         size: 30,
//                                       )),
//                                 ),
//                               )),
//                           onMenuStateChange: ((isOpen) {
//                             businessUnitSearchController.clear();
//                             setState(() {});
//                           }),
//                           onChanged: (selected) {
//                             signupController.selectedBusinessUnit.value =
//                                 selected!;
//                             var temp = <MasterResponse>[];
//                             temp.add(signupController.masterList.firstWhere(
//                                 (element) =>
//                                     element.mName == selected &&
//                                     element.mParentID.toString() ==
//                                         signupController
//                                             .selectedDepartmentStateId
//                                             .value));
//                             signupController.selectedBusinessUnitId.value =
//                                 temp[0].mID.toString();
//
//                             debugPrint(
//                                 "Unit id ${signupController.selectedBusinessUnitId.value}");
//                           },
//                           items: signupController.businessUnitList
//                               .toSet()
//                               .toList()
//                               .map((items) {
//                             return DropdownMenuItem(
//                                 value: items,
//                                 child: Text(
//                                   items,
//                                   style: const TextStyle(
//                                       fontSize: 13,
//                                       overflow: TextOverflow.ellipsis,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w500),
//                                 ));
//                           }).toList(),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   signupController
//                                       .signupSteeperCurrentPage.value = 1;
//                                   // Get.back();
//                                 });
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   gradient: LinearGradient(
//                                       colors: [
//                                         Colors.deepOrange,
//                                         Colors.deepOrange.shade500
//                                       ],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomCenter),
//                                 ),
//                                 child: const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.arrow_back,
//                                       color: Colors.white,
//                                     ),
//                                     SizedBox(width: 10),
//                                     Text(
//                                       "Back",
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 18),
//                                     ),
//                                     SizedBox(width: 10),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 bool validate = validateThirdStep();
//                                 if (validate) {
//                                   setState(() {
//                                     signupController
//                                         .signupSteeperCurrentPage.value = 3;
//                                   });
//                                 }
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   gradient: LinearGradient(
//                                       colors: [
//                                         Colors.deepOrange,
//                                         Colors.deepOrange.shade500
//                                       ],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomCenter),
//                                 ),
//                                 child: const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "Continue",
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 18),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Icon(
//                                       Icons.arrow_forward,
//                                       color: Colors.white,
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ));
//   });
// }
//
// buildForthStep() {
//   Color textFieldBg = Colors.black;
//   TextEditingController bankSearchController = TextEditingController();
//   return Obx(() {
//     return SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             signupController.signupSteeperCurrentPage.value =
//                                 2;
//                           });
//                         },
//                         icon: const Icon(Icons.arrow_back)),
//                   ),
//                   Expanded(
//                       child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         "assets/images/abhi_logo.png",
//                         height: 120,
//                         width: 200,
//                       )
//                     ],
//                   ))
//                 ],
//               ),
//             ),
//             Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: SizedBox(
//                   height: 25,
//                   width: MediaQuery.of(context).size.width,
//                   child: Center(
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: stepsList().length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.circle,
//                               color: index ==
//                                       signupController
//                                           .signupSteeperCurrentPage.value
//                                   ? Colors.deepOrange
//                                   : Colors.grey,
//                               size: index ==
//                                       signupController
//                                           .signupSteeperCurrentPage.value
//                                   ? 25
//                                   : 15,
//                             ),
//                             if (index !=
//                                 4) // Add line if it's not the last circle
//                               Row(
//                                 children: [
//                                   const SizedBox(width: 7),
//                                   // Adjust the spacing as needed
//                                   Container(
//                                     width: 30,
//                                     // Set the width of the horizontal line
//                                     height: 2,
//                                     // Set the height of the horizontal line
//                                     color: index ==
//                                             signupController
//                                                 .signupSteeperCurrentPage
//                                                 .value
//                                         ? Colors.deepOrange
//                                         : Colors
//                                             .grey, // Set the color of the horizontal line
//                                   ),
//                                   const SizedBox(width: 7),
//                                   // Adjust the spacing as needed
//                                 ],
//                               ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 )),
//             const SizedBox(height: 15),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Card(
//                 elevation: 10,
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Bank Details',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black, // Adjusted color
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.grey.shade500,
//                         thickness: 2,
//                       ),
//                       const SizedBox(height: 15),
//
//                       ///
//                       Row(
//                         children: [
//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   signupController
//                                       .signupSteeperCurrentPage.value = 2;
//                                   // Get.back();
//                                 });
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   gradient: LinearGradient(
//                                       colors: [
//                                         Colors.deepOrange,
//                                         Colors.deepOrange.shade500
//                                       ],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomCenter),
//                                 ),
//                                 child: const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.arrow_back,
//                                       color: Colors.white,
//                                     ),
//                                     SizedBox(width: 10),
//                                     Text(
//                                       "Back",
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 18),
//                                     ),
//                                     SizedBox(width: 10),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 bool validate = validateForthState();
//                                 if (validate) {
//                                   setState(() {
//                                     signupController
//                                         .signupSteeperCurrentPage.value = 4;
//                                   });
//                                 }
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   gradient: LinearGradient(
//                                       colors: [
//                                         Colors.deepOrange,
//                                         Colors.deepOrange.shade500
//                                       ],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomCenter),
//                                 ),
//                                 child: const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "Continue",
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 18),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Icon(
//                                       Icons.arrow_forward,
//                                       color: Colors.white,
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       /* Row(
//                     children: [
//                       Expanded(
//                         child: InkWell(
//                           onTap: () async {
//                             bool validate = await validateForthState();
//                             if (validate) {
//                               debugPrint("Validated");
//                               await signupController
//                                   .callSignUpSubmitApi(context);
//
//                               if (signupController
//                                       .submitApiResponse.value !=
//                                   null) {
//                                 Navigator.pop(context);
//                                 if (signupController.submitApiResponse
//                                         .value!.insertId !=
//                                     0) {
//                                   MyToast.myShowToast(
//                                       "Successfully inserted");
//                                   Get.to(const SignUpSuccess());
//                                 } else {
//                                   MyToast.myShowToast(signupController
//                                       .submitApiResponse
//                                       .value!
//                                       .responseMsg);
//                                   // Get.to(const SignUpSuccess());
//                                 }
//                               }
//                               // print("after submitted");
//                             }
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               gradient: LinearGradient(
//                                   colors: [
//                                     Colors.deepOrange,
//                                     Colors.deepOrange.shade500
//                                   ],
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomCenter),
//                             ),
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment:
//                                   CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Create Profile",
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 18),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Icon(
//                                   Icons.arrow_forward,
//                                   color: Colors.white,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )*/
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ));
//   });
// }
//
// buildFifthStep() {
//   return Obx(() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Column(
//         children: [
//           SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           signupController.signupSteeperCurrentPage.value = 2;
//                         });
//                       },
//                       icon: const Icon(Icons.arrow_back)),
//                 ),
//                 Expanded(
//                     child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       "assets/images/abhi_logo.png",
//                       height: 120,
//                       width: 200,
//                     )
//                   ],
//                 ))
//               ],
//             ),
//           ),
//           Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: SizedBox(
//                 height: 25,
//                 width: MediaQuery.of(context).size.width,
//                 child: Center(
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: stepsList().length,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       return Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.circle,
//                             color: index ==
//                                     signupController
//                                         .signupSteeperCurrentPage.value
//                                 ? Colors.deepOrange
//                                 : Colors.grey,
//                             size: index ==
//                                     signupController
//                                         .signupSteeperCurrentPage.value
//                                 ? 25
//                                 : 15,
//                           ),
//                           if (index !=
//                               4) // Add line if it's not the last circle
//                             Row(
//                               children: [
//                                 const SizedBox(width: 7),
//                                 // Adjust the spacing as needed
//                                 Container(
//                                   width: 30,
//                                   // Set the width of the horizontal line
//                                   height: 2,
//                                   // Set the height of the horizontal line
//                                   color: index ==
//                                           signupController
//                                               .signupSteeperCurrentPage.value
//                                       ? Colors.deepOrange
//                                       : Colors
//                                           .grey, // Set the color of the horizontal line
//                                 ),
//                                 const SizedBox(width: 7),
//                                 // Adjust the spacing as needed
//                               ],
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               )),
//           const SizedBox(height: 15),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Card(
//               elevation: 10,
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Health Information',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black, // Adjusted color
//                       ),
//                     ),
//                     Divider(
//                       color: Colors.grey.shade500,
//                       thickness: 2,
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Designation
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.text,
//                       focusNode: signupController.designationFocusNode.value,
//                       controller: signupController.designation.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Designation',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .designationFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// DA Category
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.text,
//                       focusNode: signupController.daCategoryFocusNode.value,
//                       controller: signupController.daCategory.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('DA Category (Employee/IC)',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .daCategoryFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Approver Name
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.text,
//                       focusNode: signupController.approverNameFocusNode.value,
//                       controller: signupController.approverName.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Approver Name',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .approverNameFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Approver Emp ID
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.text,
//                       focusNode:
//                           signupController.approverEmpIdFocusNode.value,
//                       controller: signupController.approverEmpId.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Approver Emp ID',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .approverEmpIdFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Business ID (Amazon ID/FHR ID)
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.number,
//                       focusNode: signupController.businessIdFocusNode.value,
//                       controller: signupController.businessId.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Business ID (Amazon ID/FHR ID',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .businessIdFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Route
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.number,
//                       focusNode: signupController.routeFocusNode.value,
//                       controller: signupController.route.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Route',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .routeFocusNode.value.hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Payment_type
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.number,
//                       focusNode: signupController.paymentTypeFocusNode.value,
//                       controller: signupController.paymentType.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Payment_type',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .paymentTypeFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Fix_Amount
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.number,
//                       focusNode: signupController.fixAmountFocusNode.value,
//                       controller: signupController.fixAmount.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Fix_Amount',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .fixAmountFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Variable_Amount
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.number,
//                       focusNode:
//                           signupController.variableAmountFocusNode.value,
//                       controller: signupController.variableAmount.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Variable_Amount',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .variableAmountFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Fuel_Amount
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.number,
//                       focusNode: signupController.fuelAmountFocusNode.value,
//                       controller: signupController.fuelAmount.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Fuel_Amount',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .fuelAmountFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Fix_variable
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.text,
//                       focusNode: signupController.fixVariableFocusNode.value,
//                       controller: signupController.fixVariable.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Fix_variable',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .fixVariableFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Fix_Rate_Amount
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.number,
//                       focusNode:
//                           signupController.fixRateAmountFocusNode.value,
//                       controller: signupController.fixRateAmount.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Fix_Rate_Amount',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .fixRateAmountFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     /// Pay Frequency
//                     TextFormField(
//                       style: const TextStyle(
//                           fontSize: 13,
//                           overflow: TextOverflow.ellipsis,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500),
//                       keyboardType: TextInputType.number,
//                       focusNode: signupController.payFrequencyFocusNode.value,
//                       controller: signupController.payFrequency.value,
//                       textAlignVertical: TextAlignVertical.center,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 8),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                                 color: Color(0xFFFFC59D), width: 1)),
//                         label: Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               WidgetSpan(
//                                 child: Text('Pay Frequency',
//                                     style: TextStyle(
//                                         color: signupController
//                                                 .payFrequencyFocusNode
//                                                 .value
//                                                 .hasFocus
//                                             ? Colors.black
//                                             : Colors.black45)),
//                               ),
//                               const WidgetSpan(
//                                 child: Text(
//                                   ' *',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     ///
//                     Row(
//                       children: [
//                         Expanded(
//                           child: InkWell(
//                             onTap: () async {
//                               bool validate = await validateFifthState();
//                               if (validate) {
//                                 debugPrint("Validated");
//                                 await signupController
//                                     .callSignUpSubmitApi(context);
//
//                                 if (signupController
//                                         .submitApiResponse.value !=
//                                     null) {
//                                   Navigator.pop(context);
//                                   if (signupController.submitApiResponse
//                                           .value!.insertId !=
//                                       0) {
//                                     MyToast.myShowToast(
//                                         "Successfully inserted");
//                                     Get.to(const SignUpSuccess());
//                                   } else {
//                                     MyToast.myShowToast(signupController
//                                         .submitApiResponse
//                                         .value!
//                                         .responseMsg);
//                                     // Get.to(const SignUpSuccess());
//                                   }
//                                 }
//                                 // print("after submitted");
//                               }
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: LinearGradient(
//                                     colors: [
//                                       Colors.deepOrange,
//                                       Colors.deepOrange.shade500
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomCenter),
//                               ),
//                               child: const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Create Profile",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 18),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Icon(
//                                     Icons.arrow_forward,
//                                     color: Colors.white,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   });
// }
//
}
