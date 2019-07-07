import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/inning.dart';
import '../../models/inningTile.dart';
import '../../models/matchDetails.dart';
Map<String,String> teamName;
String key="mw23cr5x274anr3xx9g6yugj";
class Detail extends StatefulWidget {
  String matchId;
  Detail(String mId){
    matchId=mId;
  }
  @override
  _DetailState createState() => _DetailState(this.matchId);
}

class _DetailState extends State<Detail> {
  String matchId;
  Set<int> index;
  Inning inning1;
  Inning inning2;
  MatchDetails matchDetails;
  _DetailState(String mId){
    matchId=mId;
  }
  @override
  void initState() {
    super.initState();
    fetch(this.matchId);
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
  void fetch(String mId) async{
    final response =
        await http.get('https://api.sportradar.com/cricket-t2/en/matches/'+ mId +'/timeline/delta.json?api_key='+key); 
    if (response.statusCode == 200) {
       //If the call to the server was successful, parse the JSON
      Map<String, dynamic> data=json.decode(response.body);
      //variables for match details
      var date=data['sport_event']['scheduled'].toString().split('T')[0];
      var team1=data['sport_event']['competitors'][0]['name'];
      var team2=data['sport_event']['competitors'][1]['name'];
      var status=data['sport_event_status']['status'];
      var result=data['sport_event_status']['match_result'];
      var venue_name=data['sport_event']['venue']['name'];
      var venue_city=data['sport_event']['venue']['city_name'];
      var venue_country=data['sport_event']['venue']['country_name'];
      Venue venue=Venue.fromData(venue_name, venue_city, venue_country);
      print(venue.name);
      matchDetails=MatchDetails.fromData(date, team1, team2, venue, status,result);
      //variables for innings
      inning1=null;
      inning2=null;
      int inningIndex=2;
      if(data['statistics']==null)inningIndex=0;
      for(var i=0;i<inningIndex;i++){
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
        matchDetails=matchDetails;
        inning1=inning1;
        inning2=inning2;
      });
    } else {
       //If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
  // void fetch(String mId) async{
  //   final response =
  //       await http.get('https://api.sportradar.com/cricket-t2/en/matches/'+ mId +'/timeline/delta.json?api_key=wggcfwq4abb33tg44sw33dtg'); 
  //   if (response.statusCode == 200) {
  //      //If the call to the server was successful, parse the JSON
  //     Map<String, dynamic> data=json.decode(response.body);

  //     // print(data);
  //     // print(data['standings'][0]['groups'][0]['team_standings']);
  //     // LeaderBoardRow header=LeaderBoardRow.fromData("Team","Rank","M","W","D","L","PTS","NRR");
  //     // _LeaderBoardRows.add(header);
  //     // for(var i=0;i<data['standings'][0]['groups'][0]['team_standings'].length;i++){
  //     //   LeaderBoardRow currRow=LeaderBoardRow.fromJSON(data['standings'][0]['groups'][0]['team_standings'][i]);
  //     //   setState(() => _LeaderBoardRows.add(currRow));
  //     // }
  //   } else {
  //      //If that call was not successful, throw an error.
  //     throw Exception('Failed to load post');
  //   }
  //   final response1 =
  //       await http.get('https://api.sportradar.com/cricket-t2/en/matches/'+ mId +'/probabilities.json?api_key=wggcfwq4abb33tg44sw33dtg'); 
  //   if (response1.statusCode == 200) {
  //      //If the call to the server was successful, parse the JSON
  //     Map<String, dynamic> data=json.decode(response1.body);
  //     // print(data);
  //     // print(data['standings'][0]['groups'][0]['team_standings']);
  //     // LeaderBoardRow header=LeaderBoardRow.fromData("Team","Rank","M","W","D","L","PTS","NRR");
  //     // _LeaderBoardRows.add(header);
  //     // for(var i=0;i<data['standings'][0]['groups'][0]['team_standings'].length;i++){
  //     //   LeaderBoardRow currRow=LeaderBoardRow.fromJSON(data['standings'][0]['groups'][0]['team_standings'][i]);
  //     //   setState(() => _LeaderBoardRows.add(currRow));
  //     // }

  //   } else {
  //      //If that call was not successful, throw an error.
  //     throw Exception('Failed to load post');
  //   }

  // }
  @override
  Widget build(BuildContext context) {
    print(this.matchId);
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        title: new Text("Match Details"),
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context,false),
        )
      ),
      body: new Container(
          child: new SingleChildScrollView(
            child: Column( 
              children: <Widget>[
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
                  child:new Heading("Match Details")
                ),
                new Offstage(
                  offstage: !index.contains(0),
                  child: new MatchDetailsTile(matchDetails),
                ),
                new Container(
                  child: (matchDetails!=null&&matchDetails.status!="not_started")?new Column(
                    children: <Widget>[
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
                  ):new Container(height: 0,),
                ),
              ],
            ),
          )
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
class MatchDetailsTile extends StatelessWidget{
  MatchDetails matchDetails;
  MatchDetailsTile(MatchDetails matchDetail){
    matchDetails=matchDetail;
  }
  @override
  Widget build(BuildContext context){
    return new Container(
      child: matchDetails!=null?new Container(
        child: new Column(
          children: <Widget>[
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Text(matchDetails.team1,style: new TextStyle(fontWeight: FontWeight.bold),),
                  new Text("Vs"),
                  new Text(matchDetails.team2,style: new TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
            ),

            new SizedBox(height: 10,),
            // new Row(
            //   children: <Widget>[
            //     new Text("Status: "+matchDetails.status)
            //   ],
            // ),
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  (matchDetails.status=="not_started")?new Text("Match Not Started Yet"):new Container(
                    child: (matchDetails.status=="cancelled")?new Text("Match Cancelled"):new Text("Result: "+matchDetails.result,style: new TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            new SizedBox(height: 10,),
            new Container(
              child: new Column(
                children: <Widget>[
                  new Text("Venue",style: new TextStyle(fontWeight: FontWeight.bold),),
                  new Text("Place: "+matchDetails.venue.name),
                  new Text("City: "+matchDetails.venue.city),
                  new Text("Country: "+matchDetails.venue.country),
                ],
              ),
            )
          ],
        )
      ):new Container(height: 0,),
    );
  }
}