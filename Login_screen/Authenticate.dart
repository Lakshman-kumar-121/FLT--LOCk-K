import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lock/Login_screen/Resetmail.dart';

import 'package:lock/drawer/Verify.dart';
import 'package:lock/main.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final mailctrl = TextEditingController();

  final passwordctrl = TextEditingController();
  late bool _passwordVisible;
  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  final mailctrlsign = TextEditingController();
  final passwordctrlsign = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (login == 0) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("login.jpg"), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(top: 250, left: 25, right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Safe Lock",
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    maxLength: 50,
                    style: TextStyle(
                        color: Colors.white.withOpacity(.8), fontSize: 20),
                    controller: mailctrl,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.person,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      hintText: "Name",
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    maxLength: 50,
                    controller: passwordctrl,
                    obscureText: _passwordVisible,
                    style: TextStyle(
                        color: Colors.white.withOpacity(.8), fontSize: 20),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        color: Colors.white.withOpacity(0.8),
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              login = 1;
                            });
                          },
                          child: Text("Sign Up?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13)),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Reset(),
                                ));
                          },
                          child: Text("Forgot Password?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (mailctrl.text.isNotEmpty &&
                          passwordctrl.text.isNotEmpty) {
                        Signin();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Fill all field")));
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.purpleAccent[700], fontSize: 23),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        primary: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("Signup.jpg"), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(top: 150, left: 25, right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Safe Lock",
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                TextField(
                  controller: mailctrlsign,
                  maxLength: 50,
                  style: TextStyle(
                      color: Colors.white.withOpacity(.8), fontSize: 20),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      hintText: "Email",
                      suffixIcon: Icon(
                        Icons.person,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  obscureText: _passwordVisible,
                  maxLength: 50,
                  style: TextStyle(
                      color: Colors.white.withOpacity(.8), fontSize: 20),
                  controller: passwordctrlsign,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        color: Colors.white.withOpacity(0.8),
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      )),
                ),
               InkWell(
                    onTap: () {
                       setState(() {
                      login = 0;
                    });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Login?",
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ),
                
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (mailctrlsign.text.isNotEmpty &&
                        passwordctrlsign.text.isNotEmpty) {
                      createNewAccount(mailctrlsign.text.trim(),
                          passwordctrlsign.text.trim());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Fill all fields")));
                    }
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                        color: Colors.purpleAccent[700], fontSize: 23),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future Signin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mailctrl.text.trim(), password: passwordctrl.text.trim());
      FirebaseAuth.instance.idTokenChanges();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.message}")));
    }
  }

  createNewAccount(mail, password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: password)
          .then((value) async {
        mailctrlsign.text = "";
        passwordctrlsign.text = "";
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => VerifyScreen())));
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.message}")));
    }
  }
}
