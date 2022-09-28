import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:lock/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class ImageView extends StatefulWidget {
  final ImageUrl;
  const ImageView(this.ImageUrl, {Key? key}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;

  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;
  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            controller.value = animation!.value;
          });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (service.getFileName(widget.ImageUrl) == "Pdf") {
      return SafeArea(
        child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text(
                "Download pdf",
                style: TextStyle(color: Colors.grey[200], fontSize: 20),
              ),
              onPressed: () async {
                download();
              },
            ),
            body: SfPdfViewer.network(
              widget.ImageUrl,
            )),
      );
    }
    if (service.getFileName(widget.ImageUrl) == "Image") {
      return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onDoubleTapDown: (details) => tapDownDetails = details,
          onDoubleTap: () {
            final position = tapDownDetails!.localPosition;
            final double scale = 4;
            final x = -position.dx * (scale - 1);
            final y = -position.dy * (scale - 1);

            final zoomed = Matrix4.identity()
              ..translate(x, y)
              ..scale(scale);
            final end =
                controller.value.isIdentity() ? zoomed : Matrix4.identity();
            animation = Matrix4Tween(begin: controller.value, end: end).animate(
                CurveTween(curve: Curves.easeOut).animate(animationController));
            animationController.forward(from: 0);
          },
          child: InteractiveViewer(
            transformationController: controller,
            maxScale: 4,
            clipBehavior: Clip.none,
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(widget.ImageUrl),
                  )),
            ),
          ),
        ),
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
            final tempdir = await getTemporaryDirectory();
            final path = '${tempdir.path}/myfile.jpg';
            await Dio().download(widget.ImageUrl, path);
            await GallerySaver.saveImage(path);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Image downloaded")));
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Unknown file"),
      ),
      body: Center(
        child: Text(
          "Unable to open file",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.grey[800]),
        ),
      ),
    );
  }

  void download() async {
    var ref = await FirebaseStorage.instance.refFromURL(widget.ImageUrl);
    var dir = await getExternalStorageDirectory();
    final file = File("${dir?.path}/${ref.name}");
    try {
      await ref.writeToFile(file).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Pdf Downloaded")));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Download path is ${dir?.path}")));
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.message}")));
    }
  }
}
