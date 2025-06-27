
import 'dart:io' show Platform;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:sanjivprkashan/ui/account/AccountScreen.dart';
import 'package:sanjivprkashan/ui/categories/AllCatgoryScreen.dart';
import 'package:sanjivprkashan/ui/categories/SubCatWishScreen.dart';
import 'package:sanjivprkashan/ui/product/AllProductScreen.dart';
import 'package:upgrader/upgrader.dart';

import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';
import '../../controller/HomeController.dart';
import '../product/ProductDetailScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  AppUpdateInfo? _updateInfo;
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;
  @override
  void initState() {
    super.initState();
    checkForUpdate();
    // homeController.getNewUpdate();
  }

  // Add the checkForUpdate function
  Future<void> checkForUpdate() async {
    if (Platform.isAndroid) {
      InAppUpdate.checkForUpdate()
          .then((info) {
        setState(() {
          _updateInfo = info;
          _updateInfo?.updateAvailability ==
              UpdateAvailability.updateAvailable
              ? performImmediateUpdate() // Call the extracted function
              : print('Update not available');
        });
      })
          .catchError((e) {
        print('InAppUpdateError2 $e');
      });
    }
  }
  int findLargest(List<int> arr) {
    return arr.reduce((a, b) => a == b ? a : b);
  }
  void performImmediateUpdate() {
    InAppUpdate.performImmediateUpdate().catchError((e) {
      // print("helllo ${e.toString()}");
      return AppUpdateResult.inAppUpdateFailed;
    });
  }
  Future<void> getData() async{
    homeController.getUserData;
    homeController.getDashboardData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(child: AccountScreen(showAppBar: false,)),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      // appBar: myStatusBar(context),
      body: SafeArea(
        child: Obx(() {
          if (homeController.isLoading.value) {
            return Center(child: apiLoader());
          }
          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              children: [
                homeAppBar(context, scaffoldKey),
                Flexible(
                  child: ListView(
                    children: [
                      Platform.isIOS ?
                      UpgradeAlert(
                        child: addBody(),
                      ) :
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
        if(homeController.sliderItemListData.isNotEmpty)
        SizedBox(height: 10,),
        if(homeController.sliderItemListData.isNotEmpty)
        sliderView(),
        if(homeController.categoryListData.isNotEmpty)
        catVeiw()
      ],
    );
  }

  Widget catVeiw(){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final mainCats = homeController.categoryListData;
    if (homeController.categoryListData.isEmpty) {
      return apiLoader(); // Or your loader
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                    ),
                    InkWell(
                      onTap: (){
                        Get.to(()=> AllCatgoryScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "View all",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: myprimarycolor, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // Prevent internal scrolling
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  itemCount: mainCats.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: screenHeight < 825 ? 1.55 : 1.70,
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

        if(homeController.productListData.isNotEmpty)
        SizedBox(height: 10,),
        if(homeController.productListData.isNotEmpty)
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "All books",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Get.to(()=> AllProductScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "View all",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: myprimarycolor, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final products = homeController.productListData ?? [];
                return SizedBox(
                  height: screenWidth > 400 ? 325 : 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Row(
                        children: [
                          if(index == 0)
                            const SizedBox(width: 10,),
                          InkWell(
                            onTap: (){
                              Get.to(()=> ProductDetailScreen(pId : product.productId.toString()));
                            },
                            child: Container(
                              width: screenWidth > 400 ? 190 : 170,
                              margin: EdgeInsets.fromLTRB(8, 10, 8, 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      color: isDarkTheme ? myprimarycolor.withAlpha(80) : Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(-0.5, 0)
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: setCachedImage(product.productImage, screenWidth > 400 ? 190 : 180, screenWidth > 400 ? 190 : 170, 5),
                                  ),
                                  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(product.productName ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 12
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("MRP: ",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontSize: 11
                                          ),
                                        ),
                                        Text("₹${product.productEbookPrice ?? ''} ",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: myprimarycolor,
                                            fontSize: 13
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3,),
                                    Row(
                                      children: [
                                        Text("EBook: ",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontSize: 11
                                          ),
                                        ),
                                        Text("₹${product.productEbookSellingPrice ?? ''} ",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: myprimarycolor,
                                            fontSize: 13
                                          ),
                                        ),
                                        Text("(${product.productEbookDiscount ?? '0'}%)",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: Colors.green,
                                            fontSize: 13
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3,),
                                    Row(
                                      children: [
                                        Text("Physical: ",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontSize: 11
                                          ),
                                        ),
                                        Text("₹${product.productPhySellingPrice ?? ''} ",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: myprimarycolor,
                                            fontSize: 13
                                          ),
                                        ),
                                        Text("(${product.productPhyDiscount ?? '0'}%)",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: Colors.green,
                                              fontSize: 13
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                                ],
                              ),
                            ),
                          ),
                          if(index == products.length-1)
                            const SizedBox(width: 10,),
                        ],
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),


      ],
    );
  }

  Widget sliderView() {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    late List<Widget> imageSliders = homeController.sliderItemListData
        .map((item) => InkWell(
      onTap: () {

      },
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: Stack(
            children: <Widget>[
              ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  child: setCachedImage(homeController.sliderImagePath.value+item['slider_image'], 120, double.infinity, 10)
              ),
            ],
          )),
    ))
        .toList();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
                height: 120,
                viewportFraction: .92,
                // aspectRatio: 1.2,
                // viewportFraction: .9,
                aspectRatio: 1.2,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: homeController.sliderItemListData.asMap().entries.map((entry) {
              return GestureDetector(
                // onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == entry.key
                          ? myprimarycolor.shade100
                          : Colors.grey.shade200
                      ,
                    ),
                  )
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
