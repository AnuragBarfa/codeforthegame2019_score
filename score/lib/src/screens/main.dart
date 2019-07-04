import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../repository/upcoming_matches_repository.dart';
import '../../models/upcoming_match.dart';
import '../../models/upMatchTile.dart';
import '../../models/inningTile.dart';
import '../../models/inning.dart';
import '../screens/setting.dart';
import '../screens/my_team.dart';
import '../screens/leaderboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
String key="mw23cr5x274anr3xx9g6yugj";
Map<String,String> teamName;
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String matchId;
  String overs;
  String score;
  String runRate;
  String currentInning;
  String tossWonBy;
  String battingTeam;
  String bowlingTeam;
  Set<int> index;
  List<UpMatche> _UpMatches = <UpMatche>[];
  Inning inning1;
  Inning inning2;
  @override
  void initState(){
    super.initState();
    // listenForUpMatches();
    //fetchLeaderboard();
    fetch2();
    
    // fetch("sr:match:17517265");
    overs="23.1/50";
    score="130/1";
    runRate="6.67";
    currentInning="1";
    tossWonBy="team1";
    battingTeam="team1";
    bowlingTeam="team2";
    teamName = <String, String>{};
    teamName["sr:competitor:142708"]="South Africa";
    teamName["sr:competitor:142690"]="Australia";
    teamName["sr:competitor:107205"]="England";
    teamName["sr:competitor:142702"]="New Zealand";
    teamName["sr:competitor:107203"]="India";
    teamName["sr:competitor:142704"]="Pakistan";
    teamName["sr:competitor:142710"]="Sri Lanka";
    teamName["sr:competitor:142692"]="Bangladesh";
    teamName["sr:competitor:142714"]="West Indies";
    teamName["sr:competitor:142688"]="Afghanistan";
    index=new Set();
  } 

  void listenForUpMatches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('fav_team'));
    
  }
  void fetch2() async{
    //fetching world cup schedule
    final response =
        await http.get('https://api.sportradar.com/cricket-t2/en/tournaments/sr:tournament:2474/schedule.json?api_key='+key); 
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
    DateTime now = new DateTime.now();
    String year=now.year.toString();
    String month=now.month.toString().length==1?"0"+now.month.toString():now.month.toString();
    String day=now.day.toString().length==1?"0"+now.day.toString():now.day.toString();
    String date=year+"-"+month+"-"+day;
    String liveMatchId="No";
    final response1 =
        await http.get('https://api.sportradar.com/cricket-t2/en/schedules/'+date+'/schedule.json?api_key='+key); 
    if (response1.statusCode == 200) {
      Map<String, dynamic> data=json.decode(response1.body);
      for(var i=0;i<data['sport_events'].length;i++){
        if(data['sport_events'][i]['season']['name']=="World Cup 2019"){
          liveMatchId=data['sport_events'][i]['id'];
        }
      }
    } else {
       //If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
    fetch(liveMatchId);
    // fetch(liveMatchId);
    // final response1 =
    //     await http.get('https://api.sportradar.com/cricket-t2/en/tournaments/sr:tournament:2474/schedule.json?api_key='+key);
    // Timer.periodic(Duration(seconds: 3), (timer){
    //   fetch("sr:match:17517265");
    // }); 
  }
  void fetch(String mId) async{
    final response =
        await http.get('https://api.sportradar.com/cricket-t2/en/matches/'+ mId +'/timeline/delta.json?api_key='+key); 
    if (response.statusCode == 200) {
       //If the call to the server was successful, parse the JSON
      Map<String, dynamic> data=json.decode(response.body);
      
      //Variable showing live score card
      score=data['sport_event_status']['display_score'].toString();
      overs=data['sport_event_status']['period_scores'][0]['display_overs'].toString()+"/"+data['sport_event_status']['period_scores'][0]['allotted_overs'].toString();
      runRate=data['sport_event_status']['run_rate'].toString();
      int inning=data['sport_event_status']['current_inning']-1;
      currentInning=data['sport_event_status']['current_inning'].toString();
      tossWonBy=teamName[data['sport_event_status']['toss_won_by']].toString();
      battingTeam=teamName[data['statistics']['innings'][inning]['batting_team']].toString();
      bowlingTeam=teamName[data['statistics']['innings'][inning]['bowling_team']].toString();
      print(battingTeam);
      print(bowlingTeam);
      //variables for innings
      for(var i=0;i<2;i++){
        String inning_number=data['statistics']['innings'][i]['number'].toString();
        String bowl_team=data['statistics']['innings'][i]['bowling_team'].toString();
        String bat_team=data['statistics']['innings'][i]['batting_team'].toString();
        List<Over> inn_overs= <Over>[];
        for(var j=0;j<data['statistics']['innings'][i]['overs'].length;j++){
          String no=data['statistics']['innings'][i]['overs'][j]['number'].toString();
          String run=data['statistics']['innings'][i]['overs'][j]['runs'].toString();
          String wick=data['statistics']['innings'][i]['overs'][j]['wickets'].toString();
          if(no=="null")no="0";
          if(run=="null")run="0";
          if(wick=="null")wick="0";
          Over curr_over=Over.fromData(no, run, wick);
          inn_overs.add(curr_over);
        }
        int batting_index=0;
        int bowling_index=1;
        if(data['statistics']['innings'][i]['teams'][1]['statistics']['bowling']==null){
          batting_index=1;
          bowling_index=0;
        }
        String over=data['statistics']['innings'][i]['teams'][bowling_index]['statistics']['bowling']['overs'].toString();
        String wick=data['statistics']['innings'][i]['teams'][bowling_index]['statistics']['bowling']['wickets'].toString();
        String maiden=data['statistics']['innings'][i]['teams'][bowling_index]['statistics']['bowling']['maidens'].toString();
        List<Bowler> bolwer=<Bowler>[];
        for(var j=0;j<data['statistics']['innings'][i]['teams'][bowling_index]['statistics']['bowling']['players'].length;j++){
          String name=data['statistics']['innings'][i]['teams'][bowling_index]['statistics']['bowling']['players'][j]['name'].toString();
          String runs=data['statistics']['innings'][i]['teams'][bowling_index]['statistics']['bowling']['players'][j]['statistics']['runs_conceded'].toString();
          String overs_bowled=data['statistics']['innings'][i]['teams'][bowling_index]['statistics']['bowling']['players'][j]['statistics']['overs_bowled'].toString();
          String wick=data['statistics']['innings'][i]['teams'][bowling_index]['statistics']['bowling']['players'][j]['statistics']['maidens'].toString();
          if(wick=="null")wick="0";
          if(runs=="null")runs="0";
          if(over=="null")over="0";
          Bowler bowl=Bowler.fromData(name, runs, overs_bowled, wick);
          bolwer.add(bowl);
        }
        Bowling bowling=Bowling.fromData(over, wick, maiden, bolwer);
        String run_scored=data['statistics']['innings'][i]['teams'][batting_index]['statistics']['batting']['runs'].toString();
        String run_rate=data['statistics']['innings'][i]['teams'][batting_index]['statistics']['batting']['run_rate'].toString();
        String balls_faced=data['statistics']['innings'][i]['teams'][batting_index]['statistics']['batting']['balls_faced'].toString();
        Batting batting=Batting.fromData(run_scored, run_rate, balls_faced);
        if(i==0){
          inning1=Inning.fromData(inning_number, bat_team, bowl_team, inn_overs, bowling, batting);
        }
        if(i==1){
          inning2=Inning.fromData(inning_number, bat_team, bowl_team, inn_overs, bowling, batting);
        }
      }
      print(inning1);
      print(inning2);
      setState(() {
        overs=overs;
        score=score;
        runRate=runRate;
        currentInning=currentInning;
        tossWonBy=tossWonBy;
        battingTeam=battingTeam;
        bowlingTeam=bowlingTeam;
        inning1=inning1;
        inning2=inning2;
      });
      // print(data['standings'][0]['groups'][0]['team_standings']);
      // LeaderBoardRow header=LeaderBoardRow.fromData("Team","Rank","M","W","D","L","PTS","NRR");
      // _LeaderBoardRows.add(header);
      // for(var i=0;i<data['standings'][0]['groups'][0]['team_standings'].length;i++){
      //   LeaderBoardRow currRow=LeaderBoardRow.fromJSON(data['standings'][0]['groups'][0]['team_standings'][i]);
      //   setState(() => _LeaderBoardRows.add(currRow));
      // }

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
        length: 2,
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
                new Tab(text: 'LIVE'),
                new Tab(text: 'SCHEDULE'),
              ],
              indicatorColor: Colors.white,
            ),
          ),
          body: new TabBarView(
            children: [
              // new Icon(Icons.access_alarm),
              new Container(
                child:(battingTeam!="team1")?new SingleChildScrollView(
                  child: new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: new BoxDecoration(
                        boxShadow:[
                          new BoxShadow(
                            color: Colors.black,
                            blurRadius: 3.0
                          )
                        ],
                        color: Color.fromRGBO(230, 230, 230, 1.0)
                      ),
                      margin: EdgeInsets.all(15.0),
                      child: new Row(
                        children: <Widget>[
                          new Container(
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new Text("Batting",style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                  new SizedBox(height: 10.0,),
                                  new CircleAvatar(
                                    backgroundImage: new AssetImage("assets/images/"+battingTeam.toLowerCase().replaceAll(' ','-')+".jpg"),
                                    backgroundColor: Colors.red,
                                    radius: 30.0,
                                  ),
                                  new SizedBox(height: 10.0,),
                                  new Text(battingTeam.toUpperCase(),style: new TextStyle(fontSize: 13.0),)
                                ],
                              )
                            ),
                            new Expanded(
                              child: new Container(
                                      // decoration: new BoxDecoration(border: Border.all()),
                                      padding: new EdgeInsets.all(8.0),
                                      child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Text("Inning: "+currentInning,style: new TextStyle(fontWeight: FontWeight.bold),),
                                          new Text("Score: "+score,style: new TextStyle(fontWeight: FontWeight.bold),),
                                          new Text("Overs: "+overs,style: new TextStyle(fontWeight: FontWeight.bold),),
                                          new Text("Run Rate: "+runRate,style: new TextStyle(fontWeight: FontWeight.bold),),
                                          new Text("*Toss Won By: "+tossWonBy,style: new TextStyle(fontSize: 10.0),),
                                        ],
                                      ),
                                    ),
                            ),
                            new Container(
                              child: new Column(
                                children: <Widget>[
                                  new Text("Bowling",style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                  new SizedBox(height: 10.0,),
                                  new CircleAvatar(
                                    backgroundImage: new AssetImage("assets/images/"+bowlingTeam.toLowerCase().replaceAll(' ','-')+".jpg"),
                                    backgroundColor: Colors.red,
                                    radius: 30.0,
                                  ),
                                  new SizedBox(height: 10.0,),
                                  new Text(bowlingTeam.toUpperCase(),style: new TextStyle(fontSize: 13.0),)
                                ],
                              )
                            ),
                        ],
                      ),
                    ),
                    new InkWell(
                      onTap :(){
                        if(index.contains(1)){
                          index.remove(1);
                        }
                        else{
                          index.add(1);
                        }
                        setState(() {
                          index=index;
                        });
                      } ,
                      child:new Heading("Inning 1")
                    ),
                    new Offstage(
                      offstage: !index.contains(1),
                      child: new InningTile(inning1),
                    ),
                    new InkWell(
                      onTap :(){
                        if(index.contains(2)){
                          index.remove(2);
                        }
                        else{
                          index.add(2);
                        }
                        setState(() {
                          index=index;
                        });
                      } ,
                      child:new Heading("Inning 2")
                    ),
                    new Offstage(
                      offstage: !index.contains(2),
                      child: new InningTile(inning2),
                    ),
                  ],
                ),
                ):new Center(
                  child: new SpinKitFadingCircle(
                    color: Colors.blue,
                    size: 50.0,
                  ),
                )
              ),
              new ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _UpMatches.length,
                itemBuilder: (context, index) => UpMatcheTile(_UpMatches[index]),
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
              accountName: new Text("Test Test"),
              accountEmail: new Text("test@gmail.com"),
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
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => 
                    new MyTeam(),
                );
                Navigator.of(context).push(route);
              },
            ),
            ListTile(
              leading:Icon(Icons.home),
              title: Text('Leaderboard'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => 
                    new Leaderboard(),
                );
                Navigator.of(context).push(route);
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
class Heading extends StatelessWidget{
  String header;
  Heading(String head){
    header=head;
  }
  @override
  Widget build(BuildContext context){
    return new Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
        color: Colors.blue,
        border: Border.all(),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(header,style: new TextStyle(fontSize: 20.0,color: Colors.white),),
          new Icon(Icons.arrow_forward_ios,color: Colors.white,)
        ],
      ),
    );
  }
}
