import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/core/utils/global_var.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _userMap = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get userMap => _userMap.value;
  Rx<String> _userID = ''.obs;

  updateCurrentUserID(String visitUserID) {
    _userID.value = visitUserID;

    retrieveUserInformation();
  }

  retrieveUserInformation() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .get();

    final userInfo = documentSnapshot.data() as dynamic;

    String? userName = userInfo?['name'];
    String userEmail = userInfo['email'];
    String userImage = userInfo['image'];
    String userUID = userInfo['uid'];
    String userYoutube = userInfo['youtube'] == null ? '' : userInfo['youtube'];
    String userInstagram =
        userInfo['instagram'] == null ? '' : userInfo['instagram'];
    String userTwitter = userInfo['twitter'] == null ? '' : userInfo['twitter'];
    String userFacebook =
        userInfo['facebook'] == null ? '' : userInfo['facebook'];
    int totalLikes = 0;
    int totalFollowers = 0;
    int totalFollowings = 0;
    bool isFollowing = true;
    List<String> thumbnailsList = [];

    var followersNumberDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .collection('followers')
        .get();
    totalFollowers = followersNumberDoc.docs.length;

    var followingNumberDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .collection('following')
        .get();
    totalFollowings = followingNumberDoc.docs.length;

    FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .collection('followers')
        .doc(currentUserID)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _userMap.value = {
      "userName": userName,
      "userEmail": userEmail,
      "userImage": userImage,
      "userUID": userUID,
      "userYoutube": userYoutube,
      "userInstagram": userInstagram,
      "userTwitter": userTwitter,
      "userFacebook": userFacebook,
      "totalLikes": totalLikes.toString(),
      "totalFollowers": totalFollowers.toString(),
      "totalFollowings": totalFollowings.toString(),
      "isFollowing": isFollowing,
      "thumbnailsList": thumbnailsList,
    };

    update();
  }

  followUnfollowUser() async {
    var document = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .collection('followers')
        .doc(currentUserID)
        .get();

    if (document.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userID.value)
          .collection('followers')
          .doc(currentUserID)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserID)
          .collection('following')
          .doc(_userID.value)
          .delete();
      _userMap.value.update(
          'totalFollowes', (value) => (int.parse(value) - 1).toString());
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userID.value)
          .collection('followers')
          .doc(currentUserID)
          .set({});

      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection('following')
          .doc(_userID.value)
          .set({});

      _userMap.value.update(
          "totalFollowers", (value) => (int.parse(value) + 1).toString());
    }
    _userMap.value.update('isFollowing', (value) => !value);
    update();
  }
}
