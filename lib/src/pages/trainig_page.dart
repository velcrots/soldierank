import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {

  Future<int> _callAPI(String idText, String pwdText) async {
    var url = Uri.parse(
      'http://navy-combat-power-management-platform.shop/get.php',
    );
    var response = await Dio().postUri(url, data: {'username': idText, 'pwd': pwdText});
    return response.data;
  }

  late VideoPlayerController _controller;
  double? aspectRatio;
  double progress = 0;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(//https://www.youtube.com/watch?v=hzWkLIjXhEU
        "https://www.shutterstock.com/shutterstock/videos/1083786064/preview/stock-footage-multinational-people-and-global-communication-network-concept-social-media.webm"))
      ..initialize();
    _controller.setPlaybackSpeed(1);
    _controller.play();

    _controller.addListener(() async {
      int max = _controller.value.duration.inSeconds;
      setState(() {
        aspectRatio = _controller.value.aspectRatio;
        position = _controller.value.position;
        progress = (position.inSeconds / max * 100).isNaN
            ? 0
            : position.inSeconds / max * 100;
      });
    });
  }

  void seekTo(int value) {
    int add = position.inSeconds + value;

    _controller.seekTo(Duration(seconds: add < 0 ? 0 : add));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Training Page")),
      body: Stack(
        children: [
          if (aspectRatio != null) ...[
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom:
                    MediaQuery.of(context).padding.top + kToolbarHeight),
                child: AspectRatio(
                    aspectRatio: aspectRatio!, child: VideoPlayer(_controller)),
              ),
            ),
            Positioned(
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        seekTo(-10);
                      },
                      child: const SizedBox(
                        width: 30,
                        child: Icon(
                          Icons.replay_10_rounded,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      },
                      child: SizedBox(
                        width: 30,
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.stop
                              : Icons.play_arrow_rounded,
                          size: 32,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        seekTo(10);
                      },
                      child: const SizedBox(
                        width: 30,
                        child: Icon(
                          Icons.forward_10_rounded,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                        width: 30,
                        child: Text(
                          _controller.value.position.toString().substring(2, 7),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        )),
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 6,
                          width: MediaQuery.of(context).size.width - 206,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color.fromRGBO(135, 135, 135, 1),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 6,
                          width: (MediaQuery.of(context).size.width - 206) *
                              (progress / 100),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color.fromRGBO(215, 215, 215, 1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        width: 30,
                        child: Text(
                          _controller.value.duration.toString().substring(2, 7),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        )),
                  ],
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}