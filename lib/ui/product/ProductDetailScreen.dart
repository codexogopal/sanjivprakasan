import 'dart:async';
import 'dart:io' show Platform;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:sanjivprkashan/controller/CategoriesController.dart';
import 'package:sanjivprkashan/ui/categories/SubCatWishScreen.dart';
import 'package:sanjivprkashan/ui/currentAfairs/CurrentAfairsScreen.dart';
import 'package:upgrader/upgrader.dart';

import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';
import '../../controller/HomeController.dart';
import 'AllProductScreen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String pId;

  const ProductDetailScreen({super.key, required this.pId});

  @override
  State<StatefulWidget> createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  final CategoriesController catCtrl = Get.put(CategoriesController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLike = false;

  String selectedPType = "0";
  int pQuantity  = 1;
  @override
  void initState() {
    getData();
    isLike = false;
    super.initState();
  }

  Future<void> getData() async {

    Timer(Duration(milliseconds: 10), () {
      catCtrl.getProductDetail(widget.pId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      // appBar: myStatusBar(context),
      bottomNavigationBar: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                        if(selectedPType== "0"){
                          showSnackbar("Error!", "Only add one quantity for ebook!");
                          return;
                        }
                        pQuantity = pQuantity > 1 ? pQuantity-1 : 1;
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
                        child: Icon(
                          Icons.remove ,
                          size: 20,
                        ),
                      ),
                    ),
                    Text(
                      pQuantity.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: myprimarycolor,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        if(selectedPType== "0"){
                          showSnackbar("Error!", "Only add one quantity for ebook!");
                          return;
                        }
                        if(selectedPType == "1"){
                          if(pQuantity >= catCtrl.productDetail.value!.productPhyMoq){
                            showSnackbar("Error!", "Can not add quantity more than ${catCtrl.productDetail.value!.productPhyMoq}");
                            return;
                          }
                        }
                        pQuantity = pQuantity+1;
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
                        child: Icon(
                          Icons.add ,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                  return Container(
                    width: 150,
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: !catCtrl.isProductAdding.value ? addToCart : null,
                      // onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),

                      child:
                          !catCtrl.isProductAdding.value
                              ? Text(
                                'Add To Cart',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.white),
                              )
                              : SizedBox(height: 50,child: buttonLoader()),
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (catCtrl.isLoading.value) {
            return Center(child: apiLoader());
          }
          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              children: [
                otherAppBar(context, "", true),
                Flexible(
                  child: ListView(children: [addBody(), SizedBox(height: 50)]),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void addToCart(){
    Map<String, String> pData = {
      "product_id" : catCtrl.productDetail.value?.productId.toString() ?? "0",
      "selectedPrice" : selectedPType.toString(),
      "qty" : pQuantity.toString(),
    };
    catCtrl.addItemToCart(pData);
  }

  Widget addBody() {
    return Column(children: [SizedBox(height: 10), catVeiw()]);
  }

  double value = 3.5;

  Widget catVeiw() {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final product = catCtrl.productDetail.value;
    if (product == null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 60,
        child: Center(child: Text("No products Detail")),
      ); // Or your loader
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(1.0),
                child: setCachedImage(
                  product.productImage,
                  250,
                  200,
                  5,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            product.productName ?? '',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RatingStars(
                                  axis: Axis.horizontal,
                                  value: 5.0,
                                  onValueChanged: (v) {
                                    //
                                    setState(() {
                                      value = v;
                                    });
                                  },
                                  starCount: 5,
                                  starSize: 15,
                                  valueLabelRadius: 10,
                                  maxValue: 5,
                                  starSpacing: 3,
                                  maxValueVisibility: true,
                                  valueLabelVisibility: false,
                                  animationDuration: Duration(
                                    milliseconds: 1000,
                                  ),
                                  valueLabelPadding: const EdgeInsets.symmetric(
                                    vertical: 1,
                                    horizontal: 8,
                                  ),
                                  valueLabelMargin: const EdgeInsets.only(
                                    right: 8,
                                  ),
                                  starOffColor: const Color(0xffe7e8ea),
                                  starColor: const Color(0XFFf8b81f),
                                  angle: 0,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "(${product.productReview})",
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontSize: 13),
                                ),
                              ],
                            ),

                            InkWell(
                              onTap: (){
                                catCtrl.addRemoveWishlist(widget.pId);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                child:   catCtrl.addFav.value ? apiLoader(size: 30) : Icon(catCtrl.product_fav.value == 0 ? Icons.favorite_border : Icons.favorite, size: 30, color: myprimarycolor,),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              DottedLine(dashColor: myprimarycolor.withAlpha(50)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        selectedPType = "0";
                        pQuantity = 1;
                        setState(() {

                        });
                      },
                      child: selectedItemW(
                        product.productEbookSellingPrice,
                        product.productEbookDiscount.toString(),
                        product.productEbookPrice.toString(),

                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        if(product.productPhySellingPrice == ""){

                        }else{
                          selectedPType = "1";
                          setState(() {
                          });
                        }

                      },
                      child: selectedItemPhyW(
                        product.productPhySellingPrice ?? "Out of stock",
                        product.productPhyDiscount.toString(),
                        product.productPhyPrice.toString(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if(product.productContent != null && product.productContent != "")
        SizedBox(height: 10,),
        if(product.productContent != null && product.productContent != "")
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              htmlSpanMobile("Short Description", product.productContent ?? ""),
            ],
          ),
        ),
        if(product.productDescription != null && product.productDescription != "")
        SizedBox(height: 10,),
        if(product.productDescription != null && product.productDescription != "")
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              htmlSpanMobile("Description", product.productDescription ?? ""),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textSpanMobile("SKU", product.productSku),
              SizedBox(height: 5,),
              textSpanMobile("Categories", product.productCategoryName),
              if(product.productTocImage != "")
                SizedBox(height: 5,),
              if(product.productTocImage != "")
                InkWell(
                  onTap: (){
                    openWhatsApp(product.productTocImage);
                  },
                  child: Text(
                    "Click to view - Book Preview",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(
                      color: myprimarycolor.withAlpha(150),
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                              "Related books",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      final products = catCtrl.productListData ?? [];
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
                                    String userData = product.productId.toString();
                                   // catCtrl.getProductDetail(userData);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(pId: userData)));
                                  },
                                  child: Container(
                                    width: screenWidth > 400 ? 190 : 170,
                                    margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
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
          ),
        ),
      ],
    );
  }

  Widget textSpanMobile(String title, String value) {
    return Text.rich(
        textAlign: TextAlign.left,
        TextSpan(
            text: "$title: ",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 14,
            ),
            children: <InlineSpan>[
              TextSpan(
                text: value,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ]
        )
    );
  }
  Widget htmlSpanMobile(String title, String value) {
    return Text.rich(
        textAlign: TextAlign.left,
        TextSpan(
            text: "$title: ",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 14,
            ),
            children: <InlineSpan>[
              WidgetSpan(child: HtmlWidget(value,textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal,
              color: Theme.of(context).hintColor),))
            ]
        )
    );
  }

  Widget selectedItemW(String sPrice, String discount, String orgPrice) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: selectedPType == "0" ? myprimarycolor : Colors.black, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ebook:",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Icon(
                selectedPType == "1" ? Icons.circle_outlined : Icons.radio_button_checked,
                size: 20,
                color:
                    selectedPType == "1"
                        ? Theme.of(context).hintColor
                        : myprimarycolor,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                "₹${sPrice ?? ''} ",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: myprimarycolor,
                  fontSize: 15,
                ),
              ),
              Text(
                "₹${orgPrice ?? ''} ",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(
                  fontSize: 10,
                  color: Theme.of(context).hintColor,
                  decoration: TextDecoration.lineThrough,
                  decorationColor:
                  Theme.of(context).hintColor,
                  decorationThickness: 3.0,
                ),
              ),
              Text(
                "(${discount ?? '0'}%)",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget selectedItemPhyW(String sPrice, String discount, String orgPrice) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color:
              sPrice == ""
                  ? Colors.grey.shade200
                  : selectedPType == "0"
                  ? Colors.black
                  : myprimarycolor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Physical copy:",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      sPrice == ""
                          ? Colors.grey.shade200
                          : Theme.of(context).hintColor,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Icon(
                selectedPType == "0" ? Icons.circle_outlined : Icons.radio_button_checked,
                size: 20,
                color:
                    sPrice == ""
                        ? Colors.grey.shade200
                        : selectedPType == "0"
                        ? Theme.of(context).hintColor
                        : myprimarycolor,
              ),
            ],
          ),
          SizedBox(height: 10),
          sPrice == ""
              ? Row(
                children: [
                  Text(
                    "Out of stock",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade200,
                      fontSize: 15,
                    ),
                  ),
                ],
              )
              : Row(
                children: [
                  Text(
                    "₹${sPrice ?? ''} ",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: myprimarycolor,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "₹${orgPrice ?? ''} ",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).hintColor,
                      decoration: TextDecoration.lineThrough,
                      decorationColor:
                      Theme.of(context).hintColor,
                      decorationThickness: 3.0,
                    ),
                  ),
                  Text(
                    "(${discount ?? '0'}%)",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
