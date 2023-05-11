import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class PodVideo extends StatefulWidget {
  const PodVideo({super.key});

  @override
  State<PodVideo> createState() => _PodVideoState();
}

class _PodVideoState extends State<PodVideo> with WidgetsBindingObserver {
  late final PodPlayerController controller;
  final floating = Floating();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.vimeo('162974951'),
    )..initialise();
    controller.addListener(() {
      print('EM BACKGROUND');
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.centerLeft,
        children: [
          PodVideoPlayer(
            controller: controller,
            onLoading: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          if (!(controller.videoState == PodVideoState.error) ||
              !(controller.videoState == PodVideoState.loading))
            Positioned(
              bottom: 250,
              top: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.picture_in_picture_alt_outlined,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await enablePip();
                  controller.enableFullScreen();
                  if (controller.videoState == PodVideoState.paused) {
                    controller.play();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
