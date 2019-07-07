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
import '../screens/fun.dart';
import '../../models/liveMatch.dart';
import '../../models/liveMatchTile.dart';
String key="mw23cr5x274anr3xx9g6yugj";
Map<String,String> teamName;
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String matchId;
  String status;
  String overs;
  String score;
  String runRate;
  String currentInning;
  String tossWonBy;
  String battingTeam;
  String bowlingTeam;
  Set<int> index;
  bool areMatchs;
  List<UpMatche> _UpMatches = <UpMatche>[];
  Inning inning1;
  Inning inning2;
  List<LiveMatch> _LiveMatchs=<LiveMatch>[];
  @override
  void initState(){
    super.initState();
    fetch2();
    status="fetching";
    areMatchs=false;
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
      print(data);
      for(var i=0;i<data['sport_events'].length;i++){
        var unique_id=data['sport_events'][i]['id'];
        var date=data['sport_events'][i]['scheduled'].toString().split('T')[0];
        var team1=data['sport_events'][i]['competitors'][0]['name'];
        var team2=data['sport_events'][i]['competitors'][1]['name'];
        var status=data['sport_events'][i]['status'];
        var time=data['sport_events'][i]['scheduled'].toString().split('T')[1].split('+')[0];
        var type=data['sport_events'][i]['tournament']['type'].toString().toUpperCase();
        UpMatche currMatch=UpMatche.fromData(unique_id,date,time,team1,team2,type,status);
        setState(() =>  _UpMatches.add(currMatch));
      }
    } else {
       //If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
    LiveMatch liveMatch=LiveMatch.fromData("hide", status, overs, score, runRate, currentInning, tossWonBy, battingTeam, bowlingTeam, index, inning1, inning2);
    _LiveMatchs.add(liveMatch);
    _LiveMatchs.add(liveMatch);
    _LiveMatchs.add(liveMatch);
    _LiveMatchs.add(liveMatch);
    fetch();
    // final response1 =
    //     await http.get('https://api.sportradar.com/cricket-t2/en/tournaments/sr:tournament:2474/schedule.json?api_key='+key);
    // Timer.periodic(Duration(seconds: 30), (timer){
    //   fetch();
    // }); 
  }
  void fetch() async{
    DateTime now = new DateTime.now();
    String year=now.year.toString();
    String month=now.month.toString().length==1?"0"+now.month.toString():now.month.toString();
    String day=now.day.toString().length==1?"0"+now.day.toString():now.day.toString();
    String date=year+"-"+month+"-"+day;
    String liveMatchId="No";
    // date="2019-07-06";
    final response1 =
        await http.get('https://api.sportradar.com/cricket-t2/en/schedules/'+date+'/schedule.json?api_key='+key); 
    if (response1.statusCode == 200) {
      Map<String, dynamic> data1=json.decode(response1.body);
      // print(data);
      if(data1['sport_events'].length!=0)areMatchs=true;
      for(var i1=0;i1<data1['sport_events'].length;i1++){
        if(data1['sport_events'][i1]['season']['name']=="World Cup 2019"){
          String mId=data1['sport_events'][i1]['id'];
          print(mId);
          final response =
          await http.get('https://api.sportradar.com/cricket-t2/en/matches/'+ mId +'/timeline/delta.json?api_key='+key); 
          if (response.statusCode == 200) {
            //If the call to the server was successful, parse the JSON
            Map<String, dynamic> data=json.decode(response.body);
            print(i1);
            LiveMatch liveMatch1=LiveMatch.fromData(mId, status, overs, score, runRate, currentInning, tossWonBy, battingTeam, bowlingTeam, index, inning1, inning2);

            //Variable showing live score card
            status=data['sport_event_status']['status'];

            liveMatch1.status=status;
            print("main"+liveMatch1.matchId+liveMatch1.status);
            if(status=="not_started"){
              liveMatch1.battingTeam=data['sport_event']['competitors'][0]['name'].toString();
              liveMatch1.bowlingTeam=data['sport_event']['competitors'][1]['name'].toString();
            }
            else if(status=="closed"){
              liveMatch1.battingTeam=data['sport_event']['competitors'][0]['name'].toString();
              liveMatch1.bowlingTeam=data['sport_event']['competitors'][1]['name'].toString();
              liveMatch1.tossWonBy=data['sport_event_status']['match_result'];
            }
            else{
              int inning=data['sport_event_status']['current_inning']-1;
              liveMatch1.score=data['sport_event_status']['display_score'].toString();
              liveMatch1.overs=data['sport_event_status']['period_scores'][inning]['display_overs'].toString()+"/"+data['sport_event_status']['period_scores'][inning]['allotted_overs'].toString();
              liveMatch1.runRate=data['sport_event_status']['run_rate'].toString();
              liveMatch1.currentInning=data['sport_event_status']['current_inning'].toString();
              liveMatch1.tossWonBy=teamName[data['sport_event_status']['toss_won_by']].toString();
              liveMatch1.battingTeam=teamName[data['statistics']['innings'][inning]['batting_team']].toString();
              liveMatch1.bowlingTeam=teamName[data['statistics']['innings'][inning]['bowling_team']].toString();
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
                liveMatch1.inning1=inning1;
                liveMatch1.inning2=inning2;
              }
            }
            
          setState(() {
            print("chanign"+liveMatch1.status);
            _LiveMatchs[i1]=liveMatch1;
          });
          // Future<LiveMatch> liveMatch=fetch(liveMatchId);
          // LiveMatch liveMatch=LiveMatch.fromData(liveMatchId, status, overs, score, runRate, currentInning, tossWonBy, battingTeam, bowlingTeam, index, inning1, inning2);
          // setState(() =>  _LiveMatchs.add(liveMatch));
          // print(liveMatchId);
          // print(i);
          // fetch(liveMatchId,i);
        }
      }
    } 
    }else {
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
            title: new Text('Score'),
            backgroundColor: Colors.blue,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  var route = new MaterialPageRoute(
                  builder: (BuildContext context) => 
                      new FunPage(),
                  );
                  Navigator.of(context).push(route);
                },
                icon: Icon(Icons.question_answer),
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.shopping_cart),
              // ),
            ],
            bottom: new TabBar(
              tabs: [
                new Tab(text: 'TODAYS MATCHES'),
                new Tab(text: 'SCHEDULE'),
              ],
              indicatorColor: Colors.white,
            ),
          ),
          body: new TabBarView(
            children: [
              new Container(
                child: (_LiveMatchs.length!=0)?new Container(
                  child: (areMatchs)?new ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _LiveMatchs.length,
                    itemBuilder: (context, index) => LiveMatchTile(_LiveMatchs[index]),
                  ):new Center(
                    child: new Text("No Live Matches Today"),
                  ),
                ):new Center(
                  child: new SpinKitFadingCircle(
                    color: Colors.blue,
                    size:50
                  )
                ),
              ),
              // new Icon(Icons.access_alarm),
              new Container(
                child: (_UpMatches.length!=0)?new ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _UpMatches.length,
                  itemBuilder: (context, index) => UpMatcheTile(_UpMatches[index]),
                ):new Center(
                  child: new SpinKitFadingCircle(
                    color: Colors.blue,
                    size: 50.0,
                  ),
                ),
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
            // ListTile(
            //   leading: Icon(Icons.info),
            //   title: Text('About Us'),
            //   onTap: () {
            //     // Update the state of the app
            //     // ...
            //     // Then close the drawer
            //     Navigator.pop(context);
            //   },
            // ),
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

