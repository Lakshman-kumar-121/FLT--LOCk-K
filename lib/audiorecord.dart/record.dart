import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:lock/audiorecord.dart/player.dart';
import 'package:permission_handler/permission_handler.dart';

class audiorecord extends StatefulWidget {
  final folderName;
  audiorecord({Key? key , this.folderName}) : super(key: key);

  @override
  State<audiorecord> createState() => _audiorecordState();
}

class _audiorecordState extends State<audiorecord> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audiofile = File(path!);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => adplayer(file: audiofile ,foldername: widget.folderName , online: false),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRecorder();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enable record audio permission")));
    }
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio record"),
      ),
      body: Container(
          color: Colors.black87,
          width: double.maxFinite,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                  "https://media.istockphoto.com/id/1282891289/vector/music-cloud-concept-cloud-shape-sound-waves-and-headphones-online-music-streaming-service.jpg?s=612x612&w=0&k=20&c=9_9C1ItPqgljbBoy10Zv2bLNBgNNdM-WbzVkGyvtyF4=",
                  width: MediaQuery.of(context).size.width * 0.85),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<RecordingDisposition>(
              stream: recorder.onProgress,
              builder: (context, snapshot) {
                final duration =
                    snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                String twoDigits(int n) => n.toString().padLeft(2);
                final twoDigitMinutes =
                    twoDigits(duration.inMinutes.remainder(60));
                final twoDigitSeconds =
                    twoDigits(duration.inSeconds.remainder(60));

                return Text(
                  " $twoDigitMinutes :$twoDigitSeconds s",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                );
              },
            ),
            IconButton(
                onPressed: () async {
                  if (recorder.isRecording) {
                    await stop();
                  } else {
                    await record();
                  }
                  setState(() {});
                },
                icon: Icon(
                  recorder.isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 30,
                ))
          ])),
    );
  }
}
