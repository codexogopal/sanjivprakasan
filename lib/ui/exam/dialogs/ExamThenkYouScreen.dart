import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sanjivprkashan/ui/home/Dashboard.dart';
import 'package:sanjivprkashan/utils/AppBars.dart';


class ExamThenkYouScreen extends StatefulWidget {
  const ExamThenkYouScreen({super.key});

  @override
  State<ExamThenkYouScreen> createState() => _ExamThenkYouScreen();
}

class _ExamThenkYouScreen extends State<ExamThenkYouScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10),(){
      Navigator.pushAndRemoveUntil<dynamic>(context, MaterialPageRoute<dynamic>(builder: (BuildContext context) => Dashboard(),), (route) => false,);
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar:AppBars.myAppBar("", context, false),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150,),
                    Image.asset(
                      "assets/images/successorder.gif",
                      height: 125.0,
                      width: 125.0,
                    ),
                    Text(
                      'Your Exam Submitted successfully!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'Come back and see your result!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        color: Theme.of(context).hintColor
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() {
    return Future.value(false);
  }
}