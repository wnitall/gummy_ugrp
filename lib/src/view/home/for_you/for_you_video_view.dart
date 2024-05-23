import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_app_clone_flutter/core/widgets/circular_image_animation.dart';
import 'package:tiktok_app_clone_flutter/core/widgets/custom_video_player.dart';
import 'package:tiktok_app_clone_flutter/src/controller/comments_controller.dart';
import 'package:tiktok_app_clone_flutter/src/controller/reviews_controller.dart';
import 'package:tiktok_app_clone_flutter/src/controller/for_you_video_controller.dart';
import 'package:tiktok_app_clone_flutter/src/controller/profile_controller.dart';
import 'package:tiktok_app_clone_flutter/src/controller/share_controller.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/comments/comments_bottom_sheet.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/comments/comments_view.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/map/map_view.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/menu/menu_view.dart'; // 메뉴 뷰 임포트 추가

//앱으로 이동 코드
import 'package:url_launcher/url_launcher.dart';

class ForYouVideoView extends StatefulWidget {
  const ForYouVideoView({super.key});

  @override
  State<ForYouVideoView> createState() => _ForYouVideoViewState();
}

class _ForYouVideoViewState extends State<ForYouVideoView> {
  ForYouVideoController forYouVideoController =
      Get.put(ForYouVideoController());
  CommentsController commentsController = Get.put(CommentsController());
  ReviewsController reviewsController = Get.put(ReviewsController());
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController
        .updateCurrentUserID(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final img = profileController.userMap["userImage"];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(() {
        return PageView.builder(
          itemCount: forYouVideoController.forYouAllVideoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final eachVideoInfo =
                forYouVideoController.forYouAllVideoList[index];
            Uri uri = Uri.parse(eachVideoInfo.videoUrl!);

            return Stack(
              children: [
                //*video/
                CustomVideoPlayer(videoFileUrl: uri),

                //*left right - panels
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 110, // 원하는 높이 지정
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            " > 강남구",
                            style: GoogleFonts.roboto(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: 70,
                            //padding: EdgeInsets.only(top: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: _launchNaverMap,
                                  icon: const Icon(
                                    Icons.map_outlined,
                                    size: 37,
                                    color: Color.fromARGB(255, 238, 238, 238),
                                  ),
                                ),
                                Text(
                                  "길찾기",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //*left right - panels
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //*left panel
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 18),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "${eachVideoInfo.userName}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  //*description - tags
                                  Text(
                                    eachVideoInfo.descriptionTags.toString(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 46),

                                  //*artist - song name
                                  /*
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/music_note.png',
                                        width: 20,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '  ${eachVideoInfo.artistSongName}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                  */
                                ],
                              ),
                            ),
                          ),
                          //*right panel
                          Container(
                            width: 80,
                            padding: EdgeInsets.only(top: context.height * .30),
                            margin: EdgeInsets.only(bottom: 60),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //*profile
                                SizedBox(
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Container(
                                          width: 42,
                                          height: 42,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(66, 63, 61, 61),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Image(
                                              image: NetworkImage(
                                                eachVideoInfo.userProfileImage
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //*like button
                                Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          forYouVideoController
                                              .likeOrUnlikeVideo(eachVideoInfo
                                                  .videoID
                                                  .toString());
                                        },
                                        icon: eachVideoInfo.likesList!.contains(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            ? Icon(Icons.favorite_rounded,
                                                size: 37,
                                                color: const Color.fromARGB(
                                                    255, 200, 70, 61))
                                            : Icon(
                                                Icons.favorite_border,
                                                size: 37,
                                                color: Colors.white,
                                              )),

                                    //*total likes
                                    Text(
                                      eachVideoInfo.likesList!.length
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                //*comment button - total comment
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        commentsController.updateCurrentVideoID(
                                            eachVideoInfo.videoID.toString());
                                        reviewsController.updateCurrentVideoID(
                                            eachVideoInfo.videoID.toString());
                                        // Get.to(
                                        //   CommentsView(
                                        //     videoID: eachVideoInfo.videoID
                                        //         .toString(),
                                        //   ),
                                        // );
                                        showCommentBottomSheet(context);
                                      },
                                      icon: const Icon(
                                        Icons.chat_bubble_outline,
                                        size: 37,
                                        color: Colors.white,
                                      ),
                                    ),

                                    //total comment
                                    Text(
                                      eachVideoInfo.totalComments.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                //*menu button
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          enableDrag: true,
                                          scrollControlDisabledMaxHeightRatio:
                                              11.2 / 16,
                                          builder: (_) {
                                            return MenuView(
                                                videoID: eachVideoInfo.videoID
                                                    .toString());
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.restaurant_menu,
                                        size: 37,
                                        color:
                                            Color.fromARGB(255, 238, 238, 238),
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        shareVideo_temp(
                                            eachVideoInfo.videoUrl!);
                                      },
                                      icon: const Icon(
                                        Icons.send_rounded,
                                        size: 37,
                                        color:
                                            Color.fromARGB(255, 238, 238, 238),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        );
      }),
    );
  }

  void _launchNaverMap() async {
    const packageName = "com.android.chrome";
    final chromeUrl = Uri.parse('googlechrome://');
    final playStoreUrl =
        Uri.parse('https://play.google.com/store/apps/details?id=$packageName');

    try {
      bool launched = await launchUrl(chromeUrl);

      if (!launched) {
        await launchUrl(playStoreUrl);
      }
    } catch (e) {
      await launchUrl(playStoreUrl);
    }
  }
}
