import 'package:flutter/material.dart';
import 'screens/main.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter login demo',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => new MainScreen(),
        // '/account': (BuildContext context) => new AccountScreen(),
        
        // '/signin': (BuildContext context) => new LoginPage(),
        // '/scan': (BuildContext context) => new AccountScreen() ,
      },
      home: new MainScreen(),
      //home: new Splash(),
    );
  }
}