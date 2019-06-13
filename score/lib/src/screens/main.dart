import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../repository/upcoming_matches_repository.dart';
import '../../models/upcoming_match.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<UpMatche> _UpMatches = <UpMatche>[];

  @override
  void initState() {
    super.initState();
    // listenForUpMatches();
    fetch();
  } 

  void listenForUpMatches() async {
    final Stream<UpMatche> stream = await getUpMatches();
    stream.listen((UpMatche upmatch) =>
      setState(() =>  _UpMatches.add(upmatch))
    );
  }
  void fetch() async{
    final response =
        await http.get('https://cricapi.com/api/matches?apikey=FEOXAZzomMhoqW1tqDBttVccWfp2'); 
    if (response.statusCode == 200) {
       //If the call to the server was successful, parse the JSON
      Map<String, dynamic> data=json.decode(response.body);
      print(data);
      for (var i=0;i<2;i++){
        print(data['matches'][i]);
        UpMatche curMatch=UpMatche.fromJSON(data['matches'][i]);
        setState(() =>  _UpMatches.add(curMatch));
      }

    } else {
       //If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe4e9ed),
      body: new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text('Main'),
            backgroundColor: Colors.blue,
            actions: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.shopping_cart),
              ),
            ],
            bottom: new TabBar(
              tabs: [
                new Tab(text: 'FEATURED'),
                new Tab(text: 'DEALS'),
                new Tab(text: 'CATEGORY'),
              ],
              indicatorColor: Colors.white,
            ),
          ),
          body: new TabBarView(
            children: [
              new ListView.builder(
                itemCount: _UpMatches.length,
                itemBuilder: (context, index) => UpMatcheTile(_UpMatches[index]),
              ),
              new Icon(
                Icons.directions_transit,
                size: 50.0,
              ),
              new Icon(
                Icons.directions_bike,
                size: 50.0,
              ),
            ],
          ),
          drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: new Text("Anurag Barfa"),
              accountEmail: new Text("anuragbarfa64@gmail.com"),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new AssetImage("assets/images/profile.jpg"),
              ),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/images/drawer.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // ListTile(
            //   title: Text('MAIN'),
            // ),
            ListTile(
              leading:Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/account');
              },
            ),
            ListTile(
              leading:Icon(Icons.fullscreen),
              title: Text('Scan'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/scan');
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.shopping_cart),
            //   title: Text('Cart'),
            //   onTap: () {
            //     // Update the state of the app
            //     // ...
            //     // Then close the drawer
            //     Navigator.pop(context);
            //   },
            // ),
            // Divider(
            //   height: 2.0,
            // ),
            // ListTile(
            //   title: Text('USER'),
            // ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/account');
              },
            ),
            ListTile(
              leading: Icon(Icons.local_play),
              title: Text('Claimed Coupans'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/account');
              },
            ),
            // Divider(
            //   height: 2.0,
            // ),
            // ListTile(
            //   title: Text('EXTRAS'),
            // ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/signin');
              },
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Logout'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/signin');
              },
            ),
            
          ],
        ),
      ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   // Using custom color for FAB
      //   backgroundColor: Color(0xFFd2527f),
      //   // Add icon to FAB and override default color
      //   child: Icon(
      //     Icons.polymer,
      //     color: Color(0xFF000000),
      //   ),
      //   onPressed: () {
      //     // Navigate to the second screen using a named route
      //     Navigator.pushNamed(context, '/signup');
      //   },
      // ),
    );
  }
}
class UpMatcheTile extends StatelessWidget {
  final UpMatche _UpMatche;
  UpMatcheTile(this._UpMatche);
  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Container(
        margin: new EdgeInsets.all(10.0),
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(_UpMatche.dateTimeGMT.split('T')[0])
                ],
              ),
              new Container(
                margin: new EdgeInsets.only(top: 8.0),
                padding: new EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.lightBlue,
                      width:3.0
                    )
                  ),
                  color: Color.fromRGBO(230, 230, 230, 1.0)
                ),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      child: new CircleAvatar(
                        backgroundImage: new AssetImage("assets/images/profile.jpg"),
                        backgroundColor: Colors.red,
                        radius: 30.0,
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                              // decoration: new BoxDecoration(border: Border.all()),
                              padding: new EdgeInsets.all(8.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  new Container(
                                    padding: new EdgeInsets.only(left: 8.0,right: 8.0),
                                    color: new Color.fromRGBO(217, 217, 217, 1.0),
                                    child: new Text(_UpMatche.type),
                                  ),
                                  new SizedBox(height: 8.0),
                                  new Text(_UpMatche.team_1.toUpperCase()),
                                  new Text(" vs "),
                                  new Text(_UpMatche.team_2.toUpperCase()),
                                  new Divider(),
                                  new Text(_UpMatche.dateTimeGMT.split('T')[1].split('Z')[0])
                                ],
                              ),
                            ),
                    ),
                    new Container(
                      child: new CircleAvatar(
                        backgroundImage: new AssetImage("assets/images/profile.jpg"),
                        backgroundColor: Colors.red,
                        radius: 30.0,
                      ),
                    )
                  ],
                ),                            
              ),
            ],
          )
        ),
      ),
      // ListTile(
      //   title: Text(_UpMatche.team_1),
      //   subtitle: Text(_UpMatche.team_2),
      // ),
    ],
  );
}