import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/core/res/app_colors.dart';
import 'package:tiktok_app_clone_flutter/src/controller/auth_controller.dart';
import 'package:tiktok_app_clone_flutter/src/controller/profile_controller.dart';
import 'package:timeago/timeago.dart' as tago;

import 'package:tiktok_app_clone_flutter/src/controller/comments_controller.dart';
import 'package:tiktok_app_clone_flutter/src/controller/reviews_controller.dart';

class CommentsView extends StatefulWidget {
  CommentsView({
    super.key,
    required this.videoID,
  });

  final String videoID;

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  TextEditingController commentTextController = TextEditingController();
  TextEditingController reviewTextController = TextEditingController();

  CommentsController commentsController = Get.put(CommentsController());
  ReviewsController reviewsController = Get.put(ReviewsController());

  AuthController authController = Get.find<AuthController>();
  ProfileController profileController = Get.put(ProfileController());

  bool isCommentSection = true; // true for comments, false for reviews

  @override
  void initState() {
    super.initState();
    profileController
        .updateCurrentUserID(FirebaseAuth.instance.currentUser!.uid);
    commentsController.updateCurrentVideoID(widget.videoID);
    reviewsController.updateCurrentVideoID(widget.videoID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: context.width,
          height: context.height,
          child: Column(
            children: [
              // Toggle buttons for Comment and Review sections
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isCommentSection = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCommentSection ? Colors.blue : Colors.grey,
                    ),
                    child: Text('Comments'),
                  ),
                  const SizedBox(width: 16), // 버튼 사이에 간격 추가

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isCommentSection = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !isCommentSection ? Colors.blue : Colors.grey,
                    ),
                    child: Text('Reviews'),
                  ),
                ],
              ),
              Expanded(
                child: isCommentSection
                    ? buildCommentsSection()
                    : buildReviewsSection(),
              ),
              Container(
                color: Colors.white24,
                width: context.width,
                height: context.height * .1,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          profileController.userMap["userImage"],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: isCommentSection
                            ? commentTextController
                            : reviewTextController,
                        decoration: InputDecoration(
                          fillColor: Colors.black,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 13.5),
                          labelText: isCommentSection
                              ? 'Add a Comment Here'
                              : 'Add a Review Here',
                        ),
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (isCommentSection) {
                          if (commentTextController.text.isNotEmpty) {
                            commentsController.saveNewCommentToDatabase(
                                commentTextController.text);
                            commentTextController.clear();
                          }
                        } else {
                          if (reviewTextController.text.isNotEmpty) {
                            reviewsController.saveNewReviewToDatabase(
                                reviewTextController.text);
                            reviewTextController.clear();
                          }
                        }
                      },
                      child: const SizedBox(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.send,
                          size: 32,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCommentsSection() {
    return Obx(() {
      return ListView.builder(
        itemCount: commentsController.listOfComments.length,
        itemBuilder: (context, index) {
          final eachCommentInfo = commentsController.listOfComments[index];

          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(
                        eachCommentInfo.userProfileImage.toString()),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eachCommentInfo.userName.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        eachCommentInfo.commentText.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        tago.format(eachCommentInfo.publishedDateTime.toDate()),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${eachCommentInfo.commentLikesList!.length} likes",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      commentsController.likeUnlikeComment(
                          eachCommentInfo.commentID.toString());
                    },
                    icon: Icon(
                      Icons.favorite,
                      size: 30,
                      color: eachCommentInfo.commentLikesList!
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildReviewsSection() {
    return Obx(() {
      return ListView.builder(
        itemCount: reviewsController.listOfReviews.length,
        itemBuilder: (context, index) {
          final eachReviewInfo = reviewsController.listOfReviews[index];

          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(
                        eachReviewInfo.userProfileImage.toString()),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eachReviewInfo.userName.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        eachReviewInfo.reviewText.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        tago.format(eachReviewInfo.publishedDateTime.toDate()),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${eachReviewInfo.reviewLikesList!.length} likes",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      reviewsController
                          .likeUnlikeReview(eachReviewInfo.reviewID.toString());
                    },
                    icon: Icon(
                      Icons.favorite,
                      size: 30,
                      color: eachReviewInfo.reviewLikesList!
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
