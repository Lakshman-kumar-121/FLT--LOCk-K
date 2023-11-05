import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lock/main.dart';

class Reset extends StatefulWidget {
  const Reset({Key? key}) : super(key: key);

  @override
  State<Reset> createState() => _Reset();
}

class _Reset extends State<Reset> {
  TextEditingController mail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text("Password reset"),
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("${wallprimg}"), fit: BoxFit.cover)),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                maxLength: 50,
                style: TextStyle(
                    color: Colors.white.withOpacity(.8), fontSize: 20),
                controller: mail,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    hintText: "Mail",
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    )),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (mail.text.isNotEmpty) {
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: mail.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("A reset mail has been to above email")));
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${e.message}")));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter mail")));
                  }
                  mail.text = "";
                },
                child: Text(
                  "Send",
                  style: TextStyle(fontSize: 20, color: Colors.grey[200]),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 80, vertical: 15)),
              )
            ],
          )),
    );
  }
}
