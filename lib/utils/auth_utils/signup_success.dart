import 'package:abhilaya/view/auth/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller/signup_controller.dart';

class SignUpSuccess extends StatefulWidget {
  const SignUpSuccess({super.key});

  @override
  State<SignUpSuccess> createState() => _SignUpSuccessState();
}

class _SignUpSuccessState extends State<SignUpSuccess> {
  var signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/abhi_logo.png",
                height: MediaQuery.sizeOf(context).height * 0.15,
                width: MediaQuery.sizeOf(context).width * 0.70,
              ),
              const SizedBox(height: 10),
              Image.asset("assets/gif/success.gif",
                  height: MediaQuery.sizeOf(context).height * 0.25,
                  width: MediaQuery.sizeOf(context).width * 0.90),
              const SizedBox(height: 10),
              Text(
                "Inserted Successfully",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrange.shade500,
                    fontSize: 20),
              ),
              const SizedBox(height: 10),
              // const Text(
              //   "New User Created",
              //   style: TextStyle(
              //       fontWeight: FontWeight.w400,
              //       color: Colors.black,
              //       fontSize: 15),
              // ),
              // const SizedBox(height: 10),
              // Text(
              //   "User ID - ${signupController.submitApiResponse.value!.responseMsg.toString()}",
              //   style: const TextStyle(
              //       fontWeight: FontWeight.w500,
              //       color: Colors.black,
              //       fontSize: 17),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Get.offAll(const LoginPage());
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  colors: [Colors.deepOrange, Colors.deepOrange.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Finish",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
