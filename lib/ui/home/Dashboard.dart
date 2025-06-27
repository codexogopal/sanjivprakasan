
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanjivprkashan/ui/account/AccountScreen.dart';
import 'package:sanjivprkashan/ui/course/CourseScreen.dart';
import 'package:sanjivprkashan/ui/testSeries/TesSeries.dart';
import 'package:sanjivprkashan/ui/currentAfairs/CurrentAfairsScreen.dart';
import 'package:sanjivprkashan/ui/product/AllProductScreen.dart';
import 'package:sanjivprkashan/ui/studentDesk/StudentDeskScreen.dart';

import '../../session/SessionManager.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';
import '../../controller/HomeController.dart';
import 'HomeScreen.dart';



class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final HomeController homeController = Get.put(HomeController());
  var ctime;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> listBottomWidget = [
    HomeScreen(),
    CourseScreen(),
    TestSeriesScreen(),
    StudentDeskScreen(),
    // CurrentAfairsScreen(),
    AccountScreen(showAppBar: true,),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: scaffoldKey,
        bottomNavigationBar: myBottomNavigationBar(),
        body: SafeArea(
          child: Obx(() {
            if (homeController.isLoading.value) {
              return Center(child: apiLoader());
            }
            return listBottomWidget[homeController.bottomTabIndex.value];
          }),
        ),
      ),
    );
  }

  Widget myBottomNavigationBar() {
    return Obx(() => BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        fontFamily: "b",
        color: myprimarycolor.shade900,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        fontFamily: "b",
        color: Theme.of(context).hintColor,
      ),
      items: [
        BottomNavigationBarItem(
            icon: Image.asset("assets/images/home.png",
                height: 20, width: 20, color: Colors.grey),
            activeIcon: Image.asset("assets/images/home.png",
                height: 22, width: 22, color: myprimarycolor),
            label: "Home"),
        BottomNavigationBarItem(
            icon: Image.asset("assets/images/ic_book.png",
                height: 20, width: 20, color: Colors.grey),
            activeIcon: Image.asset("assets/images/ic_book.png",
                height: 22, width: 22, color: myprimarycolor),
            label: "Study Material"),
        BottomNavigationBarItem(
            icon: Image.asset("assets/images/testseries.png",
                height: 20, width: 20, color: Colors.grey),
            activeIcon: Image.asset("assets/images/testseries.png",
                height: 22, width: 22, color: myprimarycolor),
            label: "Test Series"),
        BottomNavigationBarItem(
            icon: Image.asset("assets/images/news.png",
                height: 20, width: 20, color: Colors.grey),
            activeIcon: Image.asset("assets/images/news.png",
                height: 22, width: 22, color: myprimarycolor),
            label: "Student Desk"),
        BottomNavigationBarItem(
            icon: Image.asset("assets/images/user.png",
                height: 20, width: 20, color: Colors.grey),
            activeIcon: Image.asset("assets/images/user.png",
                height: 22, width: 22, color: myprimarycolor),
            label: "Account"),
      ],
      currentIndex: homeController.bottomTabIndex.value,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      onTap: (position) {
        homeController.changeTabIndex(position); // Notify GetX
      },
    ));
  }

  Future<bool> _onBackPressed() {
    if (homeController.bottomTabIndex.value != 0) {
      setState(() {
        homeController.bottomTabIndex.value = 0;
      });
      return Future.value(false); // Prevents the default back button behavior
    }
    DateTime now = DateTime.now();
    if (ctime == null || now.difference(ctime) > const Duration(seconds: 2)) {
      //add duration of press gap
      ctime = now;
      showSnackbar("Want to exit!",'Press Back Button Again to Exit');
      return Future.value(false);
    }
    return Future.value(true);
  }


}




/*
import 'package:aftbioerp/controller/HomeController.dart';
import 'package:aftbioerp/controller/LoginController.dart';
import 'package:aftbioerp/theme/mythemcolor.dart';
import 'package:aftbioerp/utils/AppBars.dart';
import 'package:aftbioerp/utils/styleUtil.dart';
import 'package:aftbioerp/view/attendence/Attendence.dart';
import 'package:aftbioerp/view/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/AppBars.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final HomeController homeController = Get.put(HomeController());

  // int selectedPosition = 0;
  List<Widget> listBottomWidget = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    addHomePage();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: myStatusBar(),
      bottomNavigationBar: myBottomNavigationBar(),
      body: SafeArea(
        child: Obx((){
          if(homeController.isLoading.value){
            return Center(child: CircularProgressIndicator());
          }
          return  Builder(builder: (context) {
            return listBottomWidget[homeController.bottomTabIndex.value]; // Use .value
          });
          */
/* Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: [BoxShadow(
                      color: isDarkTheme ? Colors.blueGrey.shade900 : Colors.grey.shade300,
                      blurRadius: 0.5,
                      offset: Offset(0, 0.5),
                    ),]
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: (){
                        scaffoldKey.currentState?.openDrawer();
                      },
                        child: Icon(Icons.menu, size: 30,)
                    ),
                    SizedBox(width: 10,),
                    Container(width: 1, height: 30, color: Colors.grey.shade300,),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good afternoon",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "Gopal Kumawat",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 10,),
                          setCachedImage("q", 50, 50, 150)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Builder(builder: (context) {
                      return listBottomWidget[selectedPosition];
                    }),
                  ],
                ),
              ),
            ],
          );*//*

        }
        ),
      ),
    );
  }
  Obx myBottomNavigationBar() {
    return Obx(() => BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      useLegacyColorScheme: false,
      selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFamily: "b",
          color: myprimarycolor.shade900),
      unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: "b",
          color: Theme.of(context).hintColor),
      items: [
        BottomNavigationBarItem(
            icon: Image.asset(
                height: 20,
                width: 20,
                "assets/images/home.png",
                color: Theme.of(context).hintColor),
            activeIcon: Image.asset(
                height: 22,
                width: 22,
                "assets/images/home.png",
                color: myprimarycolor),
            label: ("Home")),
        BottomNavigationBarItem(
            icon: Image.asset(
                height: 20,
                width: 20,
                "assets/images/attendance.png",
                color: Theme.of(context).hintColor),
            activeIcon: Image.asset(
                height: 22,
                width: 22,
                "assets/images/attendance.png",
                color: myprimarycolor),
            label: ("Attendance")),
        BottomNavigationBarItem(
            icon: Image.asset(
                height: 20,
                width: 20,
                "assets/images/leave.png",
                color: Theme.of(context).hintColor),
            activeIcon: Image.asset(
                height: 22,
                width: 22,
                "assets/images/leave.png",
                color: myprimarycolor),
            label: ("Leave")),
        BottomNavigationBarItem(
            icon: Image.asset(
                height: 20,
                width: 20,
                "assets/images/user.png",
                color: Theme.of(context).hintColor),
            activeIcon: Image.asset(
                height: 22,
                width: 22,
                "assets/images/user.png",
                color: myprimarycolor),
            label: ("Account")),
      ],
      currentIndex: homeController.bottomTabIndex.value,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).canvasColor,
      onTap: (position) {
        homeController.changeTabIndex(position); // Notify change
      },
    ));
  }

  BottomNavigationBar myBottomNavigationBar1(BuildContext context){
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      useLegacyColorScheme: false,
      selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFamily: "b",
          color: myprimarycolor.shade900),
      unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: "b",
          color: Theme.of(context).hintColor),
      items: [
        BottomNavigationBarItem(
            icon: Image.asset(
                height: 20,
                width: 20,
                "assets/images/home.png",
                color: Theme.of(context).hintColor),
            activeIcon: Image.asset(
                height: 22,
                width: 22,
                "assets/images/home.png",
                color: myprimarycolor),
            label: ("Home")),
        BottomNavigationBarItem(
            icon: Image.asset(
                height: 20,
                width: 20,
                "assets/images/attendance.png",
                color: Theme.of(context).hintColor),
            activeIcon: Image.asset(
                height: 22,
                width: 22,
                "assets/images/attendance.png",
                color: myprimarycolor),
            label: ("Attendance")),
        BottomNavigationBarItem(
            icon: Image.asset(
                height: 20,
                width: 20,
                "assets/images/leave.png",
                color: Theme.of(context).hintColor),
            activeIcon: Image.asset(
                height: 22,
                width: 22,
                "assets/images/leave.png",
                color: myprimarycolor),
            label: ("Leave")),
        BottomNavigationBarItem(
            icon: Image.asset(
                height: 20,
                width: 20,
                "assets/images/user.png",
                color: Theme.of(context).hintColor),
            activeIcon: Image.asset(
                height: 22,
                width: 22,
                "assets/images/user.png",
                color: myprimarycolor),
            label: ("Account")),
      ],
    currentIndex: homeController.bottomTabIndex.value,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Theme.of(context).canvasColor,
    onTap: (position) {
    homeController.changeTabIndex(position); // Notify change
    },
    );
  }
  void addHomePage() {
    listBottomWidget.add(Home());
    listBottomWidget.add(Attendence());
    listBottomWidget.add(const Center(child: Text("Leave"),));
    listBottomWidget.add(const Center(child: Text("Account"),));
  }
}
*/
