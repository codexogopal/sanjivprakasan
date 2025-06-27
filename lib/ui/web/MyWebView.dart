import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sanjivprkashan/utils/AppBars.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class MyWebView extends StatefulWidget {
  final String mPdfFile;
  const MyWebView({super.key, required this.mPdfFile});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            setState(() {

            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            openDialog(request);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.mPdfFile));
      // ..loadRequest(Uri.parse('https://codexo.store/sanjivprakashan/test-pdf/3cade95d96a38bf1788b46f38399fd5b.pdf'));

    // setBackgroundColor is not currently supported on macOS.
    if (kIsWeb || !Platform.isMacOS) {
      controller.setBackgroundColor(const Color(0x80000000));
    }

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context, _controller),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: myStatusBar(context),
        body: SafeArea(child: WebViewWidget(controller: _controller)),
      ),
    );
  }

  Future<void> openDialog(HttpAuthRequest httpRequest) async {
    final TextEditingController usernameTextController =
    TextEditingController();
    final TextEditingController passwordTextController =
    TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${httpRequest.host}: ${httpRequest.realm ?? '-'}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  autofocus: true,
                  controller: usernameTextController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  controller: passwordTextController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Explicitly cancel the request on iOS as the OS does not emit new
            // requests when a previous request is pending.
            TextButton(
              onPressed: () {
                httpRequest.onCancel();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                httpRequest.onProceed(
                  WebViewCredential(
                    user: usernameTextController.text,
                    password: passwordTextController.text,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Authenticate'),
            ),
          ],
        );
      },
    );
  }
}
var ctime;
Future<bool> _onBackPressed(BuildContext context, WebViewController webViewController) async {
  if(Platform.isIOS){
    return Navigator.of(context).userGestureInProgress;
  }
  else if (await webViewController.canGoBack()) {
    await webViewController.goBack();
    return Future.value(false);
  } else {
    if (context.mounted) {
      DateTime now = DateTime.now();
      if (ctime == null || now.difference(ctime) > const Duration(seconds: 2)) {
        //add duration of press gap
        ctime = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Press Back Button Again to Exit'), duration: Duration(seconds: 2),),
        );
        return Future.value(false);
      }
      return Future.value(true);
    }
  }
  return Future.value(false);
}