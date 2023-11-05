import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:lock/audiorecord.dart/player.dart';
import 'package:lock/main.dart';
import 'package:open_settings/open_settings.dart';

import 'package:permission_handler/permission_handler.dart';
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
            body:SfPdfViewer.network('https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf' )
            
            ),
      );
    }


   



    if (service.getFileName(widget.ImageUrl) == "mp3"|| service.getFileName(widget.ImageUrl) == 'mp4' ||
    service.getFileName(widget.ImageUrl) == 'opus' ||
    service.getFileName(widget.ImageUrl) == 'ogg' ||service.getFileName(widget.ImageUrl) == 'aac' ||service.getFileName(widget.ImageUrl) == 'awb'|| service.getFileName(widget.ImageUrl) == 'amr' ||service.getFileName(widget.ImageUrl) == 'waw'||service.getFileName(widget.ImageUrl) == 'm4a'   ) {
      return adplayer(
        file: File(widget.ImageUrl),
        
        online: true,
        foldername: "null",
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

            test(context);
            var dir =await  Directory('/storage/emulated/0/Galleryvault');
            try{


              var path ;
            
            var rng = Random();
            var num = rng.nextInt(1000);
            if(widget.ImageUrl.toString().split('.jpg').length == 2){
              path = '${dir.path}/GalleryVault${num}.jpg';
            }
            else if(widget.ImageUrl.toString().split('.jpeg').length == 2){
               path = '${dir.path}/GalleryVault${num}.jpg';
            }
            else{
               path = '${dir.path}/GalleryVault${num}.png';
            }
            


            



            await Dio().download(widget.ImageUrl, path);
            await GallerySaver.saveImage(path);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Image downloaded")));
            }catch(e){
 ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("${e.toString()}")));
            }
       
            
            
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
  test(context)async{
  
  var exits = await Directory('/storage/emulated/0/Galleryvault').exists();
  
  if(! exits){
    try{
      await Directory('/storage/emulated/0/Galleryvault').create();
    }catch(e){

        ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error Permission is not allowed to store and download on disk")));
                 final  permis = Permission.manageExternalStorage;
    try{
      if( ! await permis.isGranted){
await OpenSettings.openManageAllFilesAccessPermissionSetting();
      }

    }
    catch(e){
      print("error bro");
      print(e.toString());
    }
      
    } 
  }

}

  void download() async {
    var ref = await FirebaseStorage.instance.refFromURL(widget.ImageUrl);
    test(context);

    var dir = await Directory('/storage/emulated/0/Galleryvault');

    final file = File("${dir.path}/${ref.name}");
    try {
      await ref.writeToFile(file).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Pdf Downloaded")));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Download path is ${dir.path}")));
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.message}")));
    }
    catch(e){
            ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.toString()}")));
    }
  }
}
