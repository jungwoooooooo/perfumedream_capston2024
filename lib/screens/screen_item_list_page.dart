import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:PerfumeDream/screens/screen_basket_page.dart';
import 'package:PerfumeDream/screens/screen_details_page.dart';
import 'package:PerfumeDream/screens/screen_my_order_list_page.dart';

import '../constants.dart';
import '../models/model_product.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final productListRef = FirebaseFirestore.instance
      .collection("products")
      .withConverter<Product>(
    fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
    toFirestore: (product, _) => product.toJson(),
  );

  final userLikesRef = FirebaseFirestore.instance.collection("user_likes");

  // List of categories
  final List<String> categories = ["All", "Citrus", "Musk", "Sweet","Soap", "Floral","Woody", "Pick"];
  String selectedCategory = "All";
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image(
            image: AssetImage('images/images/logo6.png'),
            height: 30,
            width: 30,
            fit: BoxFit.cover),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const MyOrderListPage();
                },
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const ItemBasketPage();
                },
              ));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query.toLowerCase();
                  print('검색 쿼리 업데이트: $searchQuery');
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category buttons
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 8),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = category;
                      });
                      if (category == "Pick") {
                        // Liked 카테고리를 누를 때 좋아하는 상품을 가져옵니다.
                        print('Liked 카테고리를 누름: 좋아하는 상품을 가져옵니다.');
                        _buildLikedProductsList();
                      }
                    },
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        color: selectedCategory == category
                            ? Colors.white
                            : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 버튼 모양 조절
                      ),
                      minimumSize: Size(50, 30),
                      backgroundColor: selectedCategory == category
                          ? Colors.black12
                          : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Product list
          Expanded(
            child: selectedCategory == "Pick"
                ? _buildLikedProductsList()
                : _buildProductsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    Stream<QuerySnapshot<Product>> stream;
    if (searchQuery.isNotEmpty) {
      stream = productListRef
          .where("productName_lowercase", isGreaterThanOrEqualTo: searchQuery)
          .where("productName_lowercase", isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .snapshots();
    } else if (selectedCategory == "All") {
      stream = productListRef.orderBy("productNo").snapshots();
    } else {
      stream = productListRef
          .where("category", isEqualTo: selectedCategory)
          .orderBy("productNo")
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot<Product>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.6,
              crossAxisCount: 3,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];
              var product = document.data();
              return productContainer(
                product: product,
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("오류가 발생했습니다."),
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
  }

  Widget _buildLikedProductsList() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: userLikesRef.doc(uid).collection("likes").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var likedProductIds = snapshot.data!.docs.map((doc) => doc.id).toList();
          if (likedProductIds.isEmpty) {
            return const Center(child: Text("좋아요한 상품이 없습니다."));
          }
          return FutureBuilder<List<DocumentSnapshot<Product>>>(
            future: Future.wait(
              likedProductIds.map((id) => productListRef.doc(id).get()).toList(),
            ),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              } else if (futureSnapshot.hasError) {
                return const Center(
                  child: Text("오류가 발생했습니다."),
                );
              } else if (futureSnapshot.hasData) {
                var products = futureSnapshot.data!.where((doc) => doc.exists).map((doc) => doc.data()!).toList();
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.9,
                    crossAxisCount: 2,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var product = products[index];
                    return productContainer(
                      product: product,
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("오류가 발생했습니다."),
                );
              }
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("오류가 발생했습니다."),
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
  }



  Widget productContainer({required Product product}) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ItemDetailsPage(
              productNo: product.productNo ?? 0,
              productName: product.productName ?? "No Name",
              productImageUrl: product.productImageUrl ?? "",
              price: product.price ?? 0,
              category: product.category ?? "Uncategorized",
              content: product.content ?? "No Content"
            );
          },
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  height: 140,
                  fit: BoxFit.cover,
                  imageUrl: product.productImageUrl ?? "",
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
                Positioned(
                  right: 0,
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: userLikesRef
                        .doc(uid)
                        .collection("likes")
                        .doc((product.productNo ?? 0).toString())
                        .snapshots(),
                    builder: (context, snapshot) {
                      bool isLiked = snapshot.hasData && snapshot.data!.exists;
                      return IconButton(
                        icon: Icon(
                          isLiked ? Icons.star : Icons.star_border,
                          color: Colors.amberAccent,
                        ),
                        onPressed: () {
                          if (isLiked) {
                            userLikesRef
                                .doc(uid)
                                .collection("likes")
                                .doc((product.productNo ?? 0).toString())
                                .delete();
                          } else {
                            userLikesRef
                                .doc(uid)
                                .collection("likes")
                                .doc((product.productNo ?? 0).toString())
                                .set({"productNo": product.productNo ?? 0});
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(2),
              child: AutoSizeText(
                product.productName ?? "No Name",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1, // 한 줄로 제한
                minFontSize: 13, // 최소 폰트 크기 설정
                overflow: TextOverflow.ellipsis, // 클립 대신 말줄임표 사용
              ),
            )
            ,
            Container(
              padding: const EdgeInsets.all(2),
              child: Text("${numberFormat.format(product.price ?? 0)}원"),
            ),
          ],
        ),
      ),
    );
  }
}
