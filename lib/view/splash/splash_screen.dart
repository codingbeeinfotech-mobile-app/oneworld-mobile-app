import 'dart:async';

import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:abhilaya/view/auth/loginpage.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var loginController = Get.find<LoginController>();
  late AnimationController _controller;
  late Animation<Offset> _animation;
  GeneralMethods generalMethods = GeneralMethods();
  bool status = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 0),
      () {
        isAlreadyLoggedIn();
      },
    );
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      // Start just off the left side of the screen
      end: const Offset(1.5, 0.0), // End just off the right side of the screen
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: false);

    Timer(const Duration(seconds: 3), () {
      if (status) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: SlideTransition(
              position: _animation,
              child: Image.asset(
                'assets/images/truck.png',
                width: 200,
                height: 200,
                color: Colors.deepOrange.shade500,
              ),
            ),
          ),
          Positioned(
            bottom: 30.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/abhi_logo.png",
                  height: 120,
                  width: 200,
                ),
                const SizedBox(height: 10),
                Text(
                  'Powered By Abhilaya',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  isAlreadyLoggedIn() async {
    await generalMethods.initConnectivity();
    bool _status = await loginController.isLoggedIn();
    setState(() {
      status = _status;
    });
  }
}
