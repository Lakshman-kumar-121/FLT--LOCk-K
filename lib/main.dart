import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lock/Login_screen/Authenticate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lock/drawer/main.dart';
import 'package:lock/firstore_service/firestore_service.dart';
import 'package:open_settings/open_settings.dart';
import 'package:lock/startup/firstscreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

var UserId;
var CurUser;
late List<CameraDescription> cameras;
var wallprimg ;
    
var unknownimg ;
   
var audioimg ;

var pdfimg ;
  

var clipartimg ;

var signUpimg ;

var loginimg ;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late final showHome;
  prefs.then((value) {
    showHome = value.getBool('showHome') ?? false;
  });
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(MyApp(
    showHome: showHome,
  ));
  
}

var login = 0;
late firestore_service service;

class MyApp extends StatefulWidget {
  final showHome;
  const MyApp({this.showHome, Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

StreamController stm = StreamController.broadcast();
Stream get onVariableChanged => stm.stream;
void updateMyUI() => stm.sink.add(login);

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    service = firestore_service();
    service.checkupdate();
    
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: widget.showHome == true ? HomePage() : StartSceen());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
        return Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserId = FirebaseAuth.instance.currentUser?.email;
                  return FutureBuilder(
                    future: service.checkupdate(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      Future.delayed(Duration.zero, () async {
                        checkconnection(context);
                      });
                      Future.delayed(Duration.zero, () async {
                        if (service.updatestatus != 0) {
                          openDialog(service.updatestatus, context);
                        }
                      });
                      return 
                      // Forgotpin(); 
                      // ConfirmPin(pin: 'asd'); 
                      Home();
                    },
                  );
                }
                return Authenticate();
              }),
        );
      },
    );
  }

  checkconnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      Future.delayed(Duration.zero, () async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: ((context) => AlertDialog(
                  title: Text("Oops"),
                  content: Text("No Internet availabe!"),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: Text("Okay"))
                  ],
                )));
      });
    }
  }

  openDialog(value, BuildContext contexts) {
    int status = value;
    var contents = (status == 1
        ? "A new version available"
        : "This is an older verision. Please update the app from website");

    showDialog(
      barrierDismissible: status == 1 ? true : false,
      context: contexts,
      builder: (contexts) => AlertDialog(
        title: Text("Update"),
        content: Text(contents),
        actions: [
          ElevatedButton(
              onPressed: () {
                if (status == 1) {
                  Navigator.of(contexts).pop();
                } else {
                  SystemNavigator.pop();
                }
              },
              child: Text("Got it!"))
        ],
      ),
    );
    ;
  }
}

getData() async{
  var res = await FirebaseFirestore.instance.collection("Admin_accesory").doc("Images").get();
  var data = res.data();
  audioimg = data!["audioimg"];
  clipartimg = data["clipartimg"]; 
  loginimg = data["loginimg"];
  pdfimg = data["pdfimg"];
  signUpimg = data["signUpimg"];
  unknownimg = data["unknownimg"];
  wallprimg = data["wallprimg"];
}
