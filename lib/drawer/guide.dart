import 'package:flutter/material.dart';
import 'package:lock/main.dart';

class Guide extends StatelessWidget {
  const Guide({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        extendBody: true,
        appBar: AppBar(
          title: Text("Guide"),
        ),
        body: Container(
          child: Stack(
            children: [
              Image(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                image: NetworkImage(
                    '${wallprimg }'),
                fit: BoxFit.cover,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Guide for Gallery Vault 2.0",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        Divider(),
                        Text("Rules",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25)),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                            "1)This app used for storing important files.\n2) Try uploading small and required files to this app cloud.\n3)This app can you store Images , pdf's and audio files , others kind of files are not suppored as this is only used for private files. \n4)As this store your data to cloud , you can acess it from any device with your account",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(
                          height: 25,
                        ),
                        Text("Uploading process",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25)),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                            "You can either create folders to organise your directory structure or directly upload to default folder. \n2)Click on plus button to add folder or upload file. \n3)uploading file can be either clicking with camera or uploading existing file.\n4)Deleted files cannot be recovered so be careful while deleting",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(
                          height: 25,
                        ),
                        Text("Download the file",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25)),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                            "1) To download the file .Open the file and click on download button",
                            style: TextStyle(color: Colors.white)),
                        Text("Note",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25)),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                            "Files will be saved in /storage/emulated/0/Android/data/com/personal.lock/files \nThis is for safety and protecting detection of your files from other apps.\n Use google files to view and use your files. ",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
