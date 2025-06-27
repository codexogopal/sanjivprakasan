import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:sanjivprkashan/ui/web/MyWebView.dart';

import '../../controller/CurrentAfairsController.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';

class CurrentAfairsScreen extends StatefulWidget {
  const CurrentAfairsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CurrentAfairsScreen();
}


class _CurrentAfairsScreen extends State<CurrentAfairsScreen> {
  final CurrentAfairsController caCtrl = Get.put(CurrentAfairsController());

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late ScrollController _scrollController;
  bool isLoadMoreRunning = false;
  int totalPages = 1;
  int cPageNo = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_loadMore);
  }
  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    _scrollController.dispose();
    super.dispose();
  }
  void _loadMore() {
    if(!caCtrl.noMoreData.value){
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          !isLoadMoreRunning &&
          !caCtrl.isLoading.value) {
        setState(() {
          isLoadMoreRunning = true;
          cPageNo++;
        });

        caCtrl.getCurrentAffairsList(cPageNo.toString()).then((_) {
          setState(() {
            isLoadMoreRunning = false;
          });
        });
      }
    }
  }

  Future<void> getData() async {
    cPageNo = 1;
    caCtrl.getCurrentAffairsList("1");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      // appBar: myStatusBar(context),
      body: SafeArea(
        child: Obx(() {
          if (caCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }
          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              children: [
                otherAppBar(context, "Current Affairs", false),
                Flexible(
                  child: addBody(),
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
        Expanded(child: catVeiw()),
        if (isLoadMoreRunning && !caCtrl.noMoreData.value)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(child: apiLoader()),
          ),
      ],
    );
  }

  Widget catVeiw(){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final mainCats = caCtrl.allProductList;
    if (caCtrl.allProductList.isEmpty) {
      return emptyWidget(context, "No current affairs found"); // Or your loader
    }
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: mainCats.length,
          itemBuilder: (context, index) {
            final product = mainCats[index];
            return Column(
              children: [
                if(index == 0)
                  SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    Get.to(()=> MyWebView(mPdfFile: caCtrl.pdfWebBashUrl.value+product.currentAffairsPdf));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(0),
                     /* boxShadow: [
                        BoxShadow(
                          color: isDarkTheme ? myprimarycolor.withAlpha(80) : Colors.black12,
                          blurRadius: 4,
                          offset: Offset(-0.5, 0),
                        ),
                      ],*/
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset("assets/images/book.png", height: 25,),
                              const SizedBox(width: 10,),
                              Flexible(
                                child: Text(product.currentAffairsName,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal
                                ),),
                              ),

                            ],
                          ),
                        ),
                        Icon(Icons.navigate_next, size: 30,)
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });

  }

}