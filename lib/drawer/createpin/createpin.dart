import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

import 'package:lock/drawer/createpin/confirmpin.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CreatePin extends StatelessWidget {
   CreatePin({Key? key}) : super(key: key);
   var pincont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate Pin"),),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        width: MediaQuery.of(context).size.width,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          Text("Enter 6 digit Pin" ,style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w600)),
          SizedBox(height: 20,),
          PinCodeTextField(
            controller: pincont,
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
                    
                  },
                ),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfirmPin(pin: pincont.text,),));
                }, child: Text("Next" ,style: TextStyle(fontSize: 20)) ,
                style: ElevatedButton.styleFrom(minimumSize: Size(500,50),
                shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),)
                ],
      ),),

    );
  }
}