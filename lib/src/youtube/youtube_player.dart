import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:floating/floating.dart';

class YoutubePlayerWidget extends StatefulWidget {
  const YoutubePlayerWidget({super.key});

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget>
    with WidgetsBindingObserver {
  late YoutubePlayerController _controller;

  _playInitYoutube() {
    _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }

  bool fullScreen = false;
  final floating = Floating();

  @override
  void initState() {
    _playInitYoutube();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    floating.dispose();
    _controller.dispose();
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

  YoutubePlayerBuilder _buildBurnerWidgetContent() {
    return YoutubePlayerBuilder(
        onEnterFullScreen: () {
          fullScreen = true;
        },
        onExitFullScreen: () {
          fullScreen = false;
        },
        player: YoutubePlayer(
          aspectRatio: 16 / 9,
          controller: _controller,
          showVideoProgressIndicator: true,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
          bottomActions: [
            PlayPauseButton(),
            ProgressBar(
              isExpanded: true,
            ),
            CurrentPosition(),
            IconButton(
              icon: const Icon(
                Icons.picture_in_picture_alt_outlined,
                color: Colors.white,
              ),
              onPressed: () async {
                await enablePip();
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () async {},
            ),
            FullScreenButton()
          ],
        ),
        builder: (contextd, player) {
          return player;
        });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientaion) {
      switch (orientaion) {
        case Orientation.portrait:
          return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Theme.of(context).appBarTheme.color,
              appBar: AppBar(
                // title: Text(widget.video.title),
                title: const Text(
                  "Detail",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              body: Center(child: _buildBurnerWidgetContent()));

        case Orientation.landscape:
          return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Theme.of(context).appBarTheme.color,
              body: _buildBurnerWidgetContent());
      }
    });
  }
}
