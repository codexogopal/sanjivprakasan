
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sanjivprkashan/ui/cart/CartScreen.dart';
import 'package:sanjivprkashan/ui/search/SearchScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/HomeController.dart';
import '../theme/mythemcolor.dart';
import 'common_color.dart';

TextStyle textStyle10(
    {FontWeight fontWeight = FontWeight.normal,
    Color textColor = Colors.black}) {
  return TextStyle(
      fontSize: 12,
      fontWeight: fontWeight,
      color: textColor,
      fontFamily: 'ssm',
      height: 1);
}

TextStyle textStyle10Normal(
    {FontWeight fontWeight = FontWeight.normal,
    Color textColor = Colors.black}) {
  return TextStyle(fontSize: 11, fontWeight: fontWeight, color: textColor);
}

TextStyle textStyle13(
    {FontWeight fontWeight = FontWeight.normal,
    Color textColor = Colors.black}) {
  return TextStyle(fontSize: 13, fontWeight: fontWeight, color: textColor);
}

TextStyle textStyle9({
  FontWeight fontWeight = FontWeight.normal,
  Color textColor = Colors.black,
}) {
  return TextStyle(fontSize: 9, fontWeight: fontWeight, color: textColor);
}

TextStyle textStyle12() {
  return TextStyle(fontSize: 12);
}

String getFileNameFromUrl(String url) {
  Uri uri = Uri.parse(url);
  String fileName = uri.pathSegments.last;
  return fileName;
}

String formatDateTimeForLive(String dateTimeString) {
  dateTimeString = dateTimeString.substring(0, dateTimeString.indexOf('+'));
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat dateFormat = DateFormat('dd MMM yyyy @hh:mm a');

  String formattedDateTime = dateFormat.format(dateTime);
  return 'Start : $formattedDateTime';
}

String calculateResult(String firstP, String secP) {
  double firstPercentage = double.parse(firstP);
  double secPercentage = double.parse(secP);
  double difference = secPercentage - firstPercentage;
  double result = (difference / secPercentage) * 100;
  String formattedResult = result.toStringAsFixed(2);
  return "$formattedResult%";
}

String formatDate(String dateTimeString) {
  final originalDateTime = DateTime.parse(dateTimeString);
  final formatter = DateFormat.yMMMMd();
  return formatter.format(originalDateTime);
}


String formatDateTime(String dateTimeString) {
  // dateTimeString = dateTimeString.substring(0, dateTimeString.indexOf('+'));
  if(dateTimeString.isEmpty || dateTimeString == "null"){
    return "-";
  }
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat dateFormat = DateFormat('hh:mm a');

  String formattedDateTime = dateFormat.format(dateTime);
  return formattedDateTime;
}

String formatHolidayDate(String dateTimeString) {
  // dateTimeString = dateTimeString.substring(0, dateTimeString.indexOf('+'));
  if(dateTimeString.isEmpty || dateTimeString == "null"){
    return "-";
  }
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat dateFormat = DateFormat('dd MMM yyyy');

  String formattedDateTime = dateFormat.format(dateTime);
  return formattedDateTime;
}

String convertDateFormat(String dateStr) {
  DateFormat inputFormat = DateFormat("dd MMM yyyy");
  DateFormat outputFormat = DateFormat("yyyy-MM-dd");

  DateTime dateTime = inputFormat.parse(dateStr);
  return outputFormat.format(dateTime);
}

List<String> getDayAndWeekday(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime);
  String day = parsedDate.day.toString().padLeft(2, '0'); // Ensures two-digit day
  String weekday = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"][parsedDate.weekday % 7]; // Get weekday abbreviation
  return [day, weekday];
}

bool isValidIndianMobileNumber(String number) {
  // Add your logic to validate an Indian mobile number here
  // For simplicity, let's assume any 10-digit number is valid
  return number.length == 10;
}

bool validateEmail(String email) {
  final bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  return emailValid;
}

String getInitials(String name) {
  List<String> nameParts = name.split(' ');
  String initials = '';

  for (int i = 0; i < nameParts.length && i < 2; i++) {
    String part = nameParts[i];
    if (part.isNotEmpty) {
      initials += part[0].toUpperCase();
    }
  }

  return initials;
}

Widget hrWidget() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Divider(
      color: Color(CommonColor.bgColor),
      height: 6,
      thickness: 6,
    ),
  );
}

Widget hrWidgetWithOutHeight() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    // child: Divider(color: Color(CommonAppTheme.bgColor),height: 0,thickness: 0,),
  );
}

Widget hrLightWidget() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Divider(
      color: Color(CommonColor.bgColor),
      height: 0,
      thickness: 1,
    ),
  );
}

Widget hrLightGreyWidget() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Divider(
      color: myprimarycolor,
      height: 0,
      thickness: 1,
    ),
  );
}

Widget hrLightWidget2() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Divider(
      color: Color(CommonColor.bgColor),
      height: 2,
      thickness: 1,
    ),
  );
}

String formatOrderTime(String timeStr) {
  // Parse the input time string
  List<String> parts = timeStr.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  // Convert 24-hour format to 12-hour format
  String period = 'AM';
  if (hour >= 12) {
    period = 'PM';
    if (hour > 12) {
      hour -= 12;
    }
  }

  // Format the time in "hh:mm a" format
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
}

TextStyle? mTextStyle(context) {
  return Theme.of(context)
      .textTheme
      .labelSmall
      ?.copyWith(fontWeight: FontWeight.w800, fontFamily: "sb", fontSize: 13);
}
TextStyle? mTextStyle1(context) {
  return Theme.of(context)
      .textTheme
      .titleMedium
      ?.copyWith(fontWeight: FontWeight.w800, fontFamily: "sb", fontSize: 13);
}

TextStyle? mItemTextStyle(context) {
  return Theme.of(context)
      .textTheme
      .titleLarge
      ?.copyWith(fontWeight: FontWeight.w800, fontSize: 13);
}

String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  for (var exp in [
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ]) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}



Widget setCachedImage(String imgUrl, double myHeight, double myWidth, double imgRadius) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(imgRadius),
    child: CachedNetworkImage(
      imageUrl: imgUrl ?? 'https://www.google.com.au/image_url.png',
      imageBuilder: (context, imageProvider) => Container(
        height: myHeight,
        width: myWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            //image size fill
            image: imageProvider,
            fit: BoxFit.fill,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        height: myHeight,
        width: myWidth,
        alignment: Alignment.center,
        child: apiLoader(),
      ),
      errorWidget: (context, url, error) => Container(
        height: myHeight,
        width: myWidth,
        child: Image.asset(
          "assets/images/no_img.png",
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}


String getGreetingMessage() {
  int currentHour = DateTime.now().hour;

  if (currentHour >= 5 && currentHour < 12) {
    return 'Good Morning';
  } else if (currentHour >= 12 && currentHour < 18) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}

List<Map<String, String>> getYearList() {
  DateTime now = DateTime.now();
  int lastYear = now.year - 1;
  int currentYear = now.year;
  int upcomingYears = 4; // Number of future years

  List<Map<String, String>> yearList = [];

  for (int i = 0; i <= upcomingYears + 1; i++) { // +1 for last year
    int year = lastYear + i;
    yearList.add({
      "title": year.toString(),
      "year": year.toString(),
    });
  }

  return yearList;
}

Widget emptyWidget123(context, String? title) {
  return SizedBox(
    height: MediaQuery.of(context).size.height/1.5,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/no_data.png",
          height: 150,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title ?? "No Record Found",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(),
        ),
      ],
    ),
  );
}
Widget emptyWidget(BuildContext context, String? title, {VoidCallback? onRefresh}) {
  return SizedBox(
    height: MediaQuery.of(context).size.height / 1.5,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/no_data.png",
          height: 150,
        ),
        const SizedBox(height: 10),
        Text(
          title ?? "No Record Found",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        if (onRefresh != null) // Only show refresh button if callback is provided
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: myprimarycolor.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
              ),
              child: const Text(
                "Refresh",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    ),
  );
}

Widget emptyWidgetAtt(context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/no_data.png",
          height: 150,
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: Text(
            "Sorry! You have no permission to use this section",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(),
          ),
        ),
      ],
    ),
  );
}


Future<void> requestPermissions() async {
  bool locationGranted = await _requestLocationPermission();
  // bool cameraGranted = await _requestCameraPermission();
  if (locationGranted) {
  } else {
  }
}


Future<bool> _requestLocationPermission() async {
  final PermissionStatus permissionStatus = await Permission.location.status;

  if (permissionStatus.isGranted) {
    return true;
  } else if (permissionStatus.isDenied) {
    PermissionStatus newStatus = await Permission.location.request();
    return newStatus.isGranted;
  } else if (permissionStatus.isPermanentlyDenied) {
    return false;
  }
  return false;
}

Future<bool> _requestCameraPermission() async {
  final PermissionStatus permissionStatus = await Permission.camera.status;

  if (permissionStatus.isGranted) {
    return true;
  } else if (permissionStatus.isDenied) {
    PermissionStatus newStatus = await Permission.camera.request();
    return newStatus.isGranted;
  } else if (permissionStatus.isPermanentlyDenied) {
    return false;
  }
  return false;
}


Future<String?> selectDate(BuildContext context) async {
  DateTime today = DateTime.now();
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: today,
    firstDate: today, // Disables past dates
    lastDate: DateTime(2101),
  );
  if (picked != null) {
    return DateFormat('yyyy-MM-dd').format(picked);
  }
  return null; // Return null if no date is picked
}

String getToDayDate(){
  DateTime c = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(c);
}


Future<String?> selectDobDate(BuildContext context) async {
  DateTime today = DateTime.now();
  DateTime eighteenYearsAgo = DateTime(today.year - 18, today.month, today.day);
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: eighteenYearsAgo,
    firstDate: DateTime(1960), // Disables past dates
    lastDate: eighteenYearsAgo,
  );
  if (picked != null) {
    return DateFormat('yyyy-MM-dd').format(picked);
  }
  return null; // Return null if no date is picked
}

String addDaysToDate(String date, int daysToAdd) {
  DateTime parsedDate = DateTime.parse(date); // Convert string to DateTime
  DateTime newDate = parsedDate.add(Duration(days: daysToAdd)); // Add days
  return DateFormat('yyyy-MM-dd').format(newDate); // Convert back to string
}

OutlineInputBorder outlineInputBorder(BuildContext context){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Theme.of(context).primaryColor,
      width: 1.0,
    ),
  );
}


File? imageFile;
String? base64Image;
final ImagePicker picker = ImagePicker();

Future<void> pickImage(BuildContext context) async {
  final picker = ImagePicker();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    builder: (BuildContext ctx) {
      return Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera'),
            onTap: () async {
              Navigator.pop(ctx); // Close BottomSheet
              await _pickAndCropImage(picker, ImageSource.camera, context);
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Gallery'),
            onTap: () async {
              Navigator.pop(ctx); // Close BottomSheet
              await _pickAndCropImage(picker, ImageSource.gallery, context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> _pickAndCropImage(ImagePicker picker, ImageSource source, BuildContext context) async {
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile != null) {
    imageFile = null;
    base64Image = "";

    // Crop the image
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      imageFile = File(croppedFile.path);

      // Check file size
      final fileSize = await imageFile?.length();
      if (fileSize! > 2 * 1024 * 1024) {
        imageFile = null;
        Get.snackbar("Image must be less than 2 MB.", "Image must be less than 2 MB.",
            backgroundColor: Colors.orange.shade200, colorText: Colors.black);
        return;
      }

      // Encode image to base64
      base64Image = base64Encode(imageFile!.readAsBytesSync());

      // Trigger UI update
      (context as Element).markNeedsBuild();
      // HomeController homeController = Get.find<HomeController>();
      // homeController.update();
    } else {
      if (kDebugMode) {
        print('Image cropping canceled.');
      }
    }
  } else {
    if (kDebugMode) {
      print('No image selected.');
    }
  }
}


Future<void> pickImage11(BuildContext context) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {

    imageFile = null;
    base64Image = "";
    print("pickedFile  ${pickedFile}");
    // Crop the image
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );

    if (croppedFile != null) {
        imageFile = File(croppedFile.path);
        // Check file size
        final fileSize = await imageFile?.length();
        if (fileSize! > 2 * 1024 * 1024) {
          imageFile = null;
          Get.snackbar("Image must be less than 2 MB.", "Image must be less than 2 MB.", backgroundColor: Colors.orange.shade200, colorText: Colors.black);
          return;
        }
      // Encode image to base64
        base64Image = base64Encode(imageFile!.readAsBytesSync());
      // Trigger UI update
      (context as Element).markNeedsBuild();
        // HomeController homeController = Get.find<HomeController>();
        // homeController.update();
    } else {
      if (kDebugMode) {
        print('Image cropping canceled.');
      }
    }
  } else {
    if (kDebugMode) {
      print('No image selected.');
    }
  }
}

void openWhatsApp(String whatsUrl) async {
  String url = whatsUrl;
  await launchUrl(Uri.parse(url));
}


// For storage (ISO 8601 format with UTC)
DateTime? selectedDateTime;
String get utcDateTime {
  if (selectedDateTime == null) return '';
  return selectedDateTime!.toUtc().toIso8601String();
}

// For displaying in UI (Dec, 05 2024 @08:30)
String get formattedDateTime {
  if (selectedDateTime == null) return '';
  return DateFormat("MMM, dd yyyy @hh:mm a").format(selectedDateTime!);
}
String get formattedRDateTime {
  if (selectedDateTime == null) return '';
  return DateFormat("MMM, dd yyyy").format(selectedDateTime!);
}

Future<String> pickDateTime1(BuildContext context, String type) async {
  // Minimum selectable date: First day of the previous month
  DateTime firstDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);

  // Maximum selectable date: Last day of the current month
  DateTime lastDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  debugPrint("First Date: $firstDate, Last Date: $lastDate   $type");

  // Pick a date
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: firstDate,
    lastDate: DateTime.now(),
  );

  if (pickedDate == null) return ""; // If the user cancels

  // Pick a time
  TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, childWidget) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: childWidget!,
      );
    },
  );

  if (pickedTime == null) return ""; // If the user cancels

  // Format the selected date and time
  String formattedDateTime = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year} ${pickedTime.hour}:${pickedTime.minute}";

  return type == "rgd" ? formattedRDateTime : formattedDateTime;
}


Future<String> pickDateTime(BuildContext context, String type) async {
  // Minimum selectable date: First day of the previous month
  DateTime firstDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);

  // Maximum selectable date: Last day of the current month
  DateTime lastDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);


  // Pick a date
  DateTime? pickedDate = await showDatePicker(
    context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: DateTime.now()
  );

  if (pickedDate == null) return ""; // If the user cancels

  // Pick a time
  TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, childWidget) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: childWidget!,
      );
    },
  );

  if (pickedTime == null) return ""; // If the user cancels

  // Combine date and time
   selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  return type == "rgd" ? formattedRDateTime : formattedDateTime;
}

String convertAttRDateInOutFormat(String dateString) {
  try {
    // Define input format
    DateFormat inputFormat = DateFormat("MMM, dd yyyy @hh:mm a");
    // Define output format
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSSS");

    // Parse input date string
    DateTime parsedDate = inputFormat.parse(dateString);

    // Format and return as string
    return outputFormat.format(parsedDate);
  } catch (e) {
    return "Invalid date";
  }
}

String convertAttRDateInOutFormatForView(String dateString) {
  try {
    // Define input format
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSSS");
    // Define output format
    DateFormat outputFormat = DateFormat("hh:mm a");

    // Parse input date string
    DateTime parsedDate = inputFormat.parse(dateString);

    // Format and return as string
    return outputFormat.format(parsedDate);
  } catch (e) {
    return "Invalid date";
  }
}

String convertAttRDateFormat(String dateString) {
  try {
    // Define input format
    DateFormat inputFormat = DateFormat("MMM, dd yyyy");
    // Define output format
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSSS");

    // Parse input date string
    DateTime parsedDate = inputFormat.parse(dateString);

    // Format and return as string
    return outputFormat.format(parsedDate);
  } catch (e) {
    return "Invalid date";
  }
}

String convertAttRDateFormatForShowInView(String dateString) {
  try {
    // Define input format
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSSS");
    // Define output format
    DateFormat outputFormat = DateFormat("MMM, dd yyyy");

    // Parse input date string
    DateTime parsedDate = inputFormat.parse(dateString);

    // Format and return as string
    return outputFormat.format(parsedDate);
  } catch (e) {
    return "Invalid date";
  }
}

bool isValidTime(String inTime, String outTime) {
  DateTime inDateTime = DateTime.parse(inTime);
  DateTime outDateTime = DateTime.parse(outTime);

  debugPrint("First Date: $inTime, Last Date: $outTime   ${inDateTime.isBefore(outDateTime)}");
  return inDateTime.isBefore(outDateTime);
}

bool areDatesEqual(String date, String inTime, String outTime) {
  DateTime mainDate = DateTime.parse(date);
  DateTime inDateTime = DateTime.parse(inTime);
  DateTime outDateTime = DateTime.parse(outTime);

  return mainDate.year == inDateTime.year &&
      mainDate.month == inDateTime.month &&
      mainDate.day == inDateTime.day &&
      mainDate.year == outDateTime.year &&
      mainDate.month == outDateTime.month &&
      mainDate.day == outDateTime.day;
}

SnackbarController showSnackbar(String title, String message){
  return Get.snackbar(title, message, backgroundColor: myprimarycolor, colorText: Colors.white);
}
SnackbarController showGreenSnackbar(String title, String message){
  return Get.snackbar(title, message, backgroundColor: Colors.green, colorText: Colors.white);
}

SpinKitFadingCircle buttonLoader(){
  return SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
            color: index.isEven ? Colors.white : Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
      );
    },
  );
}

SpinKitFadingCircle apiLoader({double size = 50}){
  return SpinKitFadingCircle(
    size: size,
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
            color: index.isEven ? myprimarycolor : myprimarycolor,
            borderRadius: BorderRadius.circular(10)
        ),
      );
    },
  );
}

Widget homeAppBar(BuildContext context, GlobalKey<ScaffoldState> gKey){
  final HomeController homeController = Get.put(HomeController());
  final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  return Obx((){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2.0,
              offset: Offset(0.0, 1.0)
          ),
        ],
      ),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  gKey.currentState?.openDrawer();
                },
                  child: Image.asset("assets/images/menu.png", width: 30, height: 30, color: isDarkTheme ? Colors.white : null,)
              ),
              SizedBox(width: 10,),
              // Image.asset("assets/images/flogo.png", height: 40,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello!",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    homeController.userData.value?.userFname ?? "Buddy",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell( onTap: (){
                Get.to(()=> SearchScreen());
              },
              child: Image.asset("assets/images/search.png", width: 27, height: 27, color: isDarkTheme ? Colors.white : null,)),
              SizedBox(width: 15,),

              InkWell(
                onTap: (){
                  Get.to(()=> CartScreen());
                },
                child: Stack(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: 60,
                        width: 40,
                        child: Image.asset("assets/images/cart.png", color: isDarkTheme ? Colors.white : null,)
                    ),
                    if(homeController.cartItemCount.value != "0" && homeController.cartItemCount.value != "" && homeController.cartItemCount.value != "null")
                    Positioned(
                      right: 0,
                      top: 8,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: myprimarycolor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          homeController.cartItemCount.value,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 5,),
            ],
          )
        ],
      ),
    );
  });
}

Widget otherAppBar(BuildContext context, String? title ,bool isBackShow, {bool isCartShow = true, double height = 60}){
  final HomeController homeController = Get.put(HomeController());
  final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, ),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2.0,
            offset: Offset(0.0, 1.0)
        ),
      ],
    ),
    height: height,
    width: MediaQuery.of(context).size.width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: isBackShow,
              child: InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back, size: 30,)
              ),
            ),
            // Image.asset("assets/images/menu.png", width: 30, height: 30, color: isDarkTheme ? Colors.white : null,),
            SizedBox(width: 10,),
            // Image.asset("assets/images/flogo.png", height: 40,),
            Text(
              title ?? "",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if(isCartShow)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(title != "My Cart")
              Obx((){
                return InkWell(
                    onTap: (){
                      Get.to(()=> CartScreen());
                    },
                    child: Stack(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: 60,
                            width: 40,
                            child: Image.asset("assets/images/cart.png", color: isDarkTheme ? Colors.white : null,)
                        ),
                        if(homeController.cartItemCount.value != "0" && homeController.cartItemCount.value != "" && homeController.cartItemCount.value != "null")
                          Positioned(
                            right: 0,
                            top: 8,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: myprimarycolor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                homeController.cartItemCount.value,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  );
              }),
            SizedBox(width: 5,),
          ],
        )
      ],
    ),
  );
}

String formatDateForEBook(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString).toLocal(); // Converts to local time
    String formatted = DateFormat("MMM, dd yyyy @hh:mm a").format(dateTime);
    return formatted;
  } catch (e) {
    return "Invalid date";
  }
}


class ValidityStatus {
  final int remainingDays;
  final String status;
  final Color color;
  final String formattedExpiryDate;

  ValidityStatus({
    required this.remainingDays,
    required this.status,
    required this.color,
    required this.formattedExpiryDate,
  });
}

ValidityStatus checkItemValidity(String purchaseDateStr) {
  try {
    // Step 1: Parse UTC purchase time
    DateTime purchaseDateUtc = DateTime.parse(purchaseDateStr).toUtc();

    // Step 2: Create exact expiry time (1 year after purchase)
    DateTime expiryUtc = DateTime.utc(
      purchaseDateUtc.year + 1,
      purchaseDateUtc.month,
      purchaseDateUtc.day,
      purchaseDateUtc.hour,
      purchaseDateUtc.minute,
      purchaseDateUtc.second,
    );

    // Step 3: Get current time in UTC
    DateTime nowUtc = DateTime.now().toUtc();

    // Step 4: Compare current time with expiry time
    if (!nowUtc.isBefore(expiryUtc)) {
      return ValidityStatus(
        remainingDays: 0,
        status: "Expired",
        color: Colors.red,
        formattedExpiryDate: DateFormat("dd MMMM yyyy | hh:mm:ss a").format(expiryUtc.toLocal()),
      );
    }

    Duration diff = expiryUtc.difference(nowUtc);
    int remainingSeconds = diff.inSeconds;
    int remainingDays = diff.inDays;

    if (remainingSeconds <= 10 * 24 * 60 * 60) {
      return ValidityStatus(
        remainingDays: remainingDays,
        status: "Expiring soon",
        color: Colors.orange,
        formattedExpiryDate: DateFormat("dd MMMM yyyy | hh:mm:ss a").format(expiryUtc.toLocal()),
      );
    }

    return ValidityStatus(
      remainingDays: remainingDays,
      status: "Valid",
      color: Colors.green,
      formattedExpiryDate: DateFormat("dd MMMM yyyy | hh:mm:ss a").format(expiryUtc.toLocal()),
    );
  } catch (e) {
    return ValidityStatus(
      remainingDays: 0,
      status: "Invalid date",
      color: Colors.grey,
      formattedExpiryDate: "Invalid",
    );
  }
}

ValidityStatus checkItemValidityMonthWise(String purchaseDateStr, {int validityMonths = 12}) {
  try {
    // Step 1: Parse UTC purchase time
    DateTime purchaseDateUtc = DateTime.parse(purchaseDateStr).toUtc();

    // Step 2: Create exact expiry time (validityMonths after purchase)
    DateTime expiryUtc = DateTime.utc(
      purchaseDateUtc.year + validityMonths ~/ 12,
      purchaseDateUtc.month + validityMonths % 12,
      purchaseDateUtc.day,
      purchaseDateUtc.hour,
      purchaseDateUtc.minute,
      purchaseDateUtc.second,
    );

    // Handle month overflow (e.g., if purchase was in November + 3 months = February next year)
    if (expiryUtc.month > 12) {
      expiryUtc = DateTime.utc(
        expiryUtc.year + 1,
        expiryUtc.month - 12,
        expiryUtc.day,
        expiryUtc.hour,
        expiryUtc.minute,
        expiryUtc.second,
      );
    }

    // Step 3: Get current time in UTC
    DateTime nowUtc = DateTime.now().toUtc();

    // Step 4: Compare current time with expiry time
    if (!nowUtc.isBefore(expiryUtc)) {
      return ValidityStatus(
        remainingDays: 0,
        status: "Expired",
        color: Colors.red,
        formattedExpiryDate: DateFormat("dd MMMM yyyy | hh:mm:ss a").format(expiryUtc.toLocal()),
      );
    }

    Duration diff = expiryUtc.difference(nowUtc);
    int remainingSeconds = diff.inSeconds;
    int remainingDays = diff.inDays;

    if (remainingSeconds <= 10 * 24 * 60 * 60) { // 10 days
      return ValidityStatus(
        remainingDays: remainingDays,
        status: "Expiring soon",
        color: Colors.orange,
        formattedExpiryDate: DateFormat("dd MMMM yyyy | hh:mm:ss a").format(expiryUtc.toLocal()),
      );
    }

    return ValidityStatus(
      remainingDays: remainingDays,
      status: "Valid",
      color: Colors.green,
      formattedExpiryDate: DateFormat("dd MMMM yyyy | hh:mm:ss a").format(expiryUtc.toLocal()),
    );
  } catch (e) {
    return ValidityStatus(
      remainingDays: 0,
      status: "Invalid date",
      color: Colors.grey,
      formattedExpiryDate: "Invalid",
    );
  }
}


String getDiscountInPerstions(String mrp, String discuntAmount){
  double mPrice = double.parse(mrp);
  double dPrice = double.parse(discuntAmount);
  double prscent = (dPrice * 100) / mPrice;
  return prscent.toStringAsFixed(2);
}


int getSpentTimeInMinutes(String testDuration, String examPauseTime) {
  // Convert to double in case the values are "30.0" or have decimals
  double totalDuration = double.tryParse(testDuration) ?? 0;
  double remainingTime = double.tryParse(examPauseTime) ?? 0;

  double spentTime = totalDuration - remainingTime;

  // Ensure time is never negative
  return spentTime < 0 ? 0 : spentTime.round();
}