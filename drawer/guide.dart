import 'package:flutter/material.dart';

class Guide extends StatelessWidget {
  const Guide({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("About"),
        ),
        body: Container(
          decoration: BoxDecoration(),
          child: Stack(
            
            children: [
              Image(
                width: double.infinity,
                image:
                    NetworkImage('https://wallpaperaccess.com/full/396671.jpg'),
                fit: BoxFit.cover,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Guide for Lock safe",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    Divider(),
                    Text("Rules",
                        style: TextStyle(color: Colors.white, fontSize: 25)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        "1)This app used for storing important files.2) Try uploading small and required files to this app cloud.3)This app can you store Images and pdf's, any others kind of files are not suppored as this is only used for private files. 4)As this store your data to cloud , you can acess it from any device with your account",
                        style: TextStyle(color: Colors.white)),
                    SizedBox(
                      height: 25,
                    ),
                    Text("Uploading process",
                        style: TextStyle(color: Colors.white, fontSize: 25)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        "You can either create folders to organise your directory structure or directly upload to default folder. 2)Click on plus button to add folder or upload file. 3)uploading file can be either clicking with camera or uploading existing file.4)Deleted files cannot be recovered so be careful while deleting",
                        style: TextStyle(color: Colors.white)),
                    SizedBox(
                      height: 25,
                    ),
                    Text("Download the file",
                        style: TextStyle(color: Colors.white, fontSize: 25)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        "1) To download the file, either open file and click on download button or select the file (3 dots) and on pop up menu click download!",
                        style: TextStyle(color: Colors.white))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
