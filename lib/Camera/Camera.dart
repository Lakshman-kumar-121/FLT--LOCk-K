import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lock/Camera/caemraview.dart';
import 'package:lock/main.dart';

class Imageclick extends StatefulWidget {
  final foldername;
  const Imageclick(this.foldername, {Key? key}) : super(key: key);

  @override
  State<Imageclick> createState() => _ImageclickState();
}

class _ImageclickState extends State<Imageclick> {
  late CameraController controller;

  FlashMode flashMode = FlashMode.off;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      controller.setFlashMode(FlashMode.off);
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: CameraPreview(controller)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 3),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (flashMode == FlashMode.off) {
                    controller.setFlashMode(FlashMode.always);
                    flashMode = FlashMode.always;
                  } else {
                    controller.setFlashMode(FlashMode.off);
                    flashMode = FlashMode.off;
                  }
                });
              },
              icon: flashMode == FlashMode.off
                  ? const Icon(
                      Icons.flash_off_outlined,
                      color: Colors.white,
                      size: 30,
                    )
                  : const Icon(
                      Icons.flash_on,
                      color: Colors.white,
                      size: 30,
                    )),
          IconButton(
              padding: EdgeInsets.only(bottom: 60, right: 20),
              icon: Icon(
                Icons.camera,
                color: Colors.white,
                size: 70,
              ),
              onPressed: () async {
                try {
                  await controller.takePicture().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CameraView(widget.foldername, value)));
                  });
                } on CameraException catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("${e}")));
                }
              }),
        ]),
      ),
    );
  }
}
