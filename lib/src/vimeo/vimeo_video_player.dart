import 'package:flutter/material.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class VimeVideoPlayer extends StatefulWidget {
  const VimeVideoPlayer({super.key});

  @override
  State<VimeVideoPlayer> createState() => _VimeVideoPlayerState();
}

class _VimeVideoPlayerState extends State<VimeVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: SizedBox(
          height: 250,
          child: VimeoPlayer(
            videoId: '769964103',
          ),
        ),
      ),
    );
  }
}
