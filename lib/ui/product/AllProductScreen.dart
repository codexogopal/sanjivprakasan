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

class AllProductScreen extends StatefulWidget {

  const AllProductScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen>
    with TickerProviderStateMixin {
  final CategoriesController catCtrl = Get.put(CategoriesController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  double screenHeight = 0.0;
  late ScrollController _scrollController;
  bool isLoadMoreRunning = false;
  int totalPages = 1;
  int cPageNo = 1;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_loadMore);
    Timer(Duration(milliseconds: 100), (){
      getData();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    _scrollController.dispose();
    super.dispose();
  }
  void _loadMore() {
    if(!catCtrl.noMoreData.value){
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isLoadMoreRunning &&
        !catCtrl.isLoading.value) {
      setState(() {
        isLoadMoreRunning = true;
        cPageNo++;
      });

      catCtrl.getAllProductList(cPageNo.toString()).then((_) {
        setState(() {
          isLoadMoreRunning = false;
        });
      });
    }
    }
  }

  Future<void> getData() async {
    cPageNo = 1;
      catCtrl.getAllProductList("1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: myStatusBar(context),
      body: SafeArea(
        child: Obx(() {
          if (catCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }

          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              children: [
                otherAppBar(context, "All Books", true),
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
        Flexible(
          child: Container(
            color: Theme.of(context,).colorScheme.primaryContainer,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: GridView.builder(
              padding: const EdgeInsets.all(0),
              controller: _scrollController,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: screenHeight < 825 ? 0.560 : 0.61,
              ),
              itemCount: catCtrl.allProductList.length,
              itemBuilder: (context, index) {
                final product = catCtrl.allProductList[index];
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
        ),
        if (isLoadMoreRunning && !catCtrl.noMoreData.value)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(child: apiLoader()),
          ),

      ],
    );
  }
}
