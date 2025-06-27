
import 'dart:io' show Platform;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:sanjivprkashan/controller/CategoriesController.dart';
import 'package:sanjivprkashan/ui/categories/SubCatWishScreen.dart';
import 'package:upgrader/upgrader.dart';

import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';
import '../product/ProductDetailScreen.dart';


class AllCatgoryScreen extends StatefulWidget {
  const AllCatgoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => AllCatgoryScreenState();
}

class AllCatgoryScreenState extends State<AllCatgoryScreen> {
  final CategoriesController catCtrl = Get.put(CategoriesController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    // catCtrl.getNewUpdate();
  }

  Future<void> getData() async{
    catCtrl.getAllCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      // appBar: myStatusBar(context),
      body: SafeArea(
        child: Obx(() {
          if (catCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }
          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              children: [
                otherAppBar(context, "All Categories", true),
                Flexible(
                  child: ListView(
                    children: [
                      addBody(),
                      SizedBox(height: 50,),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget addBody(){
    return Column(
      children: [
        SizedBox(height: 10,),
        catVeiw()
      ],
    );
  }

  Widget catVeiw(){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final mainCats = catCtrl.categoryListData;
    if (catCtrl.categoryListData.isEmpty) {
      return emptyWidget(context, null); // Or your loader
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Obx(() {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // Prevent internal scrolling
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 7),
                  itemCount: mainCats.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: screenHeight < 825 ? 2.35 : 2.5,
                  ),
                  itemBuilder: (context, index) {
                    final item = mainCats[index];
                    return InkWell(
                      onTap: (){
                        Get.to(()=> SubCatWishScreen(catId: item.catId.toString(), title: item.catName,));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 65,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isDarkTheme ? myprimarycolor.withAlpha(30) : Color(0XFFede8e1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(child: Text(item.catName ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium?.
                              copyWith(fontSize: 13),
                            )),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

}
