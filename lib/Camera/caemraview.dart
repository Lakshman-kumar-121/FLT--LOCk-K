import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lock/main.dart';

class CameraView extends StatefulWidget {
  final image, foldername;
  const CameraView(this.foldername, this.image, {Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clicked Image"),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Column(
          children: [
            Image.file(
              File(widget.image.path),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height - 130,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.blueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close)),
            IconButton(
                onPressed: () async {
                      showDialog(barrierDismissible: false, context: context, builder: (context) => Center(child: Container(height: 50, width: 50, child:  CircularProgressIndicator(),),),);
                  await uploadFile(widget.foldername, UserId);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.check))
          ],
        ),
      ),
    );
  }

  Future uploadFile(String folderName, String Id) async {

    final path = '$Id/$folderName/${widget.image!.name}';
    final uploadfile = File(widget.image!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(uploadfile);

    String url = await ref.getDownloadURL();
    service.updateFiledoc(
        folderName, "${widget.image?.name.split(".")[0]}", url);
    Navigator.of(context).pop();
  }
}
