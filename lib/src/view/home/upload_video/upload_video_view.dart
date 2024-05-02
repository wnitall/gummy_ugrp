import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/upload_video/widgets/upload_form.dart';

class UploadVideoView extends StatefulWidget {
  const UploadVideoView({super.key});

  @override
  State<UploadVideoView> createState() => _UploadVideoViewState();
}

class _UploadVideoViewState extends State<UploadVideoView> {
  getVideoFile(ImageSource imgSourse) async {
    final videoFile = await ImagePicker().pickVideo(source: imgSourse);

    if (videoFile != null) {
      Get.to(UploadForm(
        videoFile: File(videoFile.path),
        videoPath: videoFile.path,
      ));
    }
  }

  displayDialogBox() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () {
                getVideoFile(ImageSource.gallery);
              },
              child: const Row(
                children: [
                  Icon(Icons.image),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Get Video from Phone Gallery',
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                getVideoFile(ImageSource.camera);
              },
              child: const Row(
                children: [
                  Icon(Icons.camera_alt),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Make Video from Phone Camera',
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Get.back();
              },
              child: const Row(
                children: [
                  Icon(Icons.cancel),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Cancel',
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/profile.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  displayDialogBox();
                },
                child: const Text('Upload New Video'))
          ],
        ),
      ),
    );
  }
}
