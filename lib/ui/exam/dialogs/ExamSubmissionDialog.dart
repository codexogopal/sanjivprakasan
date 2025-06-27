import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanjivprkashan/ui/exam/dialogs/examUtils.dart';

import '../../../controller/ExamController.dart';
import '../../../theme/mythemcolor.dart';

class ExamSubmissionDialog extends StatefulWidget {
  final int testId;
  final String testType;
  final ExamController examCtrl;
  final Widget Function() buttonLoader;

  const ExamSubmissionDialog({
    Key? key,
    required this.testId,
    required this.testType,
    required this.examCtrl,
    required this.buttonLoader,
  }) : super(key: key);

  @override
  _ExamSubmissionDialogState createState() => _ExamSubmissionDialogState();
}

class _ExamSubmissionDialogState extends State<ExamSubmissionDialog> {
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildCard({
    required BuildContext context,
    required String icon,
    required String label,
    required String count,
    required Color labelColor,
    required Color countColor,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            children: [
              Image.asset(icon, height: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: countColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        content: Obx(() {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'SUBMIT TEST',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.examCtrl.isExamTimeOver.value
                        ? 'You have to submit the test, Time is over'
                        : 'Are you sure you want to submit?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'You ${widget.examCtrl.isExamTimeOver.value ? "" : "Still "}have ${widget.examCtrl.totalUnAns.value} Unanswered & ${widget.examCtrl.totalReviewMarked.value} marked for review question',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: myprimarycolor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildCard(
                        context: context,
                        icon: 'assets/images/check.png',
                        label: 'Answered',
                        count: widget.examCtrl.totalAnswered.value.toString(),
                        labelColor: Colors.green,
                        countColor: Colors.green,
                      ),
                      _buildCard(
                        context: context,
                        icon: 'assets/images/cancel.png',
                        label: 'Unanswered',
                        count: widget.examCtrl.totalUnAns.value.toString(),
                        labelColor: Colors.red,
                        countColor: Colors.red,
                      ),
                      _buildCard(
                        context: context,
                        icon: 'assets/images/skipped2.png',
                        label: 'Skipped',
                        count: widget.examCtrl.totalSkipped.value.toString(),
                        labelColor: Colors.orange,
                        countColor: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      if (!widget.examCtrl.isExamTimeOver.value)
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myprimarycolor,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'Cancel',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (!widget.examCtrl.isExamTimeOver.value)
                        const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(double.infinity, 38),
                          ),
                          onPressed: () {
                            widget.examCtrl.createExamSubmitJson(widget.testId, widget.testType);
                          },
                          child: (!examCtrl.isLoading.value || !widget.examCtrl.isExamSubmitting.value)
                              ? Text(
                            'Submit',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          )
                              : widget.buttonLoader(),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: (widget.examCtrl.isExamSubmitting.value || examCtrl.isLoading.value),
                    child: Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Please wait...',
                          style: TextStyle(color: Colors.purple, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
