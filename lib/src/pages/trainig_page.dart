import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ace/src/components/image_data.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  List<String> playlist = [
    'https://www.shutterstock.com/shutterstock/videos/3908891/preview/stock-footage--s-air-force-personnel-start-planning-a-new-mission-in-the-vietnam-war-in-includes-shots.webm',
    'https://www.shutterstock.com/shutterstock/videos/6286064/preview/stock-footage-circa-s-the-united-states-army-trains-it-s-soldiers-for-fighting-in-vietnam-in-the-s.webm',
    'https://www.shutterstock.com/shutterstock/videos/4836392/preview/stock-footage--s-the-korean-war-rages-on-and-army-combat-teams-engage-in-battle-with-a-wide-variety-of.webm',
    'https://www.shutterstock.com/shutterstock/videos/4397513/preview/stock-footage--s-unedited-raw-silent-footage-of-the-tet-offensive-attack-on-the-tan-son-nhut-airbase.webm',
  ];
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
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        playlist[0]))
      ..initialize();
    _controller.setPlaybackSpeed(1);

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
      body: ListView(
        children: [player(),playList()]
      ),
    );
  }

  Column playList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _controller.pause();
                  _controller = VideoPlayerController.networkUrl(Uri.parse(
                      index + 1 <= playlist.length ? playlist[index] : playlist[0]))
                    ..initialize();
                  _controller.setPlaybackSpeed(1);

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
                  print(index);
                });
              },
              child: Row(children: [
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.black,
                      child: Center(
                          child: Image.asset(
                        AvatarPath.navyAvatar,
                        fit: BoxFit.contain,
                      )),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('제목$index'),
                    SizedBox(height: 10),
                    Text('2024-06-${index + 1} 시청 완료'),
                  ],),
              ]),
            );
          },
        ),
      ],
    );
  }

  Stack player() {
      return Stack(
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
    );
  }
}