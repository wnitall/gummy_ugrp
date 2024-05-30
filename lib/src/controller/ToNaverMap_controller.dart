import 'package:url_launcher/url_launcher.dart';

class ToNaverController {
  Future<void> launchNaverMap() async {
    const packageName = "com.nhn.android.nmap"; // 네이버 지도 앱의 패키지 이름
    final startLatitude = 35.7056377572321; //출발지의 위도 (대구경북과학기술원)
    final startLongitude = 128.455010688046; //출발지의 경도 (대구광역시 테크노중앙대로 333)
    final destinationLatitude = 35.6931202543981; //목적지의 위도 (대구 테크노폴리스 투썸플레이스)
    final destinationLongitude =
        128.458237916539; //목적지의 경도 (대구광역시 달성군 유가면 테크노중앙대로 254)
    final naverMapUrl = Uri.parse(
        'nmap://route/walk?slat=$startLatitude&slng=$startLongitude&dlat=$destinationLatitude&dlng=$destinationLongitude&dname=쇼츠에서 본 맛집'); // 네이버 지도 앱의 길찾기 URI 스킴
    final playStoreUrl =
        Uri.parse('https://play.google.com/store/apps/details?id=$packageName');

    try {
      bool launched = await launchUrl(naverMapUrl);

      if (!launched) {
        await launchUrl(playStoreUrl);
      }
    } catch (e) {
      await launchUrl(playStoreUrl);
    }
  }
}
