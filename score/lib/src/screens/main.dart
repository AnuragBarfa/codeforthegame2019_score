import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../repository/upcoming_matches_repository.dart';
import '../../models/upcoming_match.dart';
import '../../models/upMatchTile.dart';
import '../../models/leaderBoardTile.dart';
import '../../models/leaderBoardRow.dart';
import '../screens/setting.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<UpMatche> _UpMatches = <UpMatche>[];
  List<LeaderBoardRow> _LeaderBoardRows = <LeaderBoardRow>[];

  @override
  void initState() {
    super.initState();
    // listenForUpMatches();
    //fetchLeaderboard();
    // fetch();
  } 

  void listenForUpMatches() async {
    final Stream<UpMatche> stream = await getUpMatches();
    stream.listen((UpMatche upmatch) =>
      setState(() =>  _UpMatches.add(upmatch))
    );
  }
  // void fetchUpComing() async{
  //   final response =
  //       await http.get('https://cricapi.com/api/matches?apikey=FEOXAZzomMhoqW1tqDBttVccWfp2'); 
  //   if (response.statusCode == 200) {
  //      //If the call to the server was successful, parse the JSON
  //     Map<String, dynamic> data=json.decode(response.body);
  //     for (var i=0;i<data['matches'].length;i++){
  //       UpMatche curMatch=UpMatche.fromJSON(data['matches'][i]);
  //       setState(() =>  _UpMatches.add(curMatch));
  //     }

  //   } else {
  //      //If that call was not successful, throw an error.
  //     throw Exception('Failed to load post');
  //   }

  // }
  void fetch() async{
    //fetching leaaderboard
    final response1 =
        await http.get('https://api.sportradar.com/cricket-t2/en/tournaments/sr:tournament:2474/standings.json?api_key=wggcfwq4abb33tg44sw33dtg'); 
    if (response1.statusCode == 200) {
       //If the call to the server was successful, parse the JSON
      Map<String, dynamic> data=json.decode(response1.body);
      // print(data['standings'][0]['groups'][0]['team_standings']);
      // LeaderBoardRow header=LeaderBoardRow.fromData("Team","Rank","M","W","D","L","PTS","NRR");
      // _LeaderBoardRows.add(header);
      for(var i=0;i<data['standings'][0]['groups'][0]['team_standings'].length;i++){
        LeaderBoardRow currRow=LeaderBoardRow.fromJSON(data['standings'][0]['groups'][0]['team_standings'][i]);
        setState(() => _LeaderBoardRows.add(currRow));
      }

    } else {
       //If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
    //fetching world cup schedule
    final response =
        await http.get('https://api.sportradar.com/cricket-t2/en/tournaments/sr:tournament:2474/schedule.json?api_key=wggcfwq4abb33tg44sw33dtg'); 
    if (response.statusCode == 200) {
      Map<String, dynamic> data=json.decode(response.body);
      // print(data['sport_events']);
      for(var i=0;i<data['sport_events'].length;i++){
        var unique_id=data['sport_events'][i]['id'];
        var date=data['sport_events'][i]['scheduled'].toString().split('T')[0];
        var team1=data['sport_events'][i]['competitors'][0]['name'];
        var team2=data['sport_events'][i]['competitors'][1]['name'];
        var status=data['sport_events'][i]['status'];
        var time=data['sport_events'][i]['scheduled'].toString().split('T')[1].split('+')[0];
        var type=data['sport_events'][i]['tournament']['type'].toString().toUpperCase();
        // (String id, String date, String time, String team1, String team2, String type, String status):
        UpMatche currMatch=UpMatche.fromData(unique_id,date,time,team1,team2,type,status);
        setState(() =>  _UpMatches.add(currMatch));
      }
    } else {
       //If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
  void fetchLeaderboard() async{
    final response =
        await http.get('https://api.sportradar.com/cricket-t2/en/tournaments/sr:tournament:2474/standings.json?api_key=wggcfwq4abb33tg44sw33dtg'); 
    if (response.statusCode == 200) {
       //If the call to the server was successful, parse the JSON
      Map<String, dynamic> data=json.decode(response.body);
      // print(data['standings'][0]['groups'][0]['team_standings']);
      // LeaderBoardRow header=LeaderBoardRow.fromData("Team","Rank","M","W","D","L","PTS","NRR");
      // _LeaderBoardRows.add(header);
      for(var i=0;i<data['standings'][0]['groups'][0]['team_standings'].length;i++){
        LeaderBoardRow currRow=LeaderBoardRow.fromJSON(data['standings'][0]['groups'][0]['team_standings'][i]);
        setState(() => _LeaderBoardRows.add(currRow));
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
            // actions: <Widget>[
            //   IconButton(
            //     onPressed: () {},
            //     icon: Icon(Icons.search),
            //   ),
            //   IconButton(
            //     onPressed: () {},
            //     icon: Icon(Icons.shopping_cart),
            //   ),
            // ],
            bottom: new TabBar(
              tabs: [
                new Tab(text: 'SCHEDULE'),
                new Tab(text: 'LEADERBOARD'),
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
              // new Icon(Icons.access_alarm),
              new Container(
                padding: new EdgeInsets.only(top: 20.0),
                height: 44.0,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text("LEADERBOARD",style: new TextStyle(fontSize: 30),)
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text("-- WORLD CUP 2019 --",style: new TextStyle(fontSize: 15,),)
                      ],
                    ),
                    new SizedBox(height: 10.0,),
                    new Container(
                      padding: new EdgeInsets.only(left:8.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Expanded(
                            flex: 2,
                            child: new Text("Rank"),
                          ),
                          new Expanded(
                            flex: 3,
                            child: new Text("Team"),
                          ),
                          new Expanded(
                            flex: 1,
                            child: new Text("M"),
                          ),
                          new Expanded(
                            flex: 1,
                            child: new Text("W"),
                          ),
                          new Expanded(
                            flex: 1,
                            child: new Text("L"),
                          ),
                          new Expanded(
                            flex: 1,
                            child: new Text("PTS"),
                          ),
                          new Expanded(
                            flex: 2,
                            child:new Text("NRR") ,
                          )
                        ],
                      ),
                    ),    
                    new Divider(),
                    new Expanded(//use Expanded to wrap list view in case of error for unbound height
                      child:new ListView.builder(
                        itemCount: _LeaderBoardRows.length,
                        itemBuilder: (context, index) => LeaderBoardTile(_LeaderBoardRows[index]),
                      ),
                    ),
                  ],
                ),
              )
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
            ListTile(
              leading:Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:Icon(Icons.home),
              title: Text('My Team'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/account');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => 
                    new Setting(),
                );
                Navigator.of(context).push(route);
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
              },
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }
}
