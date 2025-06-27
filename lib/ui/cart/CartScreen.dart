import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/CartController.dart';
import 'package:sanjivprkashan/ui/account/address/MyAddressList.dart';

import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';

class CartScreen extends StatefulWidget {

  const CartScreen({super.key});

  @override
  State<StatefulWidget> createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  final CartController cartCtrl = Get.put(CartController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    Timer(Duration(milliseconds: 10), () {
      cartCtrl.getCartList();
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
                  return (cartCtrl.isLoading.value || cartCtrl.cartItemList.isEmpty) ? SizedBox() : Container(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(()=> MyAddressList(pType: "cart",));
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),

                      child:
                      !cartCtrl.isProductAdding.value
                          ? Text(
                        'Process to Checkout',
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
                otherAppBar(context, "My Cart", true),
                if (cartCtrl.cartItemList.isEmpty)
                    emptyWidget(context, "Cart is empty"),
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
        if(cartCtrl.cartItemList.isNotEmpty)
        catVeiw(),
        SizedBox(height: 10,),
        if(cartCtrl.cartItemList.isNotEmpty)
        summeryView(),
      ],
    );
  }

  Widget summeryView(){
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cart Summary",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Item Total",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).hintColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "₹${double.parse(cartCtrl.cartSummary["item_total"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "GST",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).hintColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "+₹${double.parse(cartCtrl.cartSummary["item_gst"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).hintColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "-₹${double.parse(cartCtrl.cartSummary["item_total_discount"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Colors.green,
                      fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shipping Charge",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).hintColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    cartCtrl.cartSummary["item_shipping"] == 0 ? "Free" :
                  "₹${double.parse(cartCtrl.cartSummary["item_shipping"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: cartCtrl.cartSummary["item_shipping"] == 0 ? Colors.green : null,
                      fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "₹${double.parse(cartCtrl.cartSummary["total"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: myprimarycolor, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget catVeiw(){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final mainCats = cartCtrl.cartItemList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Obx(() {
                if (cartCtrl.isLoading.value) {
                  return Center(child: apiLoader());
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // Prevent internal scrolling
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  itemCount: mainCats.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    childAspectRatio: 2.2,
                  ),
                  itemBuilder: (context, index) {
                    final item = mainCats[index];
                    return InkWell(
                      onTap: (){

                      },
                      child: Container(
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: setCachedImage(
                                item.product.productImage,
                                130,
                                90,
                                5,
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          "${item.product.productName}" ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(fontSize: 12),
                                        ),

                                        Text(
                                          item.cartProductType == 0 ? "Ebook" : "Physical",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                            color: Theme.of(context).hintColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Text(
                                              "₹${item.cartProductType == 0 ? item.product.productEbookSellingPrice : item.product.productPhySellingPrice ?? ''} ",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                color: myprimarycolor,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "₹${item.cartProductType == 0 ? item.product.productEbookPrice : item.product.productPhyPrice ?? ''} ",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                fontSize: 14,
                                                color: Theme.of(context).hintColor,
                                                decoration: TextDecoration.lineThrough,
                                                decorationColor:
                                                Theme.of(context).hintColor,
                                                decorationThickness: 3.0,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "(${item.cartProductType == 0 ? item.product.productEbookDiscount : item.product.productPhyDiscount ?? '0'}%)",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                color: Colors.green,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                Map<String, String> cartData = {
                                                  "product_id" : item.cartProductId.toString() ?? "",
                                                  "selectedPrice" : item.cartProductType.toString() ?? "",
                                                };
                                                cartCtrl.removeCartItem(cartData);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Theme.of(context).hintColor, width: 1),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.delete_forever, size: 14, color: Theme.of(context).hintColor,),
                                                    Text(
                                                      "Remove",
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.titleMedium?.copyWith(
                                                          color: Theme.of(context).hintColor,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if(item.cartProductType == 1)
                                              (cartCtrl.isProductAdding.value || cartCtrl.isProductRemoving.value) ? apiLoader(size: 40) : Container(
                                              width: 80,
                                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(color: Theme.of(context).hintColor, width: 1),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      Map<String, String> cartData = {
                                                        "product_id" : item.cartProductId.toString() ?? "",
                                                        "selectedPrice" : item.cartProductType.toString() ?? "",
                                                      };
                                                      cartCtrl.removeCartItem(cartData);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4),
                                                      child: Icon(
                                                        Icons.remove ,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    item.cartQty.toString(),
                                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                      color: myprimarycolor,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: (){
                                                      Map<String, String> pData = {
                                                        "product_id" : item.cartProductId.toString(),
                                                        "selectedPrice" : item.cartProductType.toString(),
                                                        "qty" : "1",
                                                      };
                                                      cartCtrl.addItemToCart(pData);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4),
                                                      child: Icon(
                                                        Icons.add ,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
  void addToCart(){

  }
}
