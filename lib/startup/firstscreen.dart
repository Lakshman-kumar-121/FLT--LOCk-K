import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lock/main.dart';
import 'package:open_settings/open_settings.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartSceen extends StatefulWidget {
  const StartSceen({Key? key}) : super(key: key);

  @override
  State<StartSceen> createState() => _StartSceenState();
}

class _StartSceenState extends State<StartSceen> {
  var controller;
  var pfcontroller = PageController();
  var page;

  @override
  void initState() {
    controller = LiquidController();
 
    page = 0;
    super.initState();
    demo();
  }
    Future demo()async{

       final audiop = Permission.audio;
       final cam = Permission.camera;
         final  permis = Permission.manageExternalStorage;
      try{
      if( ! await permis.isGranted){
await OpenSettings.openManageAllFilesAccessPermissionSetting();
      }
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please allow the permission for full functional use")));
    }


      try{
      if( ! await audiop.isGranted){
        Permission.audio.request();
      }
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please allow the permission for full functional use")));
    }
    try{
      if( ! await cam.isGranted){
        Permission.camera.request();
      }
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please allow the permission for full functional use")));
    }

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidSwipe(
        onPageChangeCallback: (activePageIndex) {
          setState(() {
            page = activePageIndex;
          });
        },
        liquidController: controller,
        pages: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 50),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.blueAccent,
              child: Center(
                  child: Column(
                children: [
                  Image(
                      width: MediaQuery.of(context).size.width * 0.5,
                      image: AssetImage("assets/gvault.png")),
                  SizedBox(height: 40),
                  Text(
                    "Welcome to",
                    style: TextStyle(fontSize: 50, color: Colors.grey[800]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Gallery Vault 2.0",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 40,
                          color: Colors.white))
                ],
              ))),
          Container(
            padding: EdgeInsets.symmetric(vertical: 50),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.greenAccent,
            child: Center(
                child: Column(
              children: [
                Image(
                    image: AssetImage(
                      "assets/gvault.png",
                    ),
                    width: MediaQuery.of(context).size.width * 0.5),
                SizedBox(height: 40),
                Text(
                  "Safe files",
                  style: TextStyle(fontSize: 50, color: Colors.grey[800]),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Save your files to cloud",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Colors.blueAccent)),
                SizedBox(
                  height: 10,
                ),
                Text("Acess Anywhere Anytime",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Colors.blueAccent)),
                SizedBox(
                  height: 10,
                ),
                Text("On Any Device",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Colors.blueAccent)),
              ],
            )),
          ),
          Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Center(
                  child: Column(
                children: [
                  Image(
                    image: AssetImage(
                      "assets/gvault.png",
                    ),
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Safe files",
                    style: TextStyle(fontSize: 50, color: Colors.grey[800]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Amazing Friendly UI",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.blueAccent)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Drop on App now!",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.blueAccent)),
                ],
              )),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              padding: EdgeInsets.only(bottom: 50, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Get started",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100))),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool('showHome', true);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomePage()));
                      },
                      child: Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.black,
                        size: 50,
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () {
                controller.jumpToPage(page: 2);
              },
              child: Text(
                "Skip",
                style: TextStyle(color: Colors.black87, fontSize: 20),
              )),
          Row(children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: page == 0 ? Colors.white : Colors.white60,
                  borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: page == 1 ? Colors.white : Colors.white60,
                  borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: page == 2 ? Colors.white : Colors.white60,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ]),
          TextButton(
              onPressed: () {
                page = controller.currentPage + 1;
                setState(() {
                  page;
                });
                controller.animateToPage(page: page, duration: 400);
              },
              child: Text(
                "Next",
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ))
        ],
      ),
    );
  }
}
