
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/mythemcolor.dart';
import 'common_color.dart';

class AppBars {
  static AppBar myAppBar(String title, context, bool isShowIcon) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.primaryContainer,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light // Light icons for dark theme
            : Brightness.dark, // Dark icons for light theme
      ),
      centerTitle: false,
      elevation: 3,
      shadowColor: Colors.black38,
      titleSpacing: isShowIcon ? -5 : -30,
      title: Text(
        title,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: 'm', fontSize: 16, fontWeight: FontWeight.bold),
      ),
      leading: Visibility(
        visible: isShowIcon,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color:  Theme.of(context).indicatorColor,)
        ),
      ),
      // iconTheme: IconThemeData(color: Theme.of(context).indicatorColor),
    );
  }

}


AppBar myStatusBar(BuildContext context){
  final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  return AppBar(
    backgroundColor: isDarkTheme ? Color(CommonColor.darkBgColor) : Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor:  isDarkTheme ? Color(CommonColor.darkBgColor) : Colors.white,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light // Light icons for dark theme
          : Brightness.dark, // Dark icons for light theme
    ),
    toolbarHeight: 0,
    elevation: 0,
  );
}

AppBar myStatusBar1(BuildContext context,{bool? isShowColor}){
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).colorScheme.primaryContainer,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light // Light icons for dark theme
          : Brightness.dark, // Dark icons for light theme
    ),
    toolbarHeight: 0,
    elevation: 0,
  );
}

AppBar myStatusBarSeries(BuildContext context){
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.primaryContainer
          : myprimarycolor.shade50,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light // Light icons for dark theme
          : Brightness.dark, // Dark icons for light theme
    ),
    toolbarHeight: 0,
    elevation: 0,
  );
}