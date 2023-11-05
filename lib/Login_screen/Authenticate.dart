import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lock/Login_screen/Resetmail.dart';

import 'package:lock/drawer/Verify.dart';
import 'package:lock/main.dart';
import 'package:lock/privacy/privacy.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';

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

  final mailctrlsign = TextEditingController();
  final passwordctrlsign = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (login == 0) {
      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.8),
        body: Container(
          width: MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(loginimg), fit: BoxFit.cover)),
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
                      "Gallery Vault 2.0",
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
                    keyboardType: TextInputType.emailAddress,
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                   Center(
                     child: TextButton(onPressed: (){
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => Privacy(),));
                               },
                   
                                 child: RichText(text: TextSpan( children: [TextSpan(text: "By using Gallery vault 2.0 you agree to our ") ,
                                  TextSpan(text: "\n   Terms of Service " ,style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: " and") , 
                                  TextSpan(text: " Privacy Policy" ,style: const TextStyle(fontWeight: FontWeight.bold))] ,),),
                               ),
                   )
                  
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(signUpimg), fit: BoxFit.cover)),
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
                    "Gallery Vault 2.0",
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
                  keyboardType: TextInputType.emailAddress,
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Center(
                    child: TextButton(onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Privacy(),));
                              },
                  
                                child: RichText(text: TextSpan( children: [TextSpan(text: "By using Gallery vault 2.0 you agree to our ") ,
                                 TextSpan(text: "\n   Terms of Service " ,style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: " and") , 
                                 TextSpan(text: " Privacy Policy" ,style: const TextStyle(fontWeight: FontWeight.bold))] ,),),
                              ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future Signin() async {
    try {
  final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: mailctrl.text.trim(), password: passwordctrl.text.trim());
  if (res != null) FirebaseAuth.instance.idTokenChanges();
} on PlatformException catch (err) {
  print("eprr");
  // Handle err
} catch (err) {
  print("eprr1");
  // other types of Exceptions
}
    // try {
    //   await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: mailctrl.text.trim(), password: passwordctrl.text.trim());
    //   FirebaseAuth.instance.idTokenChanges();
    // } on FirebaseAuthException catch (e) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text("${e.message}")));
    // }
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
