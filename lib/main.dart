import 'package:flutter/material.dart';
import 'Pages/auth.dart';
import 'Pages/nodes.dart';
import 'Pages/splash.dart';

void main() {
  runApp(InitApp());
}

class InitApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData( primarySwatch: Colors.orange),
      title: 'Save Nodes',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashPage(),
        '/auth': (context) => AuthPage(),  
        '/nodes': (context) => NodesPage(),
      },
    );
  }
  
}


