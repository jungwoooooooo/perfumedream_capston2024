import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:PerfumeDream/screens/screen_checkout.dart';
import '../constants.dart';
import '../models/model_product.dart';

final buttonColor = MaterialStateProperty.all<Color>(Colors.black);

class ItemBasketPage extends StatefulWidget {
  const ItemBasketPage({super.key});

  @override
  State<ItemBasketPage> createState() => _ItemBasketPageState();
}

class _ItemBasketPageState extends State<ItemBasketPage> {
  final database = FirebaseFirestore.instance;

  Query<Product>? productListRef;

  double totalPrice = 0;
  Map<String, dynamic> cartMap = {};
  Stream<QuerySnapshot<Product>>? productList;
  List<int> keyList = [];

  @override
  void initState() {
    super.initState();

    //! 저장한 장바구니 리스트 가져오기
    try {
      cartMap =
          json.decode(sharedPreferences.getString("cartMap") ?? "{}") ?? {};
    } catch (e) {
      debugPrint(e.toString());
      cartMap = {};
    }

    //! 조건문에 넘길 product no 키 값 리스트를 선언 (기존 값이 string이어서 int로 변환)
    cartMap.forEach(
          (key, value) {
        keyList.add(int.parse(key));
      },
    );

    //! 파이어스토어에서 데이터 가져오는 Ref 변수
    if (keyList.isNotEmpty) {
      productListRef = FirebaseFirestore.instance
          .collection("products")
          .withConverter(
          fromFirestore: (snapshot, _) =>
              Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson())
          .where("productNo", whereIn: keyList);
    }

    productList = productListRef?.orderBy("productNo").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
      ),
      body: cartMap.isEmpty
          ? Container()
          : StreamBuilder(
          stream: productList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  if (cartMap[document.data().productNo.toString()] !=
                      null) {
                    return basketContainer(
                        productNo: document.data().productNo ?? 0,
                        productName: document.data().productName ?? "",
                        productImageUrl:
                        document.data().productImageUrl ?? "",
                        price: document.data().price ?? 0,
                        quantity:
                        cartMap[document.data().productNo.toString()]);
                  }
                  return Container();
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("오류가 발생 했습니다."),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
          }),
      bottomNavigationBar: cartMap.isEmpty
          ? const Center(
        child: Text("장바구니에 담긴 제품이 없습니다."),
      )
          : StreamBuilder(
          stream: productList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              totalPrice = 0;
              snapshot.data?.docs.forEach((document) {
                if (cartMap[document.data().productNo.toString()] != null) {
                  totalPrice +=
                      cartMap[document.data().productNo.toString()] *
                          document.data().price ??
                          0;
                }
              });
              return Padding(
                  padding: const EdgeInsets.all(20),
                  child: FilledButton(
                    onPressed: () {
                      //! 결제시작 페이지로 이동
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const ItemCheckoutPage();
                        },
                      ));
                    },
                    style: ButtonStyle(
                      // backgroundColor 속성을 사용하여 배경색을 지정합니다
                      backgroundColor: buttonColor,
                    ),
                    child:
                    Text("Subtotal ${numberFormat.format(totalPrice)}Won Buy"),
                  ));
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("오류가 발생 했습니다."),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
          }),
    );
  }

  Widget basketContainer({
    required int productNo,
    required String productName,
    required String productImageUrl,
    required double price,
    required int quantity,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 130,
            fit: BoxFit.cover,
            imageUrl: productImageUrl,
            placeholder: (context, url) {
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  productName,
                  textScaleFactor: 1.2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("${numberFormat.format(price)}Won"),
                Row(
                  children: [
                    const Text("Quantity:"),
                    IconButton(
                        onPressed: () {
                          //! 수량 줄이기 (1 초과시에만 감소시킬 수 있음)
                          if (cartMap[productNo.toString()] > 1) {
                            setState(() {
                              //! 수량 1 차감
                              cartMap[productNo.toString()]--;

                              //! 디스크에 반영
                              sharedPreferences.setString(
                                  "cartMap", json.encode(cartMap));
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.remove,
                        )),
                    Text("$quantity"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            //! 수량 늘리기
                            cartMap[productNo.toString()]++;

                            //! 디스크에 반영
                            sharedPreferences.setString(
                                "cartMap", json.encode(cartMap));
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                        )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            //! 장바구니에서 해당 제품 제거
                            cartMap.remove(productNo.toString());

                            //! 디스크에 반영
                            sharedPreferences.setString(
                                "cartMap", json.encode(cartMap));
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                        )),
                  ],
                ),
                Text("Subtotal: ${numberFormat.format(price * quantity)}Won"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}