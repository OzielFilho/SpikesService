import 'package:flutter/material.dart';
import 'package:spikes_service/src/video/better_video_player.dart';
import 'package:spikes_service/src/video/flick_player_video.dart';
import 'package:spikes_service/src/video/pod_video_player.dart';
import 'package:spikes_service/src/youtube/webview_ss_player.dart';
import 'package:spikes_service/src/youtube/youtube_iframe_player.dart';
import 'package:spikes_service/src/youtube/youtube_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // MaterialButton(
            //   color: Theme.of(context).primaryColor,
            //   child: Text(
            //     'Youtube Webview Player',
            //     style: Theme.of(context).textTheme.headline2,
            //   ),
            //   onPressed: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const WebviewSSPlayer(),
            //       )),
            // ),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Flick Player Video',
                style: Theme.of(context).textTheme.headline2,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FlickPlayerVideo(),
                  )),
            ),
            // MaterialButton(
            //   color: Theme.of(context).primaryColor,
            //   child: Text(
            //     'Youtube Player',
            //     style: Theme.of(context).textTheme.headline2,
            //   ),
            //   onPressed: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const YoutubePlayerWidget(),
            //       )),
            // ),
            // MaterialButton(
            //   color: Theme.of(context).primaryColor,
            //   child: Text(
            //     'Youtube Iframe Player',
            //     style: Theme.of(context).textTheme.headline2,
            //   ),
            //   onPressed: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const YoutubeIframePlayer(),
            //       )),
            // ),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Better Player',
                style: Theme.of(context).textTheme.headline2,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BetterVideoPlayer(),
                  )),
            ),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Pod Player',
                style: Theme.of(context).textTheme.headline2,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PodVideo(),
                  )),
            ),
            // MaterialButton(
            //   color: Theme.of(context).primaryColor,
            //   child: Text(
            //     'Vimeo Player',
            //     style: Theme.of(context).textTheme.headline2,
            //   ),
            //   onPressed: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const YoutubePlayerWidget(),
            //       )),
            // ),
          ],
        ),
      ),
    );
  }
}
