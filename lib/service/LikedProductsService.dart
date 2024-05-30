import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikedProductsService {
  final userLikesRef = FirebaseFirestore.instance.collection("user_likes");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<String>> getLikedProductIds() async {
    try {
      // 현재 사용자 가져오기
      User? user = _auth.currentUser;
      if (user != null) {
        // 현재 사용자의 UID
        String uid = user.uid;

        // 현재 사용자의 문서에서 likes 컬렉션 가져오기
        DocumentSnapshot userSnapshot = await userLikesRef.doc(uid).get();
        if (userSnapshot.exists) {
          // likes 컬렉션의 문서 ID 목록 가져오기
          Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
          List<String> likedProductIds = List<String>.from(data['likes'] ?? []);
          return likedProductIds;
        } else {
          // 사용자의 문서 또는 likes 컬렉션이 존재하지 않을 때 처리
          return [];
        }
      } else {
        // 사용자가 인증되지 않은 경우 처리
        return [];
      }
    } catch (e) {
      // 오류 처리
      print("Error fetching liked product IDs: $e");
      return [];
    }
  }
}
