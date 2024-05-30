import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants.dart';
import '../enums/delivery_status.dart';
import '../enums/payment_status.dart';
import '../models/model_oder.dart';
import '../models/model_product.dart';

class MyOrderListPage extends StatefulWidget {
  const MyOrderListPage({super.key});

  @override
  State<MyOrderListPage> createState() => _MyOrderListPageState();
}

class _MyOrderListPageState extends State<MyOrderListPage> {
  final orderListRef = FirebaseFirestore.instance
      .collection("orders")
      .withConverter(
      fromFirestore: (snapshot, _) =>
          ProductOrder.fromJson(snapshot.data()!),
      toFirestore: (product, _) => product.toJson());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        //! 주문 번호를 기준으로 내림차순 정렬
        stream: orderListRef.orderBy("orderNo", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.docs.map((document) {
                //! 제품 상세 정보를 가져오기 위해 제품 번호를 기준으로 쿼리해서 가져옵니다.
                final productDetailsRef = FirebaseFirestore.instance
                    .collection("products")
                    .withConverter(
                    fromFirestore: (snapshot, _) =>
                        Product.fromJson(snapshot.data()!),
                    toFirestore: (product, _) => product.toJson())
                    .where("productNo", isEqualTo: document.data().productNo);
                return StreamBuilder(
                  stream: productDetailsRef.snapshots(),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.hasData) {
                      //! 제품 상세 정보를 가져온 후, orderContainer에 데이터를 전달합니다.
                      Product product =
                      productSnapshot.data!.docs.first.data();
                      return orderContainer(
                        document.id, // document id 전달
                        productNo: document.data().productNo ?? 0,
                        productName: product.productName ?? "",
                        productImageUrl: product.productImageUrl ?? "",
                        price: document.data().unitPrice ?? 0,
                        quantity: document.data().quantity ?? 0,
                        orderDate: document.data().orderDate ?? "",
                        orderNo: document.data().orderNo ?? "",
                        paymentStatus: document.data().paymentStatus ?? "",
                        deliveryStatus: document.data().deliveryStatus ?? "",
                      );
                    } else if (productSnapshot.hasError) {
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
                  },
                );
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
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black, // Change to desired color
          ),
          child: const Text("홈으로"),
        ),
      ),
    );
  }

  Widget orderContainer(
      String documentId, // document id 추가
          {required int productNo,
        required String productName,
        required String productImageUrl,
        required double price,
        required int quantity,
        required String orderDate,
        required String orderNo,
        required String paymentStatus,
        required String deliveryStatus}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              "주문날짜: $orderDate",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                width: MediaQuery.of(context).size.width * 0.3,
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
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                    Text("${numberFormat.format(price)}원"),
                    Text("수량: $quantity"),
                    Text("합계: ${numberFormat.format(price * quantity)}원"),
                    Text(
                      "${PaymentStatus.getStatusName(paymentStatus).statusName} / ${DeliveryStatus.getStatusName(deliveryStatus).statusName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('orders')
                      .doc(documentId)
                      .delete();

                  setState(() {
                    // 주문 목록을 다시 불러오도록 상태 갱신
                  });
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black54, // Change to desired color
                  foregroundColor: Colors.white, // Change text color to white
                ),
                child: const Text("주문취소"),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black, // Change to desired color
                ),
                child: const Text("배송조회"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
