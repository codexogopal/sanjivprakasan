import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/ui/product/ProductDetailScreen.dart';
import '../../controller/MySearchController.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';

class SearchScreen extends StatefulWidget {

  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final MySearchController catCtrl = Get.put(MySearchController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController mobileController = TextEditingController();
  double screenHeight = 0.0;
  late ScrollController _scrollController;
  bool isLoadMoreRunning = false;
  int totalPages = 1;
  int cPageNo = 1;
  @override
  void initState() {
    catCtrl.searchedValue.value = "";
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: myStatusBar(context),
      body: SafeArea(
        child: Column(
          children: [
            otherAppBar(context, "Search", true),
            Container(
              padding:
              const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  onChanged: (value) {
                    if(value.length > 3){
                      catCtrl.searchedValue.value = value;
                      catCtrl.getSearchData(value);
                    }else{
                      catCtrl.searchedValue.value = value;
                      if(value.length < 2) {
                        catCtrl.searchedValue.value = "";
                        catCtrl.searchProductList.clear();
                      }
                    }

                  },
                  cursorColor: Colors.grey,
                  scrollPadding: EdgeInsets.only(
                      bottom:
                      MediaQuery.of(context).viewInsets.bottom),
                  controller: mobileController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Search any book here...',
                    hintStyle:  Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600
                    ),
                    counterText: "",
                    floatingLabelBehavior:
                    FloatingLabelBehavior.never,
                    contentPadding:
                    const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(50, 88, 88, 88),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(50, 88, 88, 88),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(child: tabvew()),
          ],
        )
      ),
    );
  }

  Widget tabvew() {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      if (catCtrl.searchedValue.value == "") {
        return Center(child: emptyWidget(context, "Search any book here...."));
      }
      if (catCtrl.searchProductList.isEmpty) {
        return Center(child: emptyWidget(context, "No search result found for ${catCtrl.searchedValue.value}"));
      }
        return Column(
          children: [
            Flexible(
              child: Container(
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
                  itemCount: catCtrl.searchProductList.length,
                  itemBuilder: (context, index) {
                    final product = catCtrl.searchProductList[index];
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
          ],
        );
      }
    );
  }
}
