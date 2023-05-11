// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:webview_flutter/webview_flutter.dart';

// class WebviewSSPlayer extends StatefulWidget {
//   const WebviewSSPlayer({super.key});

//   @override
//   State<WebviewSSPlayer> createState() => _WebviewSSPlayerState();
// }

// class _WebviewSSPlayerState extends State<WebviewSSPlayer>
//     with SingleTickerProviderStateMixin {
//   String html = """<!DOCTYPE html>
// <html>

// <body>
//     <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
//     <div id="player"></div>

//     <script>
//         // 2. This code loads the IFrame Player API code asynchronously.
//         var tag = document.createElement('script');

//         tag.src = "https://www.youtube.com/iframe_api";
//         var firstScriptTag = document.getElementsByTagName('script')[0];
//         firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

//         // 3. This function creates an <iframe> (and YouTube player)
//         //    after the API code downloads.
//         var player;

//         function onYouTubeIframeAPIReady() {
//             player = new YT.Player('player', {
//                 height: '1920',
//                 width: '1080',
//                 videoId: 'M7lc1UVf-VE',
//                 playerVars: { 'autoplay': 1, 'controls': 1 },
//                 events: {
//                     'onReady': onPlayerReady,
//                     'onStateChange': onPlayerStateChange
//                 }
//             });
//         }

//         // 4. The API will call this function when the video player is ready.
//         function onPlayerReady(event) {
//             event.target.playVideo();
//         }

//         // 5. The API calls this function when the player's state changes.
//         //    The function indicates that when playing a video (state=1),
//         //    the player should play for six seconds and then stop.
//         var done = false;

//         function onPlayerStateChange(event) {
          
//             if (event.data == YT.PlayerState.PLAYING && !done) {
//                 // setTimeout(stopVideo, 6000);
//                 done = true;
//             }
//         }
//               // This is the source "window" that will emit the events.
//         var iframeWindow = player.getIframe().contentWindow;
        
//         // So we can compare against new updates.
//         var lastTimeUpdate = 0;

//         // Listen to events triggered by postMessage,
//         // this is how different windows in a browser
//         // (such as a popup or iFrame) can communicate.
//         // See: https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage
//         window.addEventListener("message", function(event) {
//           // Check that the event was sent from the YouTube IFrame.
//           if (event.source === iframeWindow) {
//             var data = JSON.parse(event.data);

//             // The "infoDelivery" event is used by YT to transmit any
//             // kind of information change in the player,
//             // such as the current time or a playback quality change.
//             if (
//               data.event === "infoDelivery" &&
//               data.info &&
//               data.info.currentTime
//             ) {
//               // currentTime is emitted very frequently,
//               // but we only care about whole second changes.
//               var time = Math.floor(data.info.currentTime);
//               console.log('taime '+time);
//               if (time !== lastTimeUpdate) {
//                 lastTimeUpdate = time;
//                 console.log('taime '+time); // Update the dom, emit an event, whatever.
//               }
//             }
//           }
//         });


//         function stopVideo() {
//             console.log('stop')
//             player.stopVideo();
//         }

//         function pauseVideo() {
//             console.log('stop')
//             player.pauseVideo();
//         }

//         function playVideo() {
//             console.log('stop')
//             player.playVideo();
//         }
        
//     </script>
// </body>

// </html>
//   """;
//   late final WebViewController _controller;
//   late final String contentBase64;

//   final Completer<void> _initCompleter = Completer();

//   Future<void> _run(
//     String functionName, {
//     Map<String, dynamic>? data,
//   }) async {
//     await _initCompleter.future;
//     final varArgs = await _prepareData(data);
//     print('ENTER HERE $varArgs');

//     return await _controller.runJavaScript('$functionName()');
//   }

//   Future<String> _prepareData(Map<String, dynamic>? data) async {
//     return data == null ? '' : jsonEncode(data);
//   }

//   Future<void> playVideo() {
//     print('ENTER HERE playVideo');
//     return _run('playVideo');
//   }

//   Future<void> pauseVideo() {
//     print('ENTER HERE pauseVideo');
//     return _run('pauseVideo');
//   }

//   @override
//   void initState() {
//     super.initState();
//     contentBase64 = base64Encode(const Utf8Encoder().convert(html));
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {},
//           onPageStarted: (String url) {
//             print('ENTER HERE Page started loading: $url');
//           },
//           onPageFinished: (String url) async {
//             print('ENTER HERE Page finished loading: $url');
//           },
//           onWebResourceError: (WebResourceError error) {
//             print('ENTER HERE Page error: ${error.description}');
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             print('ENTER HERE Navigation Request: ${request.url}');
//             if (!request.url.startsWith('https://www.youtube.com/')) {
//               if (!isPlayed) {
//                 playVideo();
//               }
//               if (isPlayed) {
//                 pauseVideo();
//               }
//               isPlayed = !isPlayed;
//               setState(() {});
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('data:text/html;base64,$contentBase64'));
//     if (!_initCompleter.isCompleted) _initCompleter.complete();
//     _run('playVideo');
//   }

//   bool isPlayed = false;

//   @override
//   void dispose() {
//     _controller.clearCache();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Expanded(
//             child: WebViewWidget(
//               controller: _controller,
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               if (!isPlayed) {
//                 playVideo();
//                 return;
//               }
//               pauseVideo();
//               isPlayed = !isPlayed;
//               setState(() {});
//             },
//             child: Container(
//               height: 50,
//               width: 50,
//               color: Colors.red,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
