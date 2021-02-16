import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../essentials.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  double maxWidth;
  double maxHeight;
  String authOperation=" ";
  String msg=" ";
  Box nodeBox;
  final pinController = TextEditingController();

  
  @override
  void initState(){
    super.initState();
    hiveSetup().then((value) { 
      setState(() => nodeBox = globalBox );
      if(!nodeBox.containsKey("auth")){
        Navigator.pushNamed(context, "/splash");
      }
      else{
        bool registered = nodeBox.get("auth")["registered"];
        setState(() => authOperation = registered ? "Login" : "Register" );
      }
    });
  }


  void setDimensions(context){
    setState(() {
      maxHeight = MediaQuery.of(context).size.height;
      maxWidth= MediaQuery.of(context).size.width;
    });
    if(maxWidth>maxHeight){
      setState(() { maxHeight = maxWidth; });
    }
  }

  Widget label(str) {
    return Text(str,
      style: TextStyle(
        fontSize:20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: Colors.white70,
      ),
    );
  }
  
  Widget input(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orangeAccent),
        borderRadius:const BorderRadius.all(
          const Radius.circular(30.0),
        ), 
      ),
      margin: const EdgeInsets.symmetric(horizontal:40),
      child:new Theme(
        data: new ThemeData(
          primaryColor: Colors.orangeAccent,
          primaryColorDark: Colors.orangeAccent,
        ),
        child:TextField(
          textAlign: TextAlign.center,
          controller: pinController,
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.grey[200]
          ),
          decoration: InputDecoration(
            border: new UnderlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(30.0),
              ),
            ),
            fillColor: Color.fromRGBO(0, 0, 0, 0.5),
            filled: true,
          ),
        ),
      ),
    );
  }

  void handleAuth(){
    String pin = pinController.text;
    if(authOperation == "Login"){
      if(pin == nodeBox.get("auth")["pin"]){
        Navigator.pushNamed(context, "/nodes");
      }
      else{
        setState(() { msg = "Wrong pin"; });
      }
    }
    else{
      nodeBox.put("auth", {"registered":true,"pin":pin});
      Navigator.pushNamed(context, "/nodes");
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    setDimensions(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(255,152,0,1),
      body:SingleChildScrollView (
        child:Container( 
          height: maxHeight,
          width: maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              CircleAvatar(
                radius: 75.0,
                child:Image.asset('assets/SaveNodesLogo.png'),
              ),
              vSpace(40),
              label("Enter PIN"),
              vSpace(10),
              input(),
              vSpace(20),
              RaisedButton(
                onPressed: handleAuth,
                color: Colors.orange[900],
                elevation: 10,
                child: Text(authOperation,
                  style: TextStyle(
                    color:Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              Text(msg),
            ],
          )
        ),
      ),
    );
  }
}