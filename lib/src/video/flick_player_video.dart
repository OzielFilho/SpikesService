import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class FlickPlayerVideo extends StatefulWidget {
  const FlickPlayerVideo({super.key});

  @override
  State<FlickPlayerVideo> createState() => _FlickPlayerVideoState();
}

class _FlickPlayerVideoState extends State<FlickPlayerVideo> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
          "https://edisciplinas.usp.br/pluginfile.php/5196097/mod_resource/content/1/Teste.mp4"),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FlickVideoPlayer(flickManager: flickManager),
    );
  }
}
