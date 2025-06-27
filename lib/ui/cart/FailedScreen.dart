import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjivprkashan/ui/home/Dashboard.dart';

import '../../utils/AppBars.dart';


class FailedScreen extends StatefulWidget {
  final String? errorMsg;
  const FailedScreen({Key? key, this.errorMsg}) : super(key: key);

  @override
  State<FailedScreen> createState() => _FailedScreen();
}

class _FailedScreen extends State<FailedScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5),(){
      Navigator.pushAndRemoveUntil<dynamic>(context, MaterialPageRoute<dynamic>(builder: (BuildContext context) => Dashboard(),), (route) => false,);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "assets/images/close.png",
                    height: 125.0,
                    width: 125.0,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'Sorry your order is failed',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    widget.errorMsg ?? "Please try again.",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13,
                      color: Colors.red
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}