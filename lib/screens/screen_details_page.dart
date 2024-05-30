import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PerfumeDream/screens/screen_basket_page.dart';
import 'package:PerfumeDream/screens/screen_checkout.dart';
import '../constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ItemDetailsPage extends StatefulWidget {
  int productNo;
  String productName;
  String productImageUrl;
  double price;
  String category;
  String content;
  ItemDetailsPage(
      {super.key,
        required this.productNo,
        required this.productName,
        required this.productImageUrl,
        required this.price,
        required this.category,
        required this.content
      });

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  int quantity = 1;
  String content = '';

  @override
  void initState() {
    super.initState();
    fetchContent();
  }

  void fetchContent() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productNo.toString())
        .get();

    setState(() {
      content = doc['content'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("details"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              productImageContainer(),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.category, textAlign: TextAlign.start, overflow: TextOverflow.clip,style: TextStyle(fontWeight: FontWeight.w400)),// style: secondaryTextStyle()),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AutoSizeText(
                          widget.productName,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis, // 클립 대신 말줄임표 사용
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // 기본 폰트 크기 설정
                          maxLines: 1, // 한 줄로 제한
                          minFontSize: 18, // 최소 폰트 크기 설정
                        ),
                        Text("${numberFormat.format(widget.price)}Won", textAlign: TextAlign.start, overflow: TextOverflow.clip),// style: boldTextStyle()),
                      ],
                    ),
                    productQuantityContainer(),
                    SizedBox(height: 16, width: 16),
                    Text("상세 내용", textAlign: TextAlign.start, overflow: TextOverflow.clip,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),// style: boldTextStyle()),
                    SizedBox(height: 8),
                    Text(
                        content,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip),
                    productTotalPriceContainer(),
                    //style: secondaryTextStyle()),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child:FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return const ItemCheckoutPage();
                    }));
                  },
                  child: const Text("Buy"),

                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    //! 임시 장바구니 변수 Map 선언 - 디스크에서 받아옴
                    Map<String, dynamic> cartMap =
                        json.decode(sharedPreferences.getString("cartMap") ?? "{}") ??
                            {};

                    //! 장바구니에 해당 제품이 없으면
                    if (cartMap[widget.productNo.toString()] == null) {
                      cartMap.addAll({widget.productNo.toString(): quantity});
                    } else {
                      //! 제품이 있으면
                      cartMap[widget.productNo.toString()] += quantity;
                    }
                    //! 디스크에 다시 반영
                    sharedPreferences.setString("cartMap", json.encode(cartMap));

                    print(cartMap);

                    //! 장바구니 페이지로 이동
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return const ItemBasketPage();
                    }));
                  },
                  child: const Text("Add to cart"),
                ),
              ),
            ],
          ),
        ));
  }

  Widget productImageContainer() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
      // alignment: Alignment.center,
      // padding: const EdgeInsets.all(15),
      child: CachedNetworkImage(
        imageUrl: widget.productImageUrl,
        height: 400,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          // width: MediaQuery.of(context).size.width * 0.8,
          // fit: BoxFit.cover,
          // imageUrl: widget.productImageUrl,
          // placeholder: (context, url) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        },
        errorWidget: (context, url, error) {
          return const Center(
            child: Text("오류 발생"),
          );
        },
      ),
    );
  }

  Widget productNameContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: AutoSizeText(
        widget.productName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24, // Set a base font size
        ),
        maxLines: 1, // Ensure the text does not exceed one line
        minFontSize: 16, // Set a minimum font size to avoid text becoming too small
        overflow: TextOverflow.ellipsis, // Use ellipsis to indicate overflow
      ),
    );
  }

  Widget productPriceContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "${numberFormat.format(widget.price)}Won",
        textScaleFactor: 1.3,
      ),
    );
  }

  Widget productQuantityContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Quantity: "),
          IconButton(
            onPressed: () {
              setState(() {
                if (quantity > 1) {
                  quantity--;
                }
              });
            },
            icon: const Icon(Icons.remove, size: 24),
          ),
          Text("$quantity"),
          IconButton(
            onPressed: () {
              setState(() {
                quantity++;
              });
            },
            icon: const Icon(Icons.add, size: 24),
          ),
        ],
      ),
    );
  }

  Widget productTotalPriceContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Subtotal: ",
            textScaleFactor: 1.3,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${numberFormat.format(widget.price * quantity)}Won",
            textScaleFactor: 1.3,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  Widget productCategoryContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Category: ${widget.category}",
        textScaleFactor: 1.3,
      ),
    );
  }
}