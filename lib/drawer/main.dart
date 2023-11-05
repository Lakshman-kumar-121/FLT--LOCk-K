import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lock/drawer/About.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lock/drawer/createpin/createpin.dart';
import 'package:lock/drawer/createpin/forgotpin.dart';
import 'package:lock/drawer/fileview.dart';
import 'package:lock/drawer/folder.dart';
import 'package:lock/drawer/guide.dart';
import 'package:lock/main.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

final version = 0;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

var ispinverified = false;
final number = List.generate(100, (index) => "$index");

class _HomeState extends State<Home> {
  var pincont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (ispinverified == false) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Code"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Enter your code",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              PinCodeTextField(
                controller: pincont,
                showCursor: false,
                obscureText: true,
                blinkWhenObscuring: true,
                obscuringCharacter: 'X',
                hintCharacter: 'X',
                cursorColor: Colors.black,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  inactiveColor: Colors.black,
                ),
                appContext: context,
                length: 6,
                keyboardType: TextInputType.number,
                onChanged: (value) {},
              ),
              ElevatedButton(
                onPressed: () {
                  getPin(context);
                },
                child: Text('Open', style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(500, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              TextButton(
                onPressed: () {
                  showconfdialog(context);
                },
                child: Text("forgot password ?"),
              )
            ],
          ),
        ),
      );
    }
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/gvault.png',
                          fit: BoxFit.contain,
                          height: 130,
                        ),
                      ),
                    ],
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
          title: Text("Gallery Vault 2.0"),
        ),
        body: Try(), //audiorecord(),
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

  checkfile() {
    if (file?.extension == 'png' ||
        file?.extension == 'jpg' ||
        file?.extension == 'jpeg') {
      return Image(
        width: double.infinity,
        height: 200,
        image: FileImage(File(file?.path ?? "")),
        fit: BoxFit.cover,
      );
    } else if (file?.extension == 'pdf') {
      return Image.network(
        "${pdfimg}",
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (file?.extension == 'mp3' ||
        file?.extension == 'mp4' ||
        file?.extension == 'opus' ||
        file?.extension == 'ogg' ||
        file?.extension == 'aac' ||
        file?.extension == 'awb' ||
        file?.extension == 'amr' ||
        file?.extension == 'waw' ||
        file?.extension == 'm4a') {
      return Image.network(
        "${audioimg}",
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        "${unknownimg}",
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }
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

  var file = null;
  var result;
  Future SelectFile() async {
    print("printing file id");
    var a = await getExternalStorageDirectories();
    dir = [];
    for (int x = 0; x < a!.length; x++) {
      var pth = a.elementAt(x).path.toString().split("/Android")[0];
      dir.add(pth);
    }

    result = await FilePicker.platform.pickFiles(withData: true);
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
      print(result.files.first.identifier);
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
        try{
          if (d.split(".").length != 2) {
          var s = File(d + ".png");
          if (s.existsSync()){
            await s.delete();
          }
          

          s = File(d + ".jpg");
          if (s.existsSync()){
            await s.delete();
          }

          s = File(d + ".jpeg");
          if (s.existsSync()){
            await s.delete();
          }
          s = File(d + ".pdf");
          if (s.existsSync()){
            await s.delete();
          }
          s = File(d + ".mp3");
          if (s.existsSync()){
            await s.delete();
          }

          s = File(d + ".mp4");
          if (s.existsSync()){
            await s.delete();
          }
          s = File(d + ".ogg");
          if (s.existsSync()){
            await s.delete();
          }
          s = File(d + ".aac");
          if (s.existsSync()){
            await s.delete();
          }
          s = File(d + ".awb");
          if (s.existsSync()){
            await s.delete();
          }
          s = File(d + ".amr");
          if (s.existsSync()){
            await s.delete();
          }
          s = File(d + ".waw");
          if (s.existsSync()){
            await s.delete();
          }
          s = File(d + ".m4a");
          if (s.existsSync()){
            await s.delete();
          }
          s = File(d + ".opus");
          if (s.existsSync()){
            await s.delete();
          }
        }
        }
        catch(e){
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unable to delete ${e}")));
        }
        if (fil.existsSync()) {
          fil.delete().then((value) => print("deleted bro"));
        }
      } catch (e) {
        print('failed to delete bro');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Got an error while deleting the file")));
      }
      await File("${result.files.first.path}").delete();
      FilePicker.platform.clearTemporaryFiles();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No file Selected")));
    }
    
  }

  showconfdialog(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Enter master key to unlock your account !"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Forgotpin()));
                },
                style: ElevatedButton.styleFrom(minimumSize: Size(100, 40)),
                child: Text(
                  "Yes",
                  style: TextStyle(fontSize: 18),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(minimumSize: Size(100, 40)),
                child: Text("No", style: TextStyle(fontSize: 18)))
          ],
        ),
      );

  getPin(context) async {
    var firebase = FirebaseFirestore.instance;
    var d = await firebase
        .collection("Passwords")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();
    var pin = d.data()?['pin'];
    if (pincont.text.trim().length < 6) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please Enter 6 digit pin")));
    } else if (pin == null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreatePin(),
      ));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Your pin is set empty! Please set a pin for safety")));
    } else if (pin == pincont.text) {
      setState(() {
        ispinverified = true;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Incorrect pin")));
    }
  }
}

enum MenuItem { item1, item2, item3 }

enum UploadItem { item1, item2, item3 }
