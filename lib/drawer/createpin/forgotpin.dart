import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lock/drawer/createpin/createpin.dart';

class Forgotpin extends StatelessWidget {
   Forgotpin({Key? key}) : super(key: key);
  var mailcont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(appBar: AppBar(title: Text("Forgot pin"),),body: Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Enter your Master key " ,style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w600)),
          SizedBox(height: 20,),
           TextField(
                        maxLength: 50,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            color: Colors.black87, fontSize: 20),
                        controller: mailcont,
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
          ElevatedButton(onPressed: (){
            sendverify(context);
            
          }, child: Text("Verify" ,style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(minimumSize: Size(500,50),
                shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),)
        ],
      ),
    ),);
  }

  sendverify(context)async{
    
    var d = await FirebaseFirestore.instance.collection('Passwords').doc(FirebaseAuth.instance.currentUser?.email).get();
    var mkey = d.data()?['master'];
    if(mkey == null){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You dont have any key, Please create one')));
    Navigator.of(context).pop();
      mailcont.text = '';
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePin()));
    }
    else if(mkey == mailcont.text.trim()){
      Navigator.of(context).pop();
      mailcont.text = '';
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePin()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong key')));
    }
  }


}