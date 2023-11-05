import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class ConfirmPin extends StatelessWidget {
  var pin ;
   ConfirmPin({Key? key ,required this.pin}) : super(key: key);
   var mastercont = TextEditingController();
   var confcont = TextEditingController();
   var confpin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate Pin"),),
      body: FutureBuilder(
        future: getMaster(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)return Center(child: CircularProgressIndicator(),);
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            width: MediaQuery.of(context).size.width,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              Text("Never Forget Master key" ,style: TextStyle(color: Colors.red ,fontSize: 15),),
              Text("Master Key" ,style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w600)),
              SizedBox(height: 20,),
              TextField(
                        maxLength: 50,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            color: Colors.black87, fontSize: 20),
                        controller: mastercont,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.key,
                            color: Colors.black87,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black87, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black87, width: 1.5),
                          ),
                          hintText: "Key",
                          hintStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
              SizedBox(height: 20,),
              Text("Re-enter to confirm your pin code" ,textAlign: TextAlign.center ,style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w600)),
              SizedBox(height: 20,),
              PinCodeTextField(
                controller: confcont,
                      showCursor: false,
                      hintCharacter: 'X',
                      obscureText: true,
                  blinkWhenObscuring: true,
                  obscuringCharacter: 'X',
                      cursorColor: Colors.black,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        inactiveColor: Colors.black,
                      ),
                      appContext: context,
                      length: 6,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        confpin = value;
                      },
                    ),
                    ElevatedButton(onPressed: (){
                      confirmpin(context);
                    }, child: Text("Confirm" ,style: TextStyle(fontSize: 20)),
style: ElevatedButton.styleFrom(minimumSize: Size(500,50),
                shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),)
                    ],
          ),);
        }
      ),

    );
    
  }
getMaster()async{
  var d = await FirebaseFirestore.instance.collection('Passwords').doc(FirebaseAuth.instance.currentUser?.email).get();
  if(d.data()?['master'] == null){
    mastercont.text = '';
  }else{
  mastercont.text = d.data()?['master'];
  }


}

  confirmpin(context)async{
  
  if(confpin.length < 6 || mastercont.text.trim().isEmpty){
    print(confcont.text.length);
    return           ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter 6 digit pin or fill master key")));
  }
    if(confpin == pin){
    var firbase = FirebaseFirestore.instance;
    var d = await firbase.collection("Passwords").doc(FirebaseAuth.instance.currentUser?.email).set({"pin" : confpin , 'master': mastercont.text.trim()});
    confpin = "";
    Navigator.of(context).pop();
Navigator.of(context).pop();
  }else{
              ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Pin mismatch")));
  }
  }
}