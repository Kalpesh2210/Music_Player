import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      home: const MyApp(),
      theme: ThemeData(
        sliderTheme: const SliderThemeData(
            trackHeight: 2, activeTrackColor: Colors.green),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScreen();
  }
}

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool audioplay = false;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  String audioPath = "audio/song.mp3";
  AudioPlayer myaudio = AudioPlayer();

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    super.initState();
    myaudio.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    myaudio.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    myaudio.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.only(top: 200),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 53, 52, 52), Colors.black]),
          ),
          child: Center(
              child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/music_card.jpg',
                  width: 280,
                  height: 280,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(right: 0),
                child: const Column(
                  children: [
                    const Text(
                      'Music Title (From ".......")',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Text(
                      'Artist Name 1, Artist Name 2, .......',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                child: Slider(
                    thumbColor: Colors.white,
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) {
                      final position = Duration(seconds: value.toInt());
                      myaudio.seek(position);
                      myaudio.resume();
                    }),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTime(position.inSeconds),
                      style: const TextStyle(color: Colors.green),
                    ),
                    Text(
                      formatTime((duration - position).inSeconds),
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.shuffle,
                          color: Colors.white,
                          size: 30,
                        )),
                    IconButton(
                        padding: EdgeInsets.only(left: 30),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white,
                          size: 40,
                        )),
                    IconButton(
                      onPressed: () async {
                        if (!audioplay && !isPlaying) {
                          await myaudio.play(AssetSource(audioPath));
                          setState(() {
                            isPlaying = true;
                            audioplay = true;
                          });
                        } else if (!isPlaying && audioplay) {
                          await myaudio.resume();
                          setState(() {
                            isPlaying = true;
                            audioplay = true;
                          });
                        } else {
                          await myaudio.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        }
                      },
                      icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow_rounded),
                      iconSize: 70,
                      color: Colors.white,
                    ),
                    IconButton(
                      padding: EdgeInsets.only(right: 30),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ))),
    );
  }
}
