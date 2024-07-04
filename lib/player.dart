import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final player = AudioPlayer();
  bool liked = false;

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void handlePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void handleSeek(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    try {
      await player.setAsset('assets/Money.mp3');

      player.positionStream.listen((p) {
        setState(() => position = p);
      });

      player.durationStream.listen((d) {
        setState(() => duration = d ?? Duration.zero);
      });

      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          // ignore: avoid_print
          print('Audio completed');
          setState(() {
            position = Duration.zero;
          });
          player.pause(); // Pause the player
          player.seek(Duration.zero); // Seek to start
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 35, 35, 35),
      appBar: _appBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            Container(height: MediaQuery.of(context).size.height * 2.5),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/LiSA.webp',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/Finding.png',
                fit: BoxFit.cover,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                  height: height,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(191, 26, 23, 23))),
            ),
            Positioned(
              bottom: height - 375,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  artistCard(context),
                  Container(
                    height: 50,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 2.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.amber,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  "Lyrics",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(94, 65, 60, 60),
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.share_outlined)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(94, 65, 60, 60),
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.expand)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column artistCard(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/moneyIMG.jpg',
                    height: 50,
                    width: 50,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MONEY',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'LiSA',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked
                      ? Colors.red
                      : const Color.fromARGB(255, 255, 255, 255),
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    liked = !liked;
                  });
                },
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Slider(
                min: 0.0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: handleSeek,
                activeColor: const Color.fromARGB(246, 255, 255, 255),
                inactiveColor: const Color.fromARGB(92, 63, 63, 63),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatDuration(position),
                  style: const TextStyle(color: Colors.white)),
              Text(formatDuration(duration),
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shuffle,
                color: Colors.white,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.skip_previous,
                color: Colors.white,
                size: 50,
              ),
            ),
            IconButton(
              onPressed: handlePlayPause,
              icon: Icon(
                player.playing
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill_outlined,
                color: Colors.white,
                size: 60,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.skip_next,
                color: Colors.white,
                size: 50,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.repeat_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_down_rounded,
            size: 40, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      centerTitle: true,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Text(
                'PLAYING FROM YOUR LIBRARY',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                'Liked Songs',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 50),
          Icon(
            Icons.spoke_rounded,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
