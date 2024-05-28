import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/core/utils/global_var.dart';
import 'package:tiktok_app_clone_flutter/src/controller/profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  ProfileView({this.visitUserID, super.key});

  String? visitUserID;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileController profileController = Get.put(ProfileController());
  bool isFollowingUser = false;
  List<String> thumbnails = [];

  @override
  void initState() {
    super.initState();

    profileController.updateCurrentUserID(widget.visitUserID.toString());

    getIsFollowingValue();
    loadThumbnails();
  }

  Future<void> refreshData() async {
    await getIsFollowingValue();
    await loadThumbnails();
  }

  getIsFollowingValue() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.visitUserID.toString())
        .collection('followers')
        .doc(currentUserID)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          isFollowingUser = true;
        });
      } else {
        setState(() {
          isFollowingUser = false;
        });
      }
    });
  }

  Future<void> loadThumbnails() async {
    final ListResult result =
        await FirebaseStorage.instance.ref('All Thumbnails').listAll();
    final List<Reference> allFiles = result.items;

    List<String> files = await Future.wait(allFiles.map((file) async {
      final String url = await file.getDownloadURL();
      return url;
    }).toList());

    setState(() {
      thumbnails = files;
    });
  }

  Future<void> launchUserSocialProfile(String socialLink) async {
    if (!await launchUrl(Uri.parse('https://$socialLink'))) {
      throw Exception('Could not launch$socialLink');
    }
  }

  handleClickEvent(String choiceClicked) {
    switch (choiceClicked) {
      case 'Settings':
        print('settings');
        break;
      case "Logout":
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: const Text('Are you sure want to log out?'),
              actions: [
                TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Get.snackbar(
                          'Logged Out', 'You are logged out from the app');
                    },
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('No')),
              ],
            );
          },
        );

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.userMap.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: Text(
              controller.userMap["userName"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [
              widget.visitUserID.toString() == currentUserID
                  ? PopupMenuButton<String>(
                      onSelected: handleClickEvent,
                      itemBuilder: (BuildContext context) {
                        return {"Settings", "Logout"}
                            .map((String choiceClicked) {
                          return PopupMenuItem(
                            value: choiceClicked,
                            child: Text(choiceClicked),
                          );
                        }).toList();
                      },
                    )
                  : Container(),
            ],
          ),
          body: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: refreshData,
            child: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      profileController.userMap["userImage"],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 90,
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Text(
                                profileController.userMap['totalFollowings'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Following',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        width: 90,
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Text(
                                profileController.userMap['totalFollowers'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Followers',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        width: 90,
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Text(
                                profileController.userMap['totalLikes'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Likes',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                    width: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (profileController.userMap["userFacebook"] == "") {
                            Get.snackbar("Facebook Profile",
                                "This user has not connected his/her profile to facebook yet.");
                          } else {
                            launchUserSocialProfile(
                                profileController.userMap["userFacebook"]);
                          }
                        },
                        child: Image.asset(
                          "assets/icons/facebook.png",
                          width: 18,
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          if (profileController.userMap["userInstagram"] ==
                              "") {
                            Get.snackbar("Instagram Profile",
                                "This user has not connected his/her profile to instagram yet.");
                          } else {
                            launchUserSocialProfile(
                                profileController.userMap["userInstagram"]);
                          }
                        },
                        child: Image.asset(
                          "assets/icons/instagram.png",
                          width: 18,
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          if (profileController.userMap["userTwitter"] == "") {
                            Get.snackbar("Twitter Profile",
                                "This user has not connected his/her profile to twitter yet.");
                          } else {
                            launchUserSocialProfile(
                                profileController.userMap["userTwitter"]);
                          }
                        },
                        child: Image.asset(
                          "assets/icons/twitter.png",
                          width: 18,
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          if (profileController.userMap["userYoutube"] == "") {
                            Get.snackbar("Twitter Youtube",
                                "This user has not connected his/her profile to youtube yet.");
                          } else {
                            launchUserSocialProfile(
                                profileController.userMap["userYoutube"]);
                          }
                        },
                        child: Image.asset(
                          "assets/icons/youtube.png",
                          width: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () {
                        if (widget.visitUserID.toString() == currentUserID) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actionsPadding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                content:
                                    const Text('Are you sure want to log out?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        FirebaseAuth.instance.signOut();
                                        Get.snackbar('Logged Out',
                                            'You are logged out from the app');
                                      },
                                      child: const Text('Yes')),
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                ],
                              );
                            },
                          );
                        } else {
                          if (isFollowingUser == true) {
                            setState(() {
                              isFollowingUser = false;
                            });
                          } else {
                            setState(() {
                              isFollowingUser = true;
                            });
                          }
                          profileController.followUnfollowUser();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Text(
                        widget.visitUserID.toString() == currentUserID
                            ? "Sign Out"
                            : isFollowingUser == true
                                ? "Unfollow"
                                : 'Follow',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 15),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: thumbnails.length,
                    itemBuilder: (context, index) {
                      return Image.network(thumbnails[index],
                          fit: BoxFit.cover);
                    },
                  ),
                ],
              ),
            )),
          ),
        );
      },
    );
  }
}
