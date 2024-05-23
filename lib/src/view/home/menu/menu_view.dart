import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/src/controller/menu_controller.dart';

class MenuView extends StatelessWidget {
  final String videoID;

  MenuView({required this.videoID});

  @override
  Widget build(BuildContext context) {
    final MenuControllers menuController = Get.put(MenuControllers());
    menuController.updateCurrentVideoID(videoID);

    return StatefulBuilder(builder: (context, setState) {
      return DraggableScrollableSheet(
        initialChildSize: 1, // 처음 열릴 때 70% 높이
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Video ID: ${menuController.currentVideoID.value}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // 여기에 추가적인 메뉴 항목을 넣을 수 있습니다.
              ],
            ),
          );
        },
      );
    });
  }
}
