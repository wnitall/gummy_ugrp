import 'package:get/get.dart';

class MenuControllers extends GetxController {
  var currentVideoID = ''.obs;

  void updateCurrentVideoID(String videoID) {
    currentVideoID.value = videoID;
  }
}
