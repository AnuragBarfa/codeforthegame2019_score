// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../repository/upcoming_matches_repository.dart';
// import '../../models/upcoming_match.dart';
// import '../../models/upMatchTile.dart';
// import '../../models/leaderBoardTile.dart';
// import '../../models/leaderBoardRow.dart';
// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // listenForUpMatches();
//     fetchUpComing();
//     fetchLeaderboard();
//   } 
//   void fetchUpComing() async{
//     final response =
//         await http.get('https://cricapi.com/api/matches?apikey=FEOXAZzomMhoqW1tqDBttVccWfp2'); 
//     if (response.statusCode == 200) {
//        //If the call to the server was successful, parse the JSON
//       Map<String, dynamic> data=json.decode(response.body);
//       for (var i=0;i<data['matches'].length;i++){
//         UpMatche curMatch=UpMatche.fromJSON(data['matches'][i]);
//         setState(() =>  _UpMatches.add(curMatch));
//       }

//     } else {
//        //If that call was not successful, throw an error.
//       throw Exception('Failed to load post');
//     }
//   }
  
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFe4e9ed),
//       body: new DefaultTabController(
//         length: 3,
//         child: new Scaffold(
//           appBar: new AppBar(
//             title: new Text('Main'),
//             backgroundColor: Colors.blue,
//             actions: <Widget>[
//               IconButton(
//                 onPressed: () {},
//                 icon: Icon(Icons.search),
//               ),
//               IconButton(
//                 onPressed: () {},
//                 icon: Icon(Icons.shopping_cart),
//               ),
//             ],
//             bottom: new TabBar(
//               tabs: [
//                 new Tab(text: 'UPCOMINGS'),
//                 new Tab(text: 'LEADERBOARD'),
//               ],
//               indicatorColor: Colors.white,
//             ),
//           ),
//           body: new TabBarView(
//             children: [
//               new ListView.builder(
//                 itemCount: _UpMatches.length,
//                 itemBuilder: (context, index) => UpMatcheTile(_UpMatches[index]),
//               ),
              
//               new Container(
//                 padding: new EdgeInsets.only(top: 20.0),
//                 height: 44.0,
//                 child: new Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     new Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         new Text("LEADERBOARD",style: new TextStyle(fontSize: 30),)
//                       ],
//                     ),
//                     new Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         new Text("-- WORLD CUP 2019 --",style: new TextStyle(fontSize: 15,),)
//                       ],
//                     ),
//                     new SizedBox(height: 10.0,),
//                     new Container(
//                       padding: new EdgeInsets.only(left:8.0),
//                       child: new Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: <Widget>[
//                           new Expanded(
//                             flex: 2,
//                             child: new Text("Rank"),
//                           ),
//                           new Expanded(
//                             flex: 3,
//                             child: new Text("Team"),
//                           ),
//                           new Expanded(
//                             flex: 1,
//                             child: new Text("M"),
//                           ),
//                           new Expanded(
//                             flex: 1,
//                             child: new Text("W"),
//                           ),
//                           new Expanded(
//                             flex: 1,
//                             child: new Text("L"),
//                           ),
//                           new Expanded(
//                             flex: 1,
//                             child: new Text("PTS"),
//                           ),
//                           new Expanded(
//                             flex: 2,
//                             child:new Text("NRR") ,
//                           )
//                         ],
//                       ),
//                     ),    
//                     new Divider(),
//                     new Expanded(//use Expanded to wrap list view in case of error for unbound height
//                       child:new ListView.builder(
//                         itemCount: _LeaderBoardRows.length,
//                         itemBuilder: (context, index) => LeaderBoardTile(_LeaderBoardRows[index]),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           drawer: Drawer(
//         // Add a ListView to the drawer. This ensures the user can scroll
//         // through the options in the Drawer if there isn't enough vertical
//         // space to fit everything.
//         child: ListView(
//           // Important: Remove any padding from the ListView.
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             UserAccountsDrawerHeader(
//               accountName: new Text("Anurag Barfa"),
//               accountEmail: new Text("anuragbarfa64@gmail.com"),
//               currentAccountPicture: new CircleAvatar(
//                 backgroundImage: new AssetImage("assets/images/profile.jpg"),
//               ),
//               decoration: new BoxDecoration(
//                 image: new DecorationImage(
//                   image: new AssetImage("assets/images/drawer.jpg"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             // ListTile(
//             //   title: Text('MAIN'),
//             // ),
//             ListTile(
//               leading:Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/account');
//               },
//             ),
//             ListTile(
//               leading:Icon(Icons.fullscreen),
//               title: Text('Scan'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/scan');
//               },
//             ),
//             // ListTile(
//             //   leading: Icon(Icons.shopping_cart),
//             //   title: Text('Cart'),
//             //   onTap: () {
//             //     // Update the state of the app
//             //     // ...
//             //     // Then close the drawer
//             //     Navigator.pop(context);
//             //   },
//             // ),
//             // Divider(
//             //   height: 2.0,
//             // ),
//             // ListTile(
//             //   title: Text('USER'),
//             // ),
//             ListTile(
//               leading: Icon(Icons.account_circle),
//               title: Text('Profile'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/account');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.local_play),
//               title: Text('Claimed Coupans'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/account');
//               },
//             ),
//             // Divider(
//             //   height: 2.0,
//             // ),
//             // ListTile(
//             //   title: Text('EXTRAS'),
//             // ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.info),
//               title: Text('About Us'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/signin');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.power_settings_new),
//               title: Text('Logout'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/signin');
//               },
//             ),
            
//           ],
//         ),
//       ),
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   // Using custom color for FAB
//       //   backgroundColor: Color(0xFFd2527f),
//       //   // Add icon to FAB and override default color
//       //   child: Icon(
//       //     Icons.polymer,
//       //     color: Color(0xFF000000),
//       //   ),
//       //   onPressed: () {
//       //     // Navigate to the second screen using a named route
//       //     Navigator.pushNamed(context, '/signup');
//       //   },
//       // ),
//     );
//   }
// }
