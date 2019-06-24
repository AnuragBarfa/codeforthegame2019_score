import 'package:flutter/material.dart';
import 'screens/main.dart';
import 'screens/match_detail.dart';
import 'screens/live.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter login demo',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => new MainScreen(),
        // '/previous':(BuildContext context) => new History(),
        // '/account': (BuildContext context) => new AccountScreen(),
        
        // '/signin': (BuildContext context) => new LoginPage(),
        // '/scan': (BuildContext context) => new AccountScreen() ,
      },
      // home: new Live("sr:match:17517251"),
      home: new MainScreen(),
    );
  }
}






// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter login demo',
//       debugShowCheckedModeBanner: false,
//       routes: <String, WidgetBuilder>{
//         '/account': (BuildContext context) => new AccountScreen(),
//         '/main': (BuildContext context) => new MainScreen(),
//         '/signin': (BuildContext context) => new LoginPage(),
//         '/scan': (BuildContext context) => new AccountScreen() ,
//       },
//       home: new MainScreen(),
//       //home: new Splash(),
//     );
//   }
// }

// // class Splash extends StatefulWidget {
// //   @override
// //   SplashState createState() => new SplashState();
// // }

// // class SplashState extends State<Splash> {
  
// //   Future checkFirstSeen() async {
// //     Navigator.of(context).pushReplacement(
// //           new MaterialPageRoute(builder: (context) => new IntroScreen()));
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     bool _seen = (prefs.getBool('seen') ?? false);

// //     if (_seen) {
// //       Navigator.of(context).pushReplacement(
// //           new MaterialPageRoute(builder: (context) => new Home()));
// //     } else {
// //       prefs.setBool('seen', true);
// //       Navigator.of(context).pushReplacement(
// //           new MaterialPageRoute(builder: (context) => new IntroScreen()));
// //     }
// //   }

// //   @override
// //   void initState() {
// //     print("in init");
// //     super.initState();
// //     new Timer(new Duration(milliseconds: 5), () {
// //       print("for check");
// //       checkFirstSeen();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     print("building");
// //     return new Scaffold(
// //       body: new Center(
// //         child: new Text('Loading...'),
// //       ),
// //     );
// //   }
// // }

// // class Home extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return new Scaffold(
// //       appBar: new AppBar(
// //         title: new Text('Hello'),
// //       ),
// //       body: new Center(
// //         child: new Text('This is the second page'),
// //       ),
// //     );
// //   }
// // }

// // class IntroScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return new Scaffold(
// //       body: new Center(
// //         child: new Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: <Widget>[
// //             new Text('This is the intro page'),
// //             new MaterialButton(
// //               child: new Text('Gogo Home Page'),
// //               onPressed: () {
// //                 Navigator.of(context).pushReplacement(
// //                     new MaterialPageRoute(builder: (context) => new Home()));
// //               },
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }