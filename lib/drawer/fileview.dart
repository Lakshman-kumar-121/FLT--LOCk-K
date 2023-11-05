import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lock/Camera/Camera.dart';
import 'package:lock/audiorecord.dart/record.dart';
import 'package:lock/drawer/imageview.dart';
import 'package:lock/drawer/main.dart';
import 'package:lock/main.dart';
import 'package:open_settings/open_settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:filesystem_picker/filesystem_picker.dart';

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
    demo();
  }

  Future demo() async {
    final audiop = Permission.audio;
    final cam = Permission.camera;
    final permis = Permission.manageExternalStorage;
    try {
      if (!await permis.isGranted) {
        await OpenSettings.openManageAllFilesAccessPermissionSetting();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Please allow the permission for full functional use")));
    }

    try {
      if (!await audiop.isGranted) {
        Permission.audio.request();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Please allow the permission for full functional use")));
    }
    try {
      if (!await cam.isGranted) {
        Permission.camera.request();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Please allow the permission for full functional use")));
    }
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
                                        return "${pdfimg}";
                                      }
                                      if (service.getFileName(
                                              "${service.data?.values.elementAt(index)}") ==
                                          "Image") {
                                        return "${service.data?.values.elementAt(index)}";
                                      }
                                      if (service.getFileName(
                                                  "${service.data?.values.elementAt(index)}") ==
                                              "mp3" ||
                                          file?.extension == 'mp4' ||
                                          file?.extension == 'ogg' ||
                                          file?.extension == 'aac' ||
                                          file?.extension == 'awb' ||
                                          file?.extension == 'amr' ||
                                          file?.extension == 'waw' ||
                                          file?.extension == 'm4a' ||
                                          file?.extension == 'opus') {
                                        return "${audioimg}";
                                      }
                                      return "${unknownimg}";
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
            uploadFiledialog(context);
          }
          if (value == UploadItem.item3) {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => audiorecord(folderName: widget.folderName),
            ));
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
              child: Row(
                children: [
                  Icon(Icons.mic),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Record",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              value: UploadItem.item3),
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

  checkfile() {
    print("hey");
    if (file?.extension == 'png' ||
        file?.extension == 'jpg' ||
        file?.extension == 'jpeg') {
      return Image(
        width: 500,
        height: 200,
        image: FileImage(File(file?.path ?? "")),
        fit: BoxFit.cover,
      );
    } else if (file?.extension == 'pdf') {
      return Image.network(
        "${pdfimg}",
        width: 500,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (file?.extension == 'mp3' ||
        file?.extension == 'mp4' ||
        file?.extension == 'ogg' ||
        file?.extension == 'aac' ||
        file?.extension == 'awb' ||
        file?.extension == 'amr' ||
        file?.extension == 'waw' ||
        file?.extension == 'm4a' ||
        file?.extension == 'opus') {
      return Image.network(
        "${audioimg}",
        width: 500,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        "${unknownimg}",
        width: 500,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  uploadFiledialog(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                          width: 500,
                          height: 200,
                          image: NetworkImage(
                            '${wallprimg}',
                          ),
                          fit: BoxFit.cover,
                        )
                      : checkfile()),
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
            ));
  }

  PlatformFile? file = null;
  var result;
  Future SelectFile() async {
    print("printing file id");

    var a = await getExternalStorageDirectories();
    dir = [];
    for (int x = 0; x < a!.length; x++) {
      var pth = a.elementAt(x).path.toString().split("/Android")[0];
      dir.add(pth);
    }
    

    // result = await FilePicker.platform.pickFiles(withData: true);
    
    if (result == null) return;
    setState(() {
      file = result.files.first;
    });

    await Future.delayed(Duration.zero, uploadFiledialog(context));
  }

  Future uploadFile(String folderName, String Id) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: Container(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );
    if (file != null) {
      print(result.files.first.identifier);

      final path = '$Id/$folderName/${file!.name}';
      final ref = FirebaseStorage.instance.ref().child(path);
      var fsile = File(file!.path!);

      try {
        await ref.putFile(fsile);

        String url = await ref.getDownloadURL();
        print("worked till here");
        service.updateFiledoc(folderName, "${file?.name.split(".")[0]}", url);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error ${e.toString()}")));
      }

      setState(() {
        file = null;
      });
      print("file printing");

      var d;

      for (int x = 0; x < dir.length; x++) {
        String encodedUrl = result.files.first.identifier;
        String decodedUrl = Uri.decodeFull(encodedUrl);
        var leftpart = decodedUrl.split(":")[2];

        var s = dir.elementAt(x).split("/storage/")[1];
        if ("${result.files.first.identifier}".contains(s)) {
          d = "${dir.elementAt(x)}/$leftpart";
          break;
        }
        if ("${result.files.first.identifier}".contains("primary")) {
          d = "${dir.elementAt(x)}/$leftpart";
          break;
        }
      }
      String encodedUrl = result.files.first.identifier;
      String decodedUrl = Uri.decodeFull(encodedUrl);
      var leftpart = decodedUrl.split(":")[2];
      if (d == null) {
        d = "${dir.elementAt(0)}/$leftpart";
      }

      print(d);

      var fil = File(d);
      try {
        if (fil.existsSync()) {
          await fil.delete().then((value) => print("deleted bro"));
        }
      } catch (e) {
        print('failed to delete bro');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Got an error while deleting the file")));
      }
      print(result.files.first.path);
      await File("${result.files.first.path}").delete();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No file Selected")));
    }
    FilePicker.platform.clearTemporaryFiles();
    Navigator.of(context).pop();
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

var dir = [];
