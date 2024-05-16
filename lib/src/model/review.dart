import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? userName;
  String? reviewText;
  String? userProfileImage;
  String? userID;
  String? reviewID;
  final publishedDateTime;
  List? reviewLikesList;

  Review({
    this.userName,
    this.reviewText,
    this.userProfileImage,
    this.userID,
    this.reviewID,
    this.publishedDateTime,
    this.reviewLikesList,
  });

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "reviewText": reviewText,
        "userProfileImage": userProfileImage,
        "userID": userID,
        "reviewID": reviewID,
        "publishedDateTime": publishedDateTime,
        "reviewLikesList": reviewLikesList,
      };

  static Review fromDocumentSnapshot(DocumentSnapshot snapshotDoc) {
    var documentSnapshot = snapshotDoc.data() as Map<String, dynamic>;

    return Review(
      userName: documentSnapshot["userName"],
      reviewText: documentSnapshot["reviewText"],
      userProfileImage: documentSnapshot["userProfileImage"],
      userID: documentSnapshot["userID"],
      reviewID: documentSnapshot["reviewID"],
      publishedDateTime: documentSnapshot["publishedDateTime"],
      reviewLikesList: documentSnapshot["reviewLikesList"],
    );
  }
}
