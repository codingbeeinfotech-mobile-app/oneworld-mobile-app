import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/controller/auth_controller/logout_controller.dart';
import 'package:abhilaya/controller/auth_controller/signup_controller.dart';
import 'package:abhilaya/controller/dashboard_controller.dart';
import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:store_redirect/store_redirect.dart';

class Dialogs {
  static Future<dynamic> alertBox(
    BuildContext context, {
    required String title,
    String? body,
    String? image,
  }) {
    double deviceHeight = MediaQuery.of(context).size.height,
        deviceWidth = MediaQuery.of(context).size.width;

    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ), //this right here
      child: Container(
        height: deviceHeight * 0.4,
        width: deviceWidth * 0.7,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: Colors.deepOrange.shade500,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 7),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image ?? "assets/images/success.png"),
                ),
              ),
            ),
            const SizedBox(height: 15),
            (body != null)
                ? Center(
                    child: Text(
                      body,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 15),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MaterialButton(
                    height: deviceHeight * 0.05,
                    minWidth: deviceWidth * 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    color: Colors.deepOrange,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );

    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static void logOutWindow(BuildContext context) {
    LogoutController logoutController = Get.find<LogoutController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          title: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/abhi_logo.png",
                height: MediaQuery.sizeOf(context).height * 0.08,
                width: MediaQuery.sizeOf(context).width,
              ),
              const Divider(color: Colors.black),
              const SizedBox(height: 10),
              const Text(
                "Come back Soon!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              const Center(
                child: Text(
                  "Are you sure you want to Log Out?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      25), // Add some space between the text and the buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      await logoutController.callLogoutApi(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 22, top: 10, bottom: 10, right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [
                                Colors.deepOrange.shade500,
                                Colors.deepOrange.shade400
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter),
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 22, top: 10, bottom: 10, right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [
                                Colors.deepOrange.shade500,
                                Colors.deepOrange.shade400
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter),
                        ),
                        child: const Text("No ",
                            style: TextStyle(color: Colors.white))),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<dynamic> lottieLoading(BuildContext context, String path) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Lottie.asset(path,
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width),
          );
        });
  }

  static void updateDialogBox(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          title: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/abhi_logo.png",
                height: MediaQuery.sizeOf(context).height * 0.08,
                width: MediaQuery.sizeOf(context).width,
              ),
              const Divider(color: Colors.black),
              const SizedBox(height: 10),
              const Text(
                "New Update Available!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              const Center(
                child: Text(
                  "Please Update your App to Proceed?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      25), // Add some space between the text and the buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      debugPrint("Redirecting to Playstore");
                      StoreRedirect.redirect(
                          androidAppId: "com.isourse.abhilaya", iOSAppId: "");
                    },
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 22, top: 10, bottom: 10, right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [
                                Colors.deepOrange.shade500,
                                Colors.deepOrange.shade400
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter),
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // static updateDialogBox(BuildContext context){
  //
  //   showDialog(
  //       context: context,
  //     barrierDismissible: true,
  //       builder: (context) {
  //         return Container(
  //           height: MediaQuery.sizeOf(context).height*0.5,
  //           width: MediaQuery.sizeOf(context).width*0.8,
  //           color: Colors.transparent,
  //           child: AlertDialog(
  //             title:  Image.asset("assets/images/abhi_logo.png",height: 200,width: 200,),
  //             content: Column(
  //               children: [
  //                 const SizedBox(height:10),
  //                 const Text("Version Outdated" , style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500, fontSize: 20),),
  //                 const SizedBox(height:5),
  //                 const Text("Please Update your application to proceed" , style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500, fontSize: 15),),
  //                 const SizedBox(height:15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     InkWell(
  //                       onTap: () async {
  //                         debugPrint("Redirecting to Playstore...");
  //                         StoreRedirect.redirect(androidAppId: "com.laya.abhilaya",iOSAppId: "");
  //                       },
  //                       child: Container(
  //                           padding:const  EdgeInsets.only(
  //                               left: 22,
  //                               top: 10,
  //                               bottom: 10,
  //                               right: 20
  //                           ),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(10),
  //                             gradient: LinearGradient(
  //                                 colors: [Colors.deepOrange.shade500,Colors.deepOrange.shade400],
  //                                 begin: Alignment.topLeft,
  //                                 end: Alignment.bottomCenter
  //                             ),),
  //                           child: const Text("Update",style: TextStyle(color: Colors.white),)
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //
  //       },);
  //
  // }

  static Future<dynamic> paymentSuccessLottie(
      BuildContext context, String path) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close the dialog
    });
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // Show dialog with Lottie animation
        return Dialog(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  path,
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                const Text("Redirecting ...")
              ],
            ),
          ),
        );
      },
    );

    // // Automatically close dialog after 5 seconds
  }

  static signUpLoading(BuildContext context) {
    var signupController = Get.find<SignupController>();

    signupController.isLottieCalled.value = true;
    // print(signupController.isLottieCalled.value);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottiee/verification.json',
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: MediaQuery.sizeOf(context).height * 0.4,
                fit: BoxFit.fill,
              )
            ],
          ),
        );
      },
    );
  }

  static Future<void> pdfViewer(BuildContext context, String url) async {
    if (url.isEmpty) {
      MyToast.myShowToast("No PDF");
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.80,
          // width: MediaQuery.of(context).size.width ,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   child: SizedBox(
              //     height: MediaQuery.sizeOf(context).height * 0.80,
              //     // width: MediaQuery.sizeOf(context).width,
              //     // padding: EdgeInsets.all(8.0),
              //     child: FutureBuilder<PDFDocument>(
              //       future: PDFDocument.fromURL(url),
              //       builder: (context, snapshot) {
              //         if (snapshot.connectionState == ConnectionState.waiting) {
              //           return const Center(child: CircularProgressIndicator());
              //         } else if (snapshot.hasError) {
              //           return const Center(child: Text("Error loading PDF"));
              //         } else if (!snapshot.hasData || snapshot.data == null) {
              //           return const Center(child: Text("No PDF content"));
              //         } else {
              //           return PDFViewer(
              //             document: snapshot.data!,
              //             showPicker: false,
              //           );
              //         }
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> locationPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomDialog();
      },
    );
  }

  static void successDialogBox(
    BuildContext context, {
    required String message,
    String? imagePath,
    String? body,
  }) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: deviceHeight * 0.4,
        width: deviceWidth * 0.7,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            imagePath != null
                ? Image.asset(
                    imagePath,
                    height: 50.0,
                    width: 50.0,
                  )
                : const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50.0,
                  ),
            const SizedBox(height: 15),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (body != null) ...[
              const SizedBox(height: 15),
              Text(
                body,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => dialog,
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    DashboardController dashboardController = Get.find<DashboardController>();
    var loginController = Get.find<LoginController>();
    GeneralMethods generalMethods = GeneralMethods();
    return SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Container(
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.70
            : MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.7,
        // margin: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 25,
                  // backgroundImage: AssetImage("assets/gif/location-pin.gif"),
                  child: Image.asset("assets/gif/location-pin.gif"),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Required Location Permission",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Abhilaya needs location permission in order to track our delivery agents,while your app is running",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: null,
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.height * 0.25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/location.png"),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        color: Colors.deepOrange,
                        onPressed: () async {
                          Dialogs.lottieLoading(
                              context, "assets/lottiee/location.json");
                          await generalMethods.askLocationPermission();

                          debugPrint(loginController.locationPermission.value);

                          if (loginController.locationPermission.value ==
                              "Allowed") {
                            dashboardController.isOnDuty.value = true;
                            dashboardController.isLocationFetched.value = true;
                          } else {
                            MyToast.myShowToast("Location access is required");
                            dashboardController.isOnDuty.value = false;
                            dashboardController.isLocationFetched.value = false;
                          }

                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        minWidth: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.05,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
