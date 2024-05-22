// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tiktok_app_clone_flutter/core/extensions/context_extension.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({
    super.key,
    required this.videoFileUrl,
  });

  final Uri videoFileUrl;

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  @override
  void initState() {
    super.initState();

    videoPlayerController =
        VideoPlayerController.networkUrl(widget.videoFileUrl)
          ..initialize().then((value) {
            videoPlayerController!.play();
            videoPlayerController!.setLooping(false);
            videoPlayerController!.setVolume(2);
          });
    videoPlayerController!.addListener(() {
      if (videoPlayerController!.value.position ==
          videoPlayerController!.value.duration) {
        videoPlayerController!.seekTo(Duration.zero);
        videoPlayerController!.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: context.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: VideoPlayer(videoPlayerController!),
    );
  }
}
