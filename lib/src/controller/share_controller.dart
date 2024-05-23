import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
import 'package:share_plus/share_plus.dart';

void shareVideo_temp(String videoUrl) {
  Share.share(videoUrl, subject: 'Check out this video!');
}

void shareVideo(String videoUrl) async {
  try {
    // 카카오톡 링크를 통해 공유할 콘텐츠 설정
    final content = Content(
      title: 'Check out this video!',
      description: 'This is a cool video!',
      imageUrl:
          Uri.parse('https://example.com/thumbnail.jpg'), // 썸네일 이미지 URL로 대체
      link: Link(
        webUrl: Uri.parse(videoUrl),
        mobileWebUrl: Uri.parse(videoUrl),
      ),
    );

    // 템플릿 생성
    final template = FeedTemplate(
      content: content,
      buttons: [
        Button(
          title: 'Watch Video',
          link: Link(
            webUrl: Uri.parse(videoUrl),
            mobileWebUrl: Uri.parse(videoUrl),
          ),
        ),
      ],
    );

    // 카카오톡 링크 공유
    bool isKakaoTalkSharingAvailable =
        await ShareClient.instance.isKakaoTalkSharingAvailable();
    if (isKakaoTalkSharingAvailable) {
      Uri uri = await ShareClient.instance.shareDefault(template: template);
      await ShareClient.instance.launchKakaoTalk(uri);
    } else {
      // 카카오톡이 설치되지 않은 경우 처리
      print('KakaoTalk is not installed.');
    }
  } catch (e) {
    print('Error sharing video: $e');
  }
}
