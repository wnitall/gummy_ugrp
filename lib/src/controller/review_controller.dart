import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/src/model/review.dart';

class ReviewsController extends GetxController {
  String currentVideoID = '';
  final Rx<List<Review>> reviewsList = Rx<List<Review>>([]);
  List<Review> get listOfReviews => reviewsList.value;

  updateCurrentVideoID(String videoID) {
    currentVideoID = videoID;
    retrieveReviews();
  }

  saveNewReviewToDatabase(String reviewTextData) async {
    try {
      String reviewID = DateTime.now().millisecondsSinceEpoch.toString();

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      Review reviewModel = Review(
        userName: (documentSnapshot.data() as dynamic)['name'],
        userID: FirebaseAuth.instance.currentUser!.uid,
        userProfileImage: (documentSnapshot.data() as dynamic)['image'],
        reviewText: reviewTextData,
        reviewID: reviewID,
        reviewLikesList: [],
        publishedDateTime: DateTime.now(),
      );

      // save new review info to database
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(currentVideoID)
          .collection('reviews')
          .doc(reviewID)
          .set(reviewModel.toJson());

      // update reviews counter
      DocumentSnapshot currentVideoSnapshotDocument = await FirebaseFirestore
          .instance
          .collection('videos')
          .doc(currentVideoID)
          .get();

      await FirebaseFirestore.instance
          .collection('videos')
          .doc(currentVideoID)
          .update({
        'totalReviews':
            (currentVideoSnapshotDocument.data() as dynamic)['totalReviews'] +
                1,
      });
    } catch (e) {
      Get.snackbar('Error Posting New Review', 'Error Message: $e');
    }
  }

  likeUnlikeReview(String reviewID) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('videos')
        .doc(currentVideoID)
        .collection('reviews')
        .doc(reviewID)
        .get();

    // unlike review feature - red heart button
    if ((documentSnapshot.data() as dynamic)['reviewLikesList']
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(currentVideoID)
          .collection('reviews')
          .doc(reviewID)
          .update({
        'reviewLikesList':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
      });
    } else {
      // like review feature - with heart button
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(currentVideoID)
          .collection('reviews')
          .doc(reviewID)
          .update({
        'reviewLikesList':
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
    }
  }

  retrieveReviews() async {
    reviewsList.bindStream(
      FirebaseFirestore.instance
          .collection('videos')
          .doc(currentVideoID)
          .collection('reviews')
          .orderBy('publishedDateTime', descending: true)
          .snapshots()
          .map((QuerySnapshot reviewsSnapshot) {
        List<Review> reviewListOfVideo = [];
        for (var eachReview in reviewsSnapshot.docs) {
          reviewListOfVideo.add(Review.fromDocumentSnapshot(eachReview));
        }
        return reviewListOfVideo;
      }),
    );
  }
}
