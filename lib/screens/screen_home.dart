// import 'package:PerfumeDream/screens/screen_details_page.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:PerfumeDream/screens/screen_item_list_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../../main.dart';
// import '../constants.dart';
// import '../models/model_product.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => _HomeScreen();
// }
//
// class _HomeScreen extends State<HomeScreen> {
//
//   final productListRef = FirebaseFirestore.instance
//       .collection("products")
//       .withConverter<Product>(
//       fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
//       toFirestore: (product, _) => product.toJson(),
//   );
//   final userLikesRef = FirebaseFirestore.instance.collection("user_likes");
//
//   // List of categories
//   final List<String> categories = ["All", "Best Selling", "Man", "Woman", "Liked"];
//   String selectedCategory = "All";
//   String searchQuery = "";
//
//   @override
//   void initState() {
//     super.initState();
//   //  init();
//   }
//   //
//   // Future<void> init() async {
//   //   afterBuildCreated(() {
//   //     dialog();
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Image(
//           image: AssetImage('images/images/logo6.png'),
//           height: 30,
//           width: 30,
//           //color: Colors.black,
//           fit: BoxFit.cover,
//         ),
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Padding(
//                 padding: EdgeInsets.only(left: 16, right: 16, top: 16),
//                 child: Image(
//                   image: AssetImage('images/images/image 2.png'),
//                   height: 250,
//                   width: MediaQuery.of(context).size.width,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             SizedBox(height: 16),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Text("Best of OD", textAlign: TextAlign.start, overflow: TextOverflow.clip,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                         return const ItemListPage();//.launch(context);
//                       }));
//                     },
//                     child: Text("Show all"), //style: secondaryTextStyle()),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildProductsList() {
//     Stream<QuerySnapshot<Product>> stream;
//     // if (searchQuery.isNotEmpty) {
//     //   stream = productListRef
//     //       .where("productName_lowercase", isGreaterThanOrEqualTo: searchQuery)
//     //       .where("productName_lowercase", isLessThanOrEqualTo: searchQuery + '\uf8ff')
//     //       .snapshots();
//     // } else if (selectedCategory == "All") {
//          stream = productListRef.orderBy("productNo").snapshots();
//     // } else {
//     //   stream = productListRef
//     //       .where("category", isEqualTo: selectedCategory)
//     //       .orderBy("productNo")
//     //       .snapshots();
//     // }
//
//     return StreamBuilder<QuerySnapshot<Product>>(
//       stream: stream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return ListView.builder(
//             scrollDirection: Axis.horizontal, // 가로 스크롤을 위한 속성
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var document = snapshot.data!.docs[index];
//               var product = document.data();
//               return Padding(
//                 padding: EdgeInsets.only(left: 16, right: 16, top: 16),
//                 //padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: productContainer(
//                   product: product,
//                 ),
//               );
//             },
//             SizedBox(height: 16, width: 16),
//           );
//         } else if (snapshot.hasError) {
//           return const Center(
//             child: Text("오류가 발생했습니다."),
//           );
//         } else {
//           return const Center(
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//             ),
//           );
//         }
//       },
//     );
//   }
//   Widget productContainer({required Product product}) {
//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) {
//             return ItemDetailsPage(
//               productNo: product.productNo ?? 0,
//               productName: product.productName ?? "No Name",
//               productImageUrl: product.productImageUrl ?? "",
//               price: product.price ?? 0,
//               category: product.category ?? "Uncategorized",
//             );
//           },
//         ));
//       },
//       child: Container(
//         padding: const EdgeInsets.all(5),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 CachedNetworkImage(
//                   height: 140,
//                   fit: BoxFit.cover,
//                   imageUrl: product.productImageUrl ?? "",
//                   placeholder: (context, url) {
//                     return const Center(
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                       ),
//                     );
//                   },
//                   errorWidget: (context, url, error) {
//                     return const Center(
//                       child: Text("오류 발생"),
//                     );
//                   },
//                 ),
//                 Positioned(
//                   right: 0,
//                   child: StreamBuilder<DocumentSnapshot>(
//                     stream: userLikesRef
//                         .doc(uid)
//                         .collection("likes")
//                         .doc((product.productNo ?? 0).toString())
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       bool isLiked = snapshot.hasData && snapshot.data!.exists;
//                       return IconButton(
//                         icon: Icon(
//                           isLiked ? Icons.favorite : Icons.favorite_border,
//                           color: Colors.red,
//                         ),
//                         onPressed: () {
//                           if (isLiked) {
//                             userLikesRef
//                                 .doc(uid)
//                                 .collection("likes")
//                                 .doc((product.productNo ?? 0).toString())
//                                 .delete();
//                           } else {
//                             userLikesRef
//                                 .doc(uid)
//                                 .collection("likes")
//                                 .doc((product.productNo ?? 0).toString())
//                                 .set({"productNo": product.productNo ?? 0});
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               child: Text(
//                 product.productName ?? "No Name",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               child: Text("${numberFormat.format(product.price ?? 0)}원"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
