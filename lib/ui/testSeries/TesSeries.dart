import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjivprkashan/model/testSeries/TSMainCatModel.dart';
import 'package:sanjivprkashan/theme/mythemcolor.dart';
import 'package:sanjivprkashan/ui/testSeries/AllTestSeriesCourseScreen.dart';
import 'package:sanjivprkashan/utils/styleUtil.dart';
import 'package:get/get.dart';

import '../../controller/TestSeriesController.dart';
import '../../utils/AppBars.dart';
import 'MyTestSeriesCourseScreen.dart';
import 'SubCatTestSeriesCourseScreen.dart';



class TestSeriesScreen extends StatefulWidget {
  const TestSeriesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TestSeriesScreenState();
}

class _TestSeriesScreenState extends State<TestSeriesScreen>
    with TickerProviderStateMixin {
  final TestSeriesController stDeskCtrl = Get.put(TestSeriesController());
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
    await stDeskCtrl.getAllTsCatList();
    if (_tabController != null) {
      _tabController?.dispose();
    }
    _tabController = TabController(
      length: stDeskCtrl.allTsCatList.length+1,
      vsync: this,
    );
    setState(() {});
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

          if (stDeskCtrl.allTsCatList.isEmpty) {
            return Center(child: Text("No data available"));
          }

          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              children: [
                otherAppBar(context, "Test Series", false),
                Flexible(child: _buildTabView(stDeskCtrl.allTsCatList)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabView(List<TSMainCatModel> menuData) {
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
            isScrollable: (menuData.length + 1) <= 2 ? false : true,
            labelColor: myprimarycolor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: myprimarycolor,
            tabs: [
              // Original category tabs
              ...menuData.map((cat) => Tab(
                child: Text(
                  cat.courseCategoryName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )).toList(),
              // Additional "My Test Series" tab
              Tab(
                child: Text(
                  "My Test Series",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Original category views
              ...menuData.map((category) {
                return category.children.isEmpty ?
                AllTestSeriesCourseScreen(catID: category.courseCategoryId.toString(),title: category.courseCategoryName, isShowHeader: false,) :
                _buildCategoryView(category, isDarkTheme, screenWidth);
              }).toList(),
              // "My Test Series" view
              MyTestSeriesCourseScreen()
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryView(TSMainCatModel category, bool isDarkTheme, double screenWidth) {
    final subItems = category.children ?? [];

    /*if (subItems.isEmpty) {
      // stDeskCtrl.isTestCourse.value = false;
      debugPrint("Showing AllTestSeriesCourseScreen for ${category.courseCategoryName}");
      return AllTestSeriesCourseScreen(catID: category.courseCategoryId.toString(),title: category.courseCategoryName, isShowHeader: false,);

    }*/

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

  Widget _buildGridItem(ChildCategory item, bool isDarkTheme, double screenWidth) {

    bool isExpanded = stDeskCtrl.expandedSubjectIds.contains(item.courseCategoryId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            // Handle tap on subcategory
            if (item.subchildren.isNotEmpty) {
              // Navigate to next level or show subcategories
              // _showSubcategories(item.subchildren, item.courseCategoryName);
              if (isExpanded) {
                stDeskCtrl.expandedSubjectIds.remove(item.courseCategoryId);
              } else {
                stDeskCtrl.expandedSubjectIds.add(item.courseCategoryId);
              }
              setState(() {
              });
            }else{
              Get.to(()=> SubCatTestSeriesCourseScreen(catID: item.courseCategoryId.toString(),title: item.courseCategoryName, isShowHeader: true,));
            }
          },
          child: Container(
            width: screenWidth - 30,
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
                  Image.asset("assets/images/ic_test.png", width: 30, height: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.courseCategoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 12),
                        ),
                        if (item.subchildren.isNotEmpty)
                          Text(
                            "${item.subchildren.length} subjects",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Theme.of(context).hintColor),
                          ),
                      ],
                    ),
                  ),
                  if (item.subchildren.isNotEmpty)
                    Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 20, color: Theme.of(context).hintColor),
                  if (item.subchildren.isEmpty)
                    Icon(Icons.keyboard_arrow_right_rounded, size: 20, color: Theme.of(context).hintColor),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded)
          ...List.generate(item.subchildren.length ?? 0, (index) {
            var myItem = item.subchildren[index];
            return InkWell(
              onTap: (){
                Get.to(()=> SubCatTestSeriesCourseScreen(catID: myItem.courseCategoryId.toString(),title: myItem.courseCategoryName, isShowHeader: true,));
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(20, index == 0 ? 5 : 0, 20, 10),
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
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/ic_test.png", width: 24, height: 24),
                          SizedBox(width: 10,),
                          Text(myItem.courseCategoryName),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right_rounded, size: 20, color: Theme.of(context).hintColor),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}

