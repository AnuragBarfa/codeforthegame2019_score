import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/result.dart';
import '../screens/leaderboard.dart';

String key="mw23cr5x274anr3xx9g6yugj";
// Create a Form widget.
class MyTeam extends StatefulWidget {
  @override
  MyTeamState createState() => MyTeamState();
}

String teamValue="Chose Your Team";
// Create a corresponding State class.
// This class holds data related to the form.
class MyTeamState extends State<MyTeam> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  Set<int> index;
  Map<String,String> teamName;
  List<Result> _Result = <Result>[];
  List<Player > _Players = <Player>[];
  @override 
  void initState() {
    super.initState();
    index=new Set(); 
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
    loadTeamName();
    loadTeamResult();                                 
  }
  void loadTeamName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      teamValue=prefs.getString('fav_team');
    });
  }
  void loadTeamResult() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myTeam=prefs.getString('fav_team');
    // print(myTeam);
    if(myTeam!="Chose Your Team"&&teamName[myTeam]!=null){
      final response =
        await http.get('https://api.sportradar.com/cricket-t2/en/teams/'+ myTeam +'/results.json?api_key='+key); 
      if (response.statusCode == 200) {
        //If the call to the server was successful, parse the JSON
        Map<String, dynamic> data=json.decode(response.body);
        for(var i=0;i<data['results'].length;i++){
          String unique_id=data['results'][i]['sport_event']['id'];
          String date=data['results'][i]['sport_event']['scheduled'].toString().split('T')[0];
          String time=data['results'][i]['sport_event']['scheduled'];
          String team1=data['results'][i]['sport_event']['competitors'][0]['name'];
          String team2=data['results'][i]['sport_event']['competitors'][1]['name'];
          String type=data['results'][i]['sport_event']['season']['name'];
          String status=data['results'][i]['sport_event_status']['match_status'];
          String winner=teamName[data['results'][i]['sport_event_status']['winner_id']];
          String result=data['results'][i]['sport_event_status']['match_result'];
          if(winner==null)winner="Not declared";
          if(result==null)result="Not declared";
          Result currMatch=Result.fromData(unique_id,date,time,team1,team2,type,status,winner,result);
          setState(() =>  _Result.add(currMatch));
          
          // // print(data['results'][i]['sport_event_status']['period_scores'][0]['home_score']);
          // // print(data['results'][i]['sport_event_status']['period_scores'][0]['home_wickets']);
          // print(data['results'][i]['sport_event_status']['period_scores'][0]['type']+data['results'][i]['sport_event_status']['period_scores'][0]['number'].toString());
          // print(data['results'][i]['sport_event_status']['period_scores'][0]['display_overs']);
        }
      } else {
        //If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
      final response2 =
          await http.get('https://api.sportradar.com/cricket-t2/en/teams/'+ myTeam +'/profile.json?api_key='+key); 
      if (response2.statusCode == 200) {
        //If the call to the server was successful, parse the JSON
        Map<String, dynamic> data=json.decode(response2.body);
        for(var i=0;i<data['players'].length;i++){
          String unique_id=data['players'][i]['id'];
          String name=data['players'][i]['name'];
          String type=data['players'][i]['type'];
          Player currPlayer=Player.fromData(unique_id,name,type);
          setState(() =>  _Players.add(currPlayer));
        }
      } else {
        //If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        title: new Text("MyTeam"),
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context,false),
        )
      ),
      body: new Container(
        child: new Container(
          
          child: (teamValue!="Chose Your Team")?SingleChildScrollView(
            child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text((teamName[teamValue]==null)?"Your Team":"Your Team: "+teamName[teamValue],style: new TextStyle(fontSize: 20),),
              new SizedBox(height: 10.0,),
              new InkWell(
                onTap: (){
                    var route = new MaterialPageRoute(
                      builder: (BuildContext context) => 
                        new Leaderboard(),
                    );
                    Navigator.of(context).push(route);
                },
                child: new Text("See "+teamName[teamValue]+" on Leaderboard",style: new TextStyle(fontSize: 15.0,),),
              ), 
              new SizedBox(height: 10.0,),
              new InkWell(
                onTap :(){
                  if(index.contains(0)){
                    index.remove(0);
                  }
                  else{
                    index.add(0);
                  }
                  setState(() {
                    index=index;
                  });
                } ,
                child:new Heading("Results")
              ),
              
              new Offstage(
                offstage: !index.contains(0),
                child:new Container(
                  height: 400,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Expanded(//use Expanded to wrap list view in case of error for unbound height
                        child: new ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _Result.length,
                          itemBuilder: (context, index) => ResultTile(_Result[index]),
                        ),
                      ),
                    ],
                  ),
                )
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
                child:new Heading("Players")
              ),
              new Offstage(
                offstage: !index.contains(1),
                child:new Container(
                  height: 350,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Expanded(//use Expanded to wrap list view in case of error for unbound height
                        child: new ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _Players.length,
                          itemBuilder: (context, index) => PlayerTile(_Players[index]),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
          ):Container(
            child: new Text("Choose a Favorite team from settings to see its details"),
          ),
        ),
      ),
      backgroundColor: Color(0xFFe4e9ed),
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
class ResultTile extends StatelessWidget{
  Result _Result;
  ResultTile(Result _Res){
    _Result=_Res;
  }
  Widget build(BuildContext context){
    return new Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
        boxShadow:[
          new BoxShadow(
            color: Colors.black,
            blurRadius: 3.0
          )
        ],
        color: Colors.white,
      ),
      child:new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(_Result.type),
              new Text(_Result.date)
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Container(
                    child: new CircleAvatar(
                      backgroundImage: new AssetImage("assets/images/"+_Result.team_1.toLowerCase().replaceAll(' ','-')+".jpg"),
                      backgroundColor: Colors.red,
                      radius: 25.0,
                    ),
                  ),
                  new Text(_Result.team_1),
                ],
              ),
              new Column(
                children: <Widget>[
                  new Text("Vs"),
                ],
              ),
              new Column(
                children: <Widget>[
                  new Container(
                    child: new CircleAvatar(
                      backgroundImage: new AssetImage("assets/images/"+_Result.team_2.toLowerCase().replaceAll(' ','-')+".jpg"),
                      backgroundColor: Colors.red,
                      radius: 25.0,
                    ),
                  ),
                  new Text(_Result.team_2),
                ],
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text("Match Status: "+_Result.status),
            ],
          ),
          new Container(
            child: _Result.result!=null?new Row(
              children: <Widget>[
                new Text("Result: "+_Result.result)
              ],
            ):Container(height: 0,),
          )
        ],
      ),
    );
  }
}

class PlayerTile extends StatelessWidget{
  Player _Player;
  PlayerTile(Player _Play){
    _Player=_Play;
  }
  Widget build(BuildContext context){
    return new Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
        boxShadow:[
          new BoxShadow(
            color: Colors.black,
            blurRadius: 3.0
          )
        ],
        color: Colors.white,
      ),
      child:new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text("Name: "+_Player.name),
          new Text("Type: "+_Player.type)
         
        ],
      ),
    );
  }
}

class Player{
  final String unique_id;
  final String name;
  final String type;
  Player.fromData(String id,String name, String type):
    unique_id=id,
    name=name,
    type=type;
}
