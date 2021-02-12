import 'dart:async';
import 'package:hive/hive.dart';

import '../essentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title }) : super(key: key);
  final String title;
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Box nodeBox;

  @override
  void initState(){
    super.initState();
    hiveSetup().then((value) {
      setState(() => nodeBox = globalBox );
      if(!nodeBox.containsKey("auth")){
        nodeBox.put("auth", {"registered":false});
      }
      Timer(
        Duration(seconds: 1),
        ()=>Navigator.pushNamed(context, "/auth")
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery. of(context). size. width;
    double screenHeight = MediaQuery. of(context). size. height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(49,27,146 ,1),
      body:Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: screenWidth/2-100,
              top: screenHeight/2-100,
              child: Container(
                width: 200.0,
                height: 200.0,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/SaveNodesLogo.png'),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            Positioned(
              top: screenHeight-70,
              left: 0,
              right: 0,
              child: Text('Save Nodes',
                style: TextStyle(
                  fontSize:27,
                  color:Colors.blue[100],
                ),
                textAlign: TextAlign.center
              ),
            ),
            Positioned(
              top: screenHeight-30,
              left: 0,
              right: 0,
              child: Text('Developed by rvstowrn',
                style: TextStyle(
                  fontSize:15,
                  color:Colors.blue[100],
                ),
                textAlign: TextAlign.center
              ),
            ),
          ],
        ),
      ), 
    );
  }

}