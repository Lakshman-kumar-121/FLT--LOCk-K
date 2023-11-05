import 'dart:io';
import 'dart:math';

// import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lock/main.dart';
import 'package:path_provider/path_provider.dart';

class adplayer extends StatefulWidget {
  File file;
  final foldername;
  final online;
  adplayer({Key? key, required this.file, this.foldername, this.online})
      : super(key: key);

  @override
  State<adplayer> createState() => _adplayerState();
}

class _adplayerState extends State<adplayer> {
  // var audioPlayer = AudioPlayer();
  var audioPlayer ;
  Future setAudio() async {
    // audioPlayer.setReleaseMode(ReleaseMode.LOOP);

    if (widget.online) {
      
      audioPlayer.setUrl(widget.file.path);
    } else {
      audioPlayer.setUrl(widget.file.path, isLocal: true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        // isplaying = state == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
       position = newPosition;
      });
    });
  }

  bool isplaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return widget.online ? onlnertn() : selectiveplay();
  }

  selectiveplay() => Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(children: [
            IconButton(
                onPressed: () {
                  if (isplaying) {
                    audioPlayer.pause();
                    audioPlayer.dispose();
                  }
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back)),
            Text("    Audio file")
          ]),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    "${audioimg}",
                    width: MediaQuery.of(context).size.width * 0.95,
                  ),
                ),
                Text("Audio File"),
                Slider(
                    value: position.inSeconds.toDouble(),
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                      await audioPlayer.resume();
                    }),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(position)),
                      Text(formatTime(duration - position)),
                    ],
                  ),
                ),
                CircleAvatar(
                  child: IconButton(
                      icon: Icon(isplaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () async {
                        if (isplaying) {
                          await audioPlayer.pause();
                        } else {
                          await audioPlayer.resume();
                        }
                      }),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        foregroundColor: Colors.white,
                        radius: 25,
                        backgroundColor: Colors.black87,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        foregroundColor: Colors.white,
                        radius: 25,
                        backgroundColor: Colors.black87,
                        child: IconButton(
                          onPressed: () async {
                                showDialog( barrierDismissible: false,context: context, builder: (context) => Center(child: Container(height: 50, width: 50, child:  CircularProgressIndicator(),),),);
                            await uploadFile(widget.foldername, UserId);
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.check, size: 30),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

  onlnertn() => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Text(
            "Download",
            style: TextStyle(color: Colors.grey[200], fontSize: 20),
          ),
          onPressed: () async {
            download();
          },
        ),
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(children: [
            IconButton(
                onPressed: () {
                  if (isplaying) {
                    audioPlayer.pause();
                    audioPlayer.dispose();
                  }
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back)),
            Text("    Audio file")
          ]),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    "${audioimg}",
                    width: MediaQuery.of(context).size.width * 0.95,
                  ),
                ),
                Text("Audio File"),
                Slider(
                    value: position.inSeconds.toDouble(),
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                      await audioPlayer.resume();
                    }),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(position)),
                      Text(formatTime(duration - position)),
                    ],
                  ),
                ),
                CircleAvatar(
                  child: IconButton(
                      icon: Icon(isplaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () async {
                        if (isplaying) {
                          await audioPlayer.pause();
                        } else {
                          await audioPlayer.resume();
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      );

  void download() async {
    var ref = await FirebaseStorage.instance.refFromURL('${audioimg}');

var dir =  await Directory('/storage/emulated/0/Galleryvault');
    


    final file = File("${dir.path}/${ref.name}");
    try {
      await ref.writeToFile(file).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Audio Downloaded")));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Download path is ${dir.path}")));
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.message}")));
    }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  Future uploadFile(String folderName, String Id) async {
    var rng = Random();
    var rndnumer = rng.nextInt(1000);
    final path = '$Id/$folderName/Audio ${rndnumer}.mp3';
    final uploadfile = widget.file;
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(uploadfile);
    String url = await ref.getDownloadURL();
    service.updateFiledoc(folderName, "Audio ${rndnumer}", url);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("file uploaded as Audio ${rndnumer}"),
    ));

    Navigator.of(context).pop();
  }
}
