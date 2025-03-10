import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller/change_password_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  ChangePasswordController changePasswordController =
      Get.find<ChangePasswordController>();

  late double deviceHeight, deviceWidth;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      changePasswordController.oldPassword.value.clear();
      changePasswordController.newPassword.value.clear();
      changePasswordController.confirmNewPassword.value.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          // height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/images/yellow1.png",
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Change Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 40),
                    PasswordField(
                      title: 'Old Password',
                      controller: changePasswordController.oldPassword.value,
                      focusNode:
                          changePasswordController.oldPasswordFocusNode.value,
                    ),
                    const SizedBox(height: 20),
                    PasswordField(
                      title: 'New Password',
                      controller: changePasswordController.newPassword.value,
                      focusNode:
                          changePasswordController.newPasswordFocusNode.value,
                    ),
                    const SizedBox(height: 20),
                    PasswordField(
                      title: 'Confirm Password',
                      controller:
                          changePasswordController.confirmNewPassword.value,
                      focusNode: changePasswordController
                          .confirmPasswordFocusNode.value,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.only(right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              // CustomLoader.circularLoading(context);

                              await changePasswordController.onSave(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 22, top: 10, bottom: 10, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.deepOrange.shade500,
                                      Colors.deepOrange
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(),
    //   body: Container(
    //     child: Column(
    //       children: [
    //         Container(
    //           height: 100,
    //           width: 100,
    //           decoration: const BoxDecoration(
    //             image: DecorationImage(
    //               image: AssetImage(
    //                 'assets/images/abhi_logo.png',
    //               ),
    //             ),
    //           ),
    //         ),
    //         Text('Change your password'),
    //

    //         MaterialButton(
    //           onPressed: () async {
    //             await changePasswordController.onSave();
    //           },
    //           child: Text('Save'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class PasswordField extends StatefulWidget {
  String title;
  TextEditingController controller;
  FocusNode focusNode;

  PasswordField({
    super.key,
    required this.title,
    required this.controller,
    required this.focusNode,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(right: 25),
        child: Material(
          elevation: 10.0,
          // Adjust elevation as needed
          color: Colors.deepOrange.shade300,
          borderRadius: BorderRadius.circular(10.0),
          shadowColor: Colors.black,
          child: TextFormField(
            maxLines: 1,
            focusNode: widget.focusNode,
            controller: widget.controller,
            obscureText: isHidden,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepOrange.shade500),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade50),
                ),
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 15,
                            color: widget.focusNode.hasFocus
                                ? Colors.deepOrange.shade500
                                : Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  size: 20,
                  color: widget.focusNode.hasFocus
                      ? Colors.deepOrange.shade500
                      : Colors.grey,
                ),
                suffixIcon: IconButton(
                  icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility,
                      color: Colors.deepOrange.shade500),
                  onPressed: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                )),
          ),
        ),
      ),
    );
  }
}
