import 'dart:async';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeIframePlayer extends StatefulWidget {
  const YoutubeIframePlayer({super.key});

  @override
  State<YoutubeIframePlayer> createState() => _YoutubeIframePlayerState();
}

class _YoutubeIframePlayerState extends State<YoutubeIframePlayer>
    with WidgetsBindingObserver {
  late YoutubePlayerController _controller;
  bool fullScreen = false;
  final floating = Floating();

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
        videoId: 'iCvmsMzlF7o',
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          captionLanguage: 'pt-BR',
          strictRelatedVideos: true,
          showVideoAnnotations: true,
          enableCaption: true,
          enableJavaScript: true,
          mute: false,
          playsInline: true,
        ))
      ..setFullScreenListener((value) async {
        if (!value) {
          await _controller.pauseVideo();
          await _controller.playVideo();
        }
      });
  }

  @override
  void dispose() {
    _controller.close();
    WidgetsBinding.instance.removeObserver(this);
    floating.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.inactive) {
      floating.enable(aspectRatio: const Rational.square());
    }
  }

  Future<void> enablePip() async {
    try {
      final status =
          await floating.enable(aspectRatio: const Rational.landscape());
      debugPrint('PiP enabled? $status');
    } catch (e) {
      print('DEU ERRO $e');
    }
  }

  _buildBurnerWidgetContent() {
    return YoutubePlayerScaffold(
      autoFullScreen: true,
      controller: _controller,
      builder: (context, player) {
        return Stack(
          children: [
            player,
            IconButton(
              icon: const Icon(
                Icons.picture_in_picture_alt_outlined,
                color: Colors.white,
              ),
              onPressed: () async {
                await enablePip();
              },
            ),
            StreamBuilder<YoutubePlayerValue>(
              stream: _controller.stream.asBroadcastStream(),
              builder: (context, snapshot) {
                if (snapshot.data?.playerState == PlayerState.unStarted) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .28,
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator());
                }
                if (snapshot.data?.playerState == PlayerState.paused ||
                    snapshot.data?.playerState == PlayerState.ended) {
                  return Positioned(
                      bottom: 60,
                      left: 10,
                      right: 10,
                      child: InkWell(
                        onDoubleTap: () async {
                          await _controller.playVideo();
                        },
                        onTap: () async {
                          await _controller.playVideo();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                        ),
                      ));
                }
                if (snapshot.data?.playerState == PlayerState.playing) {
                  return Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.transparent,
                      ));
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Scaffold(
              backgroundColor: Theme.of(context).appBarTheme.color,
              appBar: AppBar(
                // title: Text(widget.video.title),
                title: const Text(
                  "Detail",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              body: Center(child: _buildBurnerWidgetContent()));
        }
        return Stack(children: [
          Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).appBarTheme.color,
              body: Center(child: _buildBurnerWidgetContent())),
          Container(
            height: MediaQuery.of(context).size.height * .85,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
          )
        ]);
      },
    );
  }
}
