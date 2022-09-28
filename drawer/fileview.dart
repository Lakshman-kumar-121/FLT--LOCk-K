import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lock/Camera/Camera.dart';

import 'package:lock/drawer/imageview.dart';
import 'package:lock/drawer/main.dart';
import 'package:lock/main.dart';

class listFile extends StatefulWidget {
  final String folderName;
  listFile(this.folderName, {Key? key}) : super(key: key);

  @override
  State<listFile> createState() => listFileState();
}

class listFileState extends State<listFile> {
  @override
  void initState() {
    super.initState();
    service.getAllfield("${widget.folderName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Folder - ${widget.folderName}"),
      ),
      body: FutureBuilder(
          future: service.getAllfield("${widget.folderName}"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (service.fieldnum == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Folder is empty,",
                      style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                    ),
                    Text(
                      "Try uploading files to add data",
                      style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                    ),
                  ],
                ),
              );
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: GridView.builder(
                itemCount: service.fieldnum,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 6 / 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Material(
                        child: InkWell(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 9.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                color: Colors.black,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage((() {
                                      if (service.getFileName(
                                              "${service.data?.values.elementAt(index)}") ==
                                          "Pdf") {
                                        return "https://play-lh.googleusercontent.com/LvJB3SJdelN1ZerrndNgRcDTcgKO49d1A63C5hNJP06rMvsGkei-lwV52eYZJmMknCwW";
                                      }
                                      if (service.getFileName(
                                              "${service.data?.values.elementAt(index)}") ==
                                          "Image") {
                                        return "${service.data?.values.elementAt(index)}";
                                      }
                                      return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ48xNWMO9RwCCkrcrabSKoMi6eTy-O6aCJmjCx7Txlu53ZzI34ILJuCVNjbcBcufNpeJ0&usqp=CAU";
                                    })()))),
                          ),
                          splashColor: Colors.black26,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageView(
                                        "${service.data?.values.elementAt(index)}")));
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                blurRadius: 5,
                                spreadRadius: 0,
                                offset: Offset(
                                  5.0,
                                  5.0,
                                ),
                              ),
                            ],
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(left: 13, right: 5),
                                child: Text(
                                    "${service.data?.keys.elementAt(index)}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            PopupMenuButton(
                              onSelected: (value) async {
                                Future.delayed(
                                    Duration(microseconds: 0),
                                    showdeltealert(
                                        index, "${widget.folderName}"));
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Row(children: [
                                    Icon(Icons.delete),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Delete",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))
                                  ]),
                                  value: 1,
                                )
                              ],
                              icon: Icon(Icons.more_vert, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }),
      floatingActionButton: PopupMenuButton(
        iconSize: 45,
        icon: Icon(Icons.add, color: Color.fromARGB(255, 0, 102, 255)),
        onSelected: (value) async {
          if (value == UploadItem.item1) {
            file = null;
            uploadFiledialog();
          }
          if (value == UploadItem.item2)
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Imageclick(widget.folderName)));
          setState(() {});
        },
        itemBuilder: (context) => [
          PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.file_upload),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Upload file",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              value: UploadItem.item1),
          PopupMenuItem(
              child: Row(children: [
                Icon(Icons.camera_alt),
                SizedBox(
                  width: 10,
                ),
                Text("Camera", style: TextStyle(fontWeight: FontWeight.w500))
              ]),
              value: UploadItem.item2),
        ],
      ),
    );
  }

  uploadFiledialog() {
    showDialog(
        context: context,
        builder: (context) => 
              AlertDialog(
                title: Text(
                  "Select file",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Container(
                    child: file?.name == null
                        ? Image(
                            width: double.infinity,
                            height: 200,
                            image: NetworkImage(
                              'https://wallpaperaccess.com/full/396671.jpg',
                            ),
                            fit: BoxFit.cover,
                          )
                        : Image(
                            width: double.infinity,
                            height: 200,
                            image: FileImage(File(file?.path ?? "")),
                            fit: BoxFit.cover,
                          )),
                actions: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          primary: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onPressed: () async {
                        SelectFile();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Browse",
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          primary: Color.fromARGB(255, 0, 102, 255),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await uploadFile(widget.folderName, UserId);
                      },
                      child: Text(
                        "Upload",
                        style: TextStyle(fontSize: 16),
                      )),
                ],
              )
            );
  }

  PlatformFile? file = null;
  Future SelectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      file = result.files.first;
    });
    await Future.delayed(Duration.zero, uploadFiledialog());
  }

  Future uploadFile(String folderName, String Id) async {
    if (file != null) {
      final path = '$Id/$folderName/${file!.name}';
      final uploadfile = File(file!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(uploadfile);
      String url = await ref.getDownloadURL();
      service.updateFiledoc(folderName, "${file?.name.split(".")[0]}", url);
      setState(() {
        file = null;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No file Selected")));
    }
  }

  showdeltealert(index, foldername) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                insetPadding: EdgeInsets.all(45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                title: Text(
                  "Warning",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text("Are you sure to delte this file?"),
                actions: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[300],
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[800]),
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 0, 102, 255),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width /
                                              12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              onPressed: () async {
                                Navigator.of(context).pop();

                                await service.deleteFirestoredata(
                                    index, foldername);

                                setState(() {});
                              },
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ))
                        ]),
                  )
                ]));
  }
}
