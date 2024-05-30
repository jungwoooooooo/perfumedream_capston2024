import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import '../models/model_product.dart';
import '../screens/screen_details_page.dart';

class LikedItemListPage extends StatefulWidget {
  const LikedItemListPage({Key? key}) : super(key: key);

  @override
  _LikedItemListPageState createState() => _LikedItemListPageState();
}

class _LikedItemListPageState extends State<LikedItemListPage> {
  final productListRef = FirebaseFirestore.instance
      .collection("products")
      .withConverter<Product>(
    fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
    toFirestore: (product, _) => product.toJson(),
  );

  final userLikesRef = FirebaseFirestore.instance.collection("user_likes");

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pick",
          style: TextStyle(
            fontFamily: "Compagnon-Roman",
            fontWeight: FontWeight.w600,
            fontSize: 28,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userLikesRef.doc(uid).collection("likes").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var likedProductIds =
            snapshot.data!.docs.map((doc) => doc.id).toList();
            if (likedProductIds.isEmpty) {
              return Center(child: Text("No liked items yet."));
            }
            return FutureBuilder<List<DocumentSnapshot>>(
              future: Future.wait(likedProductIds
                  .map((id) => productListRef.doc(id).get())
                  .toList()),
              builder: (context, futureSnapshot) {
                if (futureSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                } else if (futureSnapshot.hasError) {
                  return Center(
                    child: Text("An error occurred."),
                  );
                } else if (futureSnapshot.hasData) {
                  var products = futureSnapshot.data!
                      .where((doc) => doc.exists)
                      .map((doc) => doc.data() as Product) // 이 부분을 수정
                      .toList();
                  return GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
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
                  return Center(
                    child: Text("An error occurred."),
                  );
                }
              },
            );

          } else if (snapshot.hasError) {
            return Center(
              child: Text("An error occurred."),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
        },
      ),
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
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Center(
                      child: Text("Error occurred"),
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
              padding: const EdgeInsets.all(8),
              child: Text(
                product.productName ?? "No Name",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text("${numberFormat.format(product.price ?? 0)}원"),
            ),
          ],
        ),
      ),
    );
  }
}
