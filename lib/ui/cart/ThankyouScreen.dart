import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjivprkashan/ui/home/Dashboard.dart';
import 'package:sanjivprkashan/utils/AppBars.dart';


class ThankyouScreen extends StatefulWidget {
  const ThankyouScreen({Key? key}) : super(key: key);

  @override
  State<ThankyouScreen> createState() => _ThankyouScreen();
}

class _ThankyouScreen extends State<ThankyouScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5),(){
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
              child: SizedBox(
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
                      'Thank you for your order!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 20,
                      ),
                    )
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