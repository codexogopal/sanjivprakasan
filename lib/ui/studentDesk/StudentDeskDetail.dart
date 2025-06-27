import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sanjivprkashan/model/studentDesk/StudentDeskModel.dart';
import 'package:sanjivprkashan/utils/AppBars.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class StudentDeskDetail extends StatefulWidget {
  final PageModel pageModel;
  final bool showingHome;
  const StudentDeskDetail({super.key, required this.pageModel, required this.showingHome});

  @override
  State<StudentDeskDetail> createState() => _StudentDeskDetailState();
}

class _StudentDeskDetailState extends State<StudentDeskDetail> {

  @override
  void initState() {
    super.initState();
  }

    @override
    void dispose() {
      super.dispose();
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        appBar: widget.showingHome ? null : AppBars.myAppBar(widget.pageModel.pageName, context, true),
        body: SafeArea(child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.all(12.0),
            child: HtmlWidget(widget.pageModel.pageContent),
          ),
        )),
      );
    }
}