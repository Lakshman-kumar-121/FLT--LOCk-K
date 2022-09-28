import 'dart:io';
import 'package:lock/drawer/About.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lock/drawer/folder.dart';
import 'package:lock/drawer/guide.dart';
import 'package:lock/main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

final number = List.generate(100, (index) => "$index");

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 32, 32, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
          ),
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.only(left: 13, right: 12),
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: Image.asset(
                    'assets/lock.png',
                    fit: BoxFit.contain,
                    height: 130,
                    color: Colors.grey[100],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, bottom: 10),
                  child: Text(
                    "Account:",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, bottom: 10, top: 10),
                  child: Text(
                    UserId,
                    style: TextStyle(color: Colors.grey[100], fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, bottom: 10),
                  child: Text(
                    "Menu",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  leading: Icon(
                    Icons.insert_page_break_outlined,
                    color: Colors.grey[300],
                  ),
                  title: Text(
                    "Guide",
                    style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Guide()));
                  },
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.grey[300],
                  ),
                  title: Text(
                    'Log out',
                    style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                ),
                Divider(
                  color: Colors.grey[500],
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, top: 20),
                  child: Text(
                    "Creater",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  leading: Icon(
                    Icons.feedback_outlined,
                    color: Colors.grey[300],
                  ),
                  title: Text(
                    "Feedback",
                    style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    feed.text = "";
                    feedback();
                  },
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  leading: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.grey[300],
                  ),
                  title: Text(
                    "About",
                    style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => About()));
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text("Lock Files"),
        ),
        body: Try(),
        floatingActionButton: PopupMenuButton(
          iconSize: 45,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onSelected: (value) {
            if (value == MenuItem.item1) NewFolder();
            if (value == MenuItem.item2) {
              file = null;
              Future.delayed(
                  Duration(milliseconds: 0), uploadFiledialog(context));
            }
          },
          icon: Icon(
            Icons.add,
            color: Color.fromARGB(255, 0, 102, 255),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.create_new_folder_sharp),
                  SizedBox(
                    width: 10,
                  ),
                  Text("New folder",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              value: MenuItem.item1,
            ),
            PopupMenuItem(
              child: Row(children: [
                Icon(Icons.upload),
                SizedBox(
                  width: 10,
                ),
                Text("Upload file",
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ]),
              value: MenuItem.item2,
            ),
          ],
        ));
  }

  TextEditingController newfoltext = TextEditingController();
  NewFolder() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "New Folder",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: TextField(
                controller: newfoltext,
                autofocus: true,
              ),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        primary: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
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
                      if (newfoltext.text.isNotEmpty) {
                        service.createFolder(newfoltext.text.trim());
                        setState(() {});
                        newfoltext.clear();
                      }
                    },
                    child: Text(
                      "Create",
                      style: TextStyle(fontSize: 16),
                    )),
              ],
            ));
  }

  uploadFiledialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
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
                        await uploadFile("Default", UserId);
                      },
                      child: Text(
                        "Upload",
                        style: TextStyle(fontSize: 16),
                      )),
                ],
              );
            }));
  }

  TextEditingController feed = TextEditingController();
  feedback() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Feedback",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: TextField(
                maxLength: 70,
                controller: feed,
                autofocus: true,
              ),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        primary: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
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
                      if (feed.text.isNotEmpty) {
                        service.sendFeedback("${feed.text}");
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Thanks for you feedback")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Feedback is emplty")));
                      }
                    },
                    child: Text(
                      "Send",
                      style: TextStyle(fontSize: 16),
                    )),
              ],
            ));
  }

  Future uploadFile(String folderName, String Id) async {
    if (file != null) {
      final path = '$Id/$folderName/${file!.name}';
      final uploadfile = File(file!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(uploadfile);
      String url = await ref.getDownloadURL();
      service.updateFiledoc(folderName, "${file?.name.split(".")[0]}", url);
      setState(() {});
      file = null;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No file Selected")));
    }
  }

  var file = null;
  Future SelectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      file = result.files.first;
    });
    await Future.delayed(Duration.zero, uploadFiledialog(context));
  }
}

enum MenuItem { item1, item2, item3 }

enum UploadItem {
  item1,
  item2,
}
