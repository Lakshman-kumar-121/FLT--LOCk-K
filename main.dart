import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lock/Login_screen/Authenticate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lock/drawer/main.dart';
import 'package:lock/firstore_service/firestore_service.dart';
import 'package:lock/startup/firstscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

var UserId;
var CurUser;
late List<CameraDescription> cameras;
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
                  return Home();
                },
              );
            }
            return Authenticate();
          }),
    );
  }

  checkconnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      Future.delayed(Duration.zero, () async {
        showDialog(
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
