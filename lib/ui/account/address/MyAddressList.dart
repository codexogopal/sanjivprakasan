import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/AddressController.dart';
import 'package:sanjivprkashan/controller/HomeController.dart';
import 'package:sanjivprkashan/theme/mythemcolor.dart';
import 'package:sanjivprkashan/ui/account/address/AddAddress.dart';
import 'package:sanjivprkashan/ui/cart/CheckoutScreen.dart';

import '../../../utils/AppBars.dart';
import '../../../utils/styleUtil.dart';


class MyAddressList extends StatefulWidget {


  final String pType;
  const MyAddressList({super.key, required this.pType});


  @override
  State<StatefulWidget> createState() => _MyAddressListState();
}

class _MyAddressListState extends State<MyAddressList> {
  final AddressController cartCtrl = Get.put(AddressController());
  final HomeController homeCtrl = Get.put(HomeController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> getData() async {
    Timer(Duration(milliseconds: 10), () {
      cartCtrl.getAddressList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: myStatusBar(context),
      bottomNavigationBar: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                flex: 1,
                child: Obx(() {
                  return (cartCtrl.isLoading.value) ? SizedBox() : Container(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(AddAddress());
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),

                      child:
                      !cartCtrl.isProductAdding.value
                          ? Text(
                        'Add New Address',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.white),
                      )
                          : SizedBox(height: 50,child: buttonLoader()),
                    ),
                  );
                }
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: Obx((){
            if (cartCtrl.isLoading.value) {
              return Center(child: apiLoader());
            }
            return RefreshIndicator(
              onRefresh: () => getData(),
              child: Column(
                children: [
                  otherAppBar(context, "My Address", true, isCartShow: false),
                  if (cartCtrl.myAddressList.isEmpty && cartCtrl.defaultAddressItem.value?.uaId == 0)
                    emptyWidget(context, "No Address Added"),
                  Flexible(
                    child: ListView(children: [
                      addBody(), SizedBox(height: 50)]),
                  ),
                ],
              ),
            );
          })
      ),
    );
  }

  Widget addBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(cartCtrl.myAddressList.isNotEmpty || cartCtrl.defaultAddressItem.value?.uaId != 0)
          catVeiw(),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget catVeiw(){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final mainCats = cartCtrl.myAddressList;
    final dAddress = cartCtrl.defaultAddressItem.value;
    double pTypeSpace = widget.pType == "cart" ? 40 : 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(dAddress?.uaId != 0)
        SizedBox(height: 10,),
        if(dAddress?.uaId != 0)
        InkWell(
          onTap: (){
            widget.pType == "cart" ? Get.to(CheckoutScreen(userAddress: dAddress!,)) : null;
            widget.pType == "cart" ? cartCtrl.selectedAddress.value = dAddress!.uaId.toString() : "";
          },
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: widget.pType == "cart",
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                child:Icon(Icons.circle_outlined, size: 20, color: Theme.of(context).hintColor,)
                            ),
                          ),
                          SizedBox(width: widget.pType == "cart" ? 10 : 5,),
                          Text("${dAddress?.uaFname ?? ""} ${dAddress?.uaLname ?? ""}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,),),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text("Default",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).hintColor,
                            fontSize: 16,),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: pTypeSpace,),
                      Text(dAddress?.uaMobile ?? "",
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: pTypeSpace,),
                      Text("${dAddress?.uaShipHouse ?? ""}, ${dAddress?.uaShipAddress ?? ""}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: pTypeSpace,),
                      Text("${dAddress?.uaAppShipCity ?? ""} ${dAddress?.uaAppStateName ?? ""} ${dAddress?.uaShipPincode ?? ""}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),

                  if(widget.pType == "ac")
                    const SizedBox(height: 5,),
                  if(widget.pType == "ac")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: pTypeSpace,),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              minimumSize: const Size(40, 30),
                            ),
                            onPressed: (){
                              Get.to(AddAddress(userAddress: dAddress,));
                            }, child: Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )),
                        const SizedBox(width: 10,),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              minimumSize: const Size(60, 30),
                            ),
                            onPressed: (){
                              Map<String, String> userData = {
                                "ua_id" : dAddress?.uaId.toString() ?? ""
                              };
                              cartCtrl.deleteAddress(userData);
                            }, child: Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Obx(() {
                if (cartCtrl.isLoading.value) {
                  return Center(child: apiLoader());
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // Prevent internal scrolling
                  // padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  itemCount: mainCats.length,
                  itemBuilder: (context, index) {
                    final item = mainCats[index];
                    return
                      InkWell(
                          onTap: (){
                            widget.pType == "cart" ? Get.to(CheckoutScreen(userAddress: item,)) : null;
                          },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: widget.pType == "cart",
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                      child:Icon(Icons.circle_outlined, size: 20, color: Theme.of(context).hintColor,)
                                  ),
                                ),
                                SizedBox(width: widget.pType == "cart" ? 10 : 5,),
                                Text("${item.uaFname ?? ""} ${item.uaLname ?? ""}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,),),
                              ],
                            ),
                            const SizedBox(height: 3,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: pTypeSpace,),
                                Text(item.uaMobile ?? "",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: pTypeSpace,),
                                Text("${item.uaShipHouse ?? ""}, ${item.uaShipAddress ?? ""}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: pTypeSpace,),
                                Text("${item.uaAppShipCity ?? ""} ${item.uaAppStateName ?? ""} ${item.uaShipPincode ?? ""}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                            if(widget.pType == "ac")
                            const SizedBox(height: 5,),
                            if(widget.pType == "ac")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: pTypeSpace,),
                                OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  minimumSize: const Size(40, 30),
                                ),
                                    onPressed: (){
                                      Get.to(AddAddress(userAddress: item,));
                                }, child: Text(
                                  "Edit",
                                  style: TextStyle(
                                  fontSize: 12,
                                ),
                                )),
                                const SizedBox(width: 10,),
                                OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  minimumSize: const Size(60, 30),
                                ),
                                    onPressed: (){
                                      Map<String, String> userData = {
                                        "ua_id" : item.uaId.toString()
                                      };
                                      cartCtrl.deleteAddress(userData);
                                }, child: Text(
                                  "Delete",
                                  style: TextStyle(
                                  fontSize: 12,
                                ),
                                )),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(height: 10, color: Theme.of(context).colorScheme.secondaryContainer,),
                          ],
                        ),
                      )
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
