import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/ui/home/Dashboard.dart';

import '../session/SessionManager.dart';
import '../utils/AppBars.dart';
import 'login/LoginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {

    super.initState();
    // Provider.of<HomeController>(context, listen: false).changeThemeNotify();


    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    // Navigate to home screen after the animation
    Timer(const Duration(seconds: 2), () {
      if(SessionManager.isLogin()!){
        Get.offAll(() => Dashboard(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
      }else{
        Get.offAll(() => LoginPage(), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
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
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      appBar: myStatusBar(context),
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width -120,
          height: 70,
          child: Image.asset('assets/images/flogo.png'),
        ),
      ),
    );
  }
}