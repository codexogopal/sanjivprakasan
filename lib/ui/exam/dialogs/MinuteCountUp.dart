import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/ExamController.dart';

class MinuteCountUp extends StatefulWidget {
  final int initialSeconds;
  final Function(int seconds)? onTick; // Callback with seconds

  const MinuteCountUp({
    super.key,
    required this.initialSeconds,
    this.onTick,
  });

  @override
  State<MinuteCountUp> createState() => _MinuteCountUpState();
}

class _MinuteCountUpState extends State<MinuteCountUp> {

  final ExamController examCtrl = Get.put(ExamController());
  late int totalSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    totalSeconds = widget.initialSeconds;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        totalSeconds++;
      });
      if (widget.onTick != null) {
        widget.onTick!(totalSeconds);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;

    return Text(
      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} Mint',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.purple, fontSize: 12,
        fontWeight: FontWeight.bold
      ),
    );
  }
}
