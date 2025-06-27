import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/StudentDeskController.dart';
import '../../model/studentDesk/StudentDeskModel.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';
import 'StudentDeskDetail.dart';

class StudentDeskScreen extends StatefulWidget {
  const StudentDeskScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StudentDeskScreenState();
}

class _StudentDeskScreenState extends State<StudentDeskScreen>
    with TickerProviderStateMixin {
  final StudentDeskController stDeskCtrl = Get.put(StudentDeskController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;
  double screenHeight = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 100), () {
      getData();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    await stDeskCtrl.getStudentDeskData();
    if (_tabController != null) {
      _tabController?.dispose();
    }
    _tabController = TabController(
      length: stDeskCtrl.stDeskData.value?.menu.children?.length ?? 0,
      vsync: this,
    );
    setState(() {}); // Add this to ensure UI updates after data load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: myStatusBar(context),
      body: SafeArea(
        child: Obx(() {
          if (stDeskCtrl.isLoading.value || _tabController == null) {
            return Center(child: apiLoader());
          }

          final menuData = stDeskCtrl.stDeskData.value?.menu;
          if (menuData == null || menuData.children == null) {
            return Center(child: Text("No data available"));
          }

          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              children: [
                otherAppBar(context, "Student Desk", false),
                Flexible(child: _buildTabView(menuData)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabView(MenuItem menuData) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: 25,
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: menuData.children!.length <=3 ? false : true,
            labelColor: myprimarycolor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: myprimarycolor,
            tabs: menuData.children!
                .map((cat) => Tab(
              child: Text(
                cat.menuName,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: "os",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ))
                .toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: menuData.children!.map((category) {
              return _buildCategoryView(category, isDarkTheme, screenWidth);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryView(MenuItem category, bool isDarkTheme, double screenWidth) {
    final subItems = category.subchildren ?? [];
    if (subItems.isEmpty) {
      return StudentDeskDetail(pageModel: category.pages!, showingHome: true);

      /*return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 400,
          child: Center(
            child: emptyWidget(context, "No data found"),
          ),
        ),
      );*/
    }

    return RefreshIndicator(
      onRefresh: () => getData(),
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: subItems.length,
          itemBuilder: (context, index) {
            final item = subItems[index];
            return _buildGridItem(item, isDarkTheme, screenWidth);
          },
        ),
      ),
    );
  }

  Widget _buildGridItem(MenuItem? item, bool isDarkTheme, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (item is SubMenuItem && item.pages != null) {
              Get.to(()=> StudentDeskDetail(pageModel: item.pages!,showingHome: false));
            }
          },
          child: Container(
            width: screenWidth-30,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDarkTheme
                      ? myprimarycolor.withAlpha(80)
                      : Colors.black12,
                  blurRadius: 4,
                  offset: Offset(-0.5, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/book.png", width: 30, height: 30,),
                  const SizedBox(width: 10,),
                  Text(
                    item?.menuName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPageContent(PageModel page) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(page.pageName),
        content: SingleChildScrollView(
          child: HtmlWidget(page.pageContent), // You'll need flutter_widget_from_html package
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}


class StudentDeskScreen1 extends StatefulWidget {
  const StudentDeskScreen1({super.key});

  @override
  State<StudentDeskScreen1> createState() => _StudentDeskScreenState1();
}

class _StudentDeskScreenState1 extends State<StudentDeskScreen1>
    with TickerProviderStateMixin {
  final StudentDeskController stDeskCtrl = Get.put(StudentDeskController());
  TabController? _tabController;
  List<bool> _expandedItems = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await stDeskCtrl.getStudentDeskData();
    if (stDeskCtrl.stDeskData.value != null) {
      _tabController = TabController(
        length: stDeskCtrl.stDeskData.value!.menu.children?.length ?? 0,
        vsync: this,
      );
      // Initialize expanded state for all subitems
      _expandedItems = List.filled(
        stDeskCtrl.stDeskData.value!.menu.children?.length ?? 0,
        false,
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Desk'),
        bottom: _buildTabBar(),
      ),
      body: _buildTabBarView(),
    );
  }

  PreferredSizeWidget? _buildTabBar() {
    if (stDeskCtrl.stDeskData.value == null || _tabController == null) {
      return null;
    }

    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: stDeskCtrl.stDeskData.value!.menu.children!
          .map((category) => Tab(text: category.menuName))
          .toList(),
    );
  }

  Widget _buildTabBarView() {
    return Obx(() {
      if (stDeskCtrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (stDeskCtrl.stDeskData.value == null || _tabController == null) {
        return const Center(child: Text('No data available'));
      }

      return TabBarView(
        controller: _tabController,
        children: stDeskCtrl.stDeskData.value!.menu.children!
            .asMap()
            .entries
            .map((entry) {
          final index = entry.key;
          final category = entry.value;
          return _buildCategoryView(category, index);
        }).toList(),
      );
    });
  }

  Widget _buildCategoryView(MenuItem category, int tabIndex) {
    final subItems = category.subchildren ?? [];

    return SingleChildScrollView(
      child: Column(
        children: [
          ...subItems.asMap().entries.map((entry) {
            final subIndex = entry.key;
            final subItem = entry.value;

            return Card(
              margin: const EdgeInsets.all(8),
              child: ExpansionTile(
                key: Key('$tabIndex-$subIndex'),
                initiallyExpanded: _expandedItems.length > tabIndex
                    ? _expandedItems[tabIndex]
                    : false,
                title: Text(subItem.menuName),
                children: [
                  if (subItem.pages != null)
                    _buildPageItem(subItem.pages!),
                  if (subItem.children != null)
                    ...subItem.children!.map((child) =>
                        _buildChildItem(child)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPageItem(PageModel page) {
    return ListTile(
      title: Text(page.pageName),
      onTap: () {
        // Navigate to page detail screen
        // Get.to(() => PageDetailScreen(page: page));
      },
    );
  }

  Widget _buildChildItem(MenuItem child) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListTile(
        title: Text(child.menuName),
        onTap: () {
          if (child.pages != null) {
            // Get.to(() => PageDetailScreen(page: child.pages));
          }
        },
      ),
    );
  }
}
