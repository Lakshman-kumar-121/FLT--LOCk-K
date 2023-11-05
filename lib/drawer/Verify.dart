import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lock/drawer/createpin/createpin.dart';
import 'package:lock/main.dart';

class VerifyScreen extends StatefulWidget {
  VerifyScreen({Key? key ,}) : super(key: key);
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  late Timer timer;

  @override
  void initState() {
    CurUser = auth.currentUser!;
    CurUser.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkmailVerify();
    });
    super.initState();
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Verification"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "A email has been send to",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "${CurUser.email}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "for verification",
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.currentUser?.delete();
                    
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkmailVerify() async {
    print('workung till here');
    await CurUser.reload();
    FirebaseAuth.instance.currentUser!.emailVerified;
    
    if (CurUser.emailVerified) {
      timer.cancel();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Account created succefully")));
      Navigator.pop(context);
      FirebaseAuth.instance.idTokenChanges();
      

      
    }
  }
}
