import 'dart:async';
import 'dart:io' show Platform;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/CategoriesController.dart';
import 'package:sanjivprkashan/model/books/ChildCategoryModel.dart';
import 'package:sanjivprkashan/ui/product/ProductDetailScreen.dart';
import 'package:upgrader/upgrader.dart';

import '../../controller/HomeController.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';

class SubCatWishScreen extends StatefulWidget {
  final String catId;
  final String title;

  const SubCatWishScreen({super.key, required this.catId, required this.title});

  @override
  State<StatefulWidget> createState() => _SubCatWishScreenState();
}

class _SubCatWishScreenState extends State<SubCatWishScreen>
    with TickerProviderStateMixin {
  final CategoriesController catCtrl = Get.put(CategoriesController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;
  double screenHeight = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 100), (){
      getData();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    await catCtrl.getChildCat({"category_id": widget.catId});
    if (_tabController != null) {
      _tabController?.dispose();
    }
    _tabController = TabController(
      length: catCtrl.childCatList.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: myStatusBar(context),
      body: SafeArea(
        child: Obx(() {
          if (catCtrl.isLoading.value || _tabController == null) {
            return Center(child: apiLoader());
          }

          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              children: [
                otherAppBar(context, widget.title, true),
                Flexible(child: tabvew()),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget tabvew() {
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
            isScrollable: true,
            labelColor: myprimarycolor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: myprimarycolor,
            tabs:
                catCtrl.childCatList
                    .map(
                      (cat) => Tab(
                        child: Text(
                          cat.catName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: "os",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children:
                catCtrl.childCatList.map((cat) {
                  return RefreshIndicator(
                    onRefresh: () => getData(),
                    child:
                        cat.products.isEmpty
                            ? SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height: 400,
                                child: Center(
                                  child: emptyWidget(context, "No book found"),
                                ),
                              ),
                            )
                            : Container(
                              color: Theme.of(context,).colorScheme.primaryContainer,
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: GridView.builder(
                                padding: const EdgeInsets.all(0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                      childAspectRatio: screenHeight < 825 ? 0.560 : 0.61,
                                    ),
                                itemCount: cat.products.length,
                                itemBuilder: (context, index) {
                                  final product = cat.products[index];
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Get.to(()=> ProductDetailScreen(pId : product.productId.toString()));
                                        },
                                        child: Container(
                                          width: screenWidth > 400 ? 200 : 165,
                                          margin: EdgeInsets.fromLTRB(0, 10, 0, 5,),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    isDarkTheme
                                                        ? myprimarycolor
                                                            .withAlpha(80)
                                                        : Colors.black12,
                                                blurRadius: 4,
                                                offset: Offset(-0.5, 0),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  1.0,
                                                ),
                                                child: setCachedImage(
                                                  product.productImage,
                                                  screenWidth > 400 ? 210 : 200,
                                                  screenWidth > 400 ? 200 : 175,
                                                  5,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Text(
                                                  product.productName ?? '',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(fontSize: 12),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                    ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "MRP: ",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                fontSize: 11,
                                                              ),
                                                        ),
                                                        Text(
                                                          "₹${product.productEbookPrice ?? ''} ",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                color:
                                                                    myprimarycolor,
                                                                fontSize: 13,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "EBook: ",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                fontSize: 11,
                                                              ),
                                                        ),
                                                        Text(
                                                          "₹${product.productEbookSellingPrice ?? ''} ",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                color:
                                                                    myprimarycolor,
                                                                fontSize: 13,
                                                              ),
                                                        ),
                                                        Text(
                                                          "(${product.productEbookDiscount ?? '0'}%)",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                color:
                                                                    Colors.green,
                                                                fontSize: 13,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Physical: ",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                fontSize: 11,
                                                              ),
                                                        ),
                                                        Text(
                                                          product.productPhySellingPrice !=
                                                                  ""
                                                              ? "₹${product.productPhySellingPrice ?? ''} "
                                                              : "Out of Stock",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                color:
                                                                    myprimarycolor,
                                                                fontSize: 13,
                                                              ),
                                                        ),
                                                        Text(
                                                          product.productPhySellingPrice !=
                                                                  ""
                                                              ? "(${product.productPhyDiscount ?? '0'}%)"
                                                              : "",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                color:
                                                                    Colors.green,
                                                                fontSize: 13,
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
                                    ],
                                  );
                                },
                              ),
                            ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget tabvew11() {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          height: 25,
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          // margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          // decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSecondary),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: myprimarycolor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: myprimarycolor,
            tabs:
                catCtrl.childCatList
                    .map(
                      (cat) => Tab(
                        child: Text(
                          cat.catName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: "os",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children:
                catCtrl.childCatList.map((cat) {
                  if (cat.products.isEmpty) {
                    return const Center(child: Text("No products available"));
                  }

                  return Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            childAspectRatio: 0.63,
                          ),
                      itemCount: cat.products.length,
                      itemBuilder: (context, index) {
                        final product = cat.products[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 175,
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        isDarkTheme
                                            ? myprimarycolor.withAlpha(80)
                                            : Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(-0.5, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: setCachedImage(
                                      product.productImage,
                                      200,
                                      175,
                                      5,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      product.productName ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "MRP: ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(fontSize: 11),
                                            ),
                                            Text(
                                              "₹${product.productEbookPrice ?? ''} ",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                color: myprimarycolor,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Text(
                                              "EBook: ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(fontSize: 11),
                                            ),
                                            Text(
                                              "₹${product.productEbookSellingPrice ?? ''} ",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                color: myprimarycolor,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              "(${product.productEbookDiscount ?? '0'}%)",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                color: Colors.green,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Text(
                                              "Physical: ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(fontSize: 11),
                                            ),
                                            Text(
                                              product.productPhySellingPrice !=
                                                      ""
                                                  ? "₹${product.productPhySellingPrice ?? ''} "
                                                  : "Out of Stock",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                color: myprimarycolor,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              product.productPhySellingPrice !=
                                                      ""
                                                  ? "(${product.productPhyDiscount ?? '0'}%)"
                                                  : "",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                color: Colors.green,
                                                fontSize: 13,
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
                          ],
                        );
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
