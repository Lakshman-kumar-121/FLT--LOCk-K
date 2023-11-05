import 'package:flutter/material.dart';
import 'package:lock/main.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        appBar: AppBar(
          title: Text("About"),
        ),
        body: Container(
          decoration: BoxDecoration(),
          child: Stack(
            children: [
              Image(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                image: NetworkImage(
                    '${wallprimg}'),
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "About Creater",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Image.network(clipartimg , height: 20,),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Company: Software Technologies",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
