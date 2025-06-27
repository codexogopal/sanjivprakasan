import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sanjivprkashan/controller/CartController.dart';
import 'package:sanjivprkashan/model/address/UserAddress.dart';
import 'package:sanjivprkashan/ui/account/address/MyAddressList.dart';
import 'package:sanjivprkashan/ui/account/promo/OfferAndPromoScreen.dart';

import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';

class CheckoutScreen extends StatefulWidget {
  final UserAddress userAddress;
  const CheckoutScreen({super.key, required this.userAddress});

  @override
  State<StatefulWidget> createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final CartController cartCtrl = Get.put(CartController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool paymentMethodShow = true;
  bool showSummary = false;
  bool deliveryAddress = false;
  bool isChecked = false;
  int selectedMethod = 0;
  String selectedMethodValue = "credit-debit";

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "icon": Icons.credit_card,
      "label": "Credit/Debit Card",
      "value": "credit-debit",
    },
    {
      "icon": Icons.account_balance_wallet_outlined,
      "label": "PhonePe/Google Pay/BHIM UPI",
      "value": "upi",
    },
    {
      "icon": Icons.account_balance_wallet,
      "label": "Paytm/Payzapp/Wallets",
      "value": "wallet",
    },
    {
      "icon": Icons.account_balance,
      "label": "Net banking",
      "value": "netbanking",
    },
  ];
  @override
  void initState() {
    showSummary = false;
    deliveryAddress = false;
    cartCtrl.appliedPromo.clear();
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
                        String finalAmt = cartCtrl.appliedPromo.isNotEmpty ?
                        cartCtrl.appliedPromo["finalAmount"].toString() :
                        cartCtrl.cartSummary["total"].toString();
                        String gstAmt = cartCtrl.cartSummary["item_gst"].toString();
                        String shippingAmt = cartCtrl.cartSummary["item_shipping"].toString();
                        String discountAmt = cartCtrl.cartSummary["item_total_discount"].toString();
                        if(!isChecked){
                          paymentMethodShow = false;
                          showSummary = false;
                          deliveryAddress = false;
                          setState(() {});
                          showSnackbar("Please Read!!", "Please Read Our Ebook Policy And Confirm Before Buy");
                          return;
                        }
                        Map<String, String> cartData = {
                          "final_amt" : finalAmt,
                          "gst_amt" : gstAmt,
                          "shipping_amt" : shippingAmt,
                          "discount_amt" : discountAmt,
                          "payment_method" : selectedMethodValue,
                        };
                        debugPrint("cartData $cartData");
                        cartCtrl.createTampOrder(cartData);
                        // cartCtrl.startTransaction();
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
                        'Proceed to Pay',
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
                  otherAppBar(context, "Checkout", true, isCartShow: false),
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
        SizedBox(height: 10,),
        addressView(),
          catVeiw(),
        SizedBox(height: 10,),
        paymentMethod(),
        SizedBox(height: 10,),
        couponWidget(),
        SizedBox(height: 10,),
        if(cartCtrl.cartItemList.isNotEmpty)
          summeryView(),
        if(cartCtrl.cartItemList.isNotEmpty)
        SizedBox(height: 10,),
        alertWidget()
      ],
    );
  }

  Widget paymentMethod(){
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                paymentMethodShow = !paymentMethodShow;
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment Method",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: Icon(paymentMethodShow ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down, size: 25,),
                  ),
                ],
              ),
            ),
          ),
          if(paymentMethodShow)
          ...List.generate(paymentMethods.length, (index) {
          final method = paymentMethods[index];
          return InkWell(
            onTap: () {
              setState(() {
                selectedMethod = index;
                selectedMethodValue = method["value"];
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(method["icon"], size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      method["label"],
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Radio<int>(
                    value: index,
                    groupValue: selectedMethod,
                    onChanged: (val) {
                      setState(() {
                        selectedMethod = val!;
                        print("selectedMethod $selectedMethod");
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        })
        ],
      ),
    );
  }

  Widget alertWidget(){
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.amber[100], // Alert warning background
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (val) {
              setState(() {
                isChecked = val ?? false;
              });
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Please Read Our Ebook Policy And Confirm Before Buy",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Text("-",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),),
                Text("E-book का Access 1 वर्ष के लिए है |",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),),
                Text("E-book आप अपने डिवाइस पर सिर्फ पढ़ सकते है |",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),),
                Text("E-book डाउनलोड नही होगी और न ही इसका प्रिंट निकल सकते है |",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),),
                Text("E-book को खरीदने के पश्चात आप वापिस नही कर सकते और न ही बदल सकते है |",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget couponWidget() {

    return cartCtrl.appliedPromo.isEmpty
        ? InkWell(
      onTap: () {
        Get.to(OfferAndPromoScreen(cartAmount: double.parse(cartCtrl.cartSummary["total"].toString() ?? "0.00").toStringAsFixed(2), pType: "0", courseId: "",));
      },
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        padding: const EdgeInsets.fromLTRB(10, 20, 8, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/presents.png',
                  width: 30,
                  height: 25,
                ),
                // Icon(Icons.favorite_border,size: 22,color: Theme.of(context).hintColor,),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apply Coupon',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 15
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.navigate_next,
              size: 26,
              color: Theme.of(context).hintColor,
            )
          ],
        ),
      ),
    )
        : Container(
      padding: const EdgeInsets.fromLTRB(10, 15, 8, 15),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/presents.png',
                width: 30,
                height: 25,
              ),
              // Icon(Icons.favorite_border,size: 22,color: Theme.of(context).hintColor,),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Applied Coupon',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      color: Theme.of(context).hintColor
                    ),
                  ),
                  Text(
                    cartCtrl.appliedPromo["promo_code"],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: Colors.green
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
              onTap: () {
                  cartCtrl.appliedPromo.clear();
              },
              child: Icon(
                Icons.close,
                size: 26,
                color: Theme.of(context).hintColor,
              ))
        ],
      ),
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.normal),
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
          if(cartCtrl.appliedPromo.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Coupon Discount",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).hintColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  // "-₹${double.parse(cartCtrl.appliedPromo["discountAmount"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  "-₹${double.parse((cartCtrl.appliedPromo["discountAmount"] ?? 0.00).toString()).toStringAsFixed(2) ?? "0.00"}",
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
                  "+₹${double.parse(cartCtrl.cartSummary["item_shipping"].toString() ?? "0.00").toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: cartCtrl.cartSummary["item_shipping"] == 0 ? Colors.green : null,
                      fontSize: 16),
                ),
              ),
            ],
          ),
          if(cartCtrl.appliedPromo.isEmpty)
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
          if(cartCtrl.appliedPromo.isNotEmpty)
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
                  "₹${double.parse((cartCtrl.appliedPromo["finalAmount"] ?? 0.00).toString()).toStringAsFixed(2) ?? "0.00"}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: myprimarycolor, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addressView(){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    double pTypeSpace = 5;
    final item = widget.userAddress;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                deliveryAddress = !deliveryAddress;
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Delivery Address",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Change",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15,
                            color: myprimarycolor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Icon(deliveryAddress ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down, size: 25,),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if(deliveryAddress)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: pTypeSpace,),
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
              SizedBox(height: 10,),
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
              InkWell(
                onTap: (){
                  setState(() {
                    showSummary = !showSummary;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order Summary",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      InkWell(
                        onTap: (){

                        },
                        child: Icon(showSummary ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down, size: 25,),
                      ),
                    ],
                  ),
                ),
              ),

              if(!showSummary)
              SizedBox(height: 10,),
              if(showSummary)
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
