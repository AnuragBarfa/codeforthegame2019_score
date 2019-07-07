import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../models/leaderBoardTile.dart';
import '../../models/leaderBoardRow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

String key="x9em98rz6n3qsk464wqrmmzy";
Map<String,String> teamName;
class Leaderboard extends StatefulWidget {  
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<LeaderBoardRow> _LeaderBoardRows = <LeaderBoardRow>[];
  String myTeam="Chose Your Team";
  @override
  void initState() {
    super.initState();
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
    fetch();
  }
  void fetch() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.myTeam=prefs.getString('fav_team');
    final response =
        await http.get('https://api.sportradar.com/cricket-t2/en/tournaments/sr:tournament:2474/standings.json?api_key='+key); 
    if (response.statusCode == 200) {
       //If the call to the server was successful, parse the JSON
      Map<String, dynamic> data=json.decode(response.body);
      // print(data['standings'][0]['groups'][0]['team_standings']);
      // LeaderBoardRow header=LeaderBoardRow.fromData("Team","Rank","M","W","D","L","PTS","NRR");
      // _LeaderBoardRows.add(header);
      for(var i=0;i<data['standings'][0]['groups'][0]['team_standings'].length;i++){
        LeaderBoardRow currRow=LeaderBoardRow.fromJSON(data['standings'][0]['groups'][0]['team_standings'][i]);
        setState(() {
           _LeaderBoardRows.add(currRow);
          myTeam=myTeam;
        });
      }

    } else {
       //If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        title: new Text("Leaderboard"),
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context,false),
        )
      ),
      body: new Center(
        child: new Container(
          padding: new EdgeInsets.only(top: 20.0),
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
              new Container(
                child: (_LeaderBoardRows!=null)?new Expanded(//use Expanded to wrap list view in case of error for unbound height
                  child:new ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _LeaderBoardRows.length,
                    itemBuilder: (context, index) => LeaderBoardTile(_LeaderBoardRows[index],teamName[this.myTeam]),
                  ),
                ):new SpinKitThreeBounce(
                  color: Colors.white,
                  size: 30.0,
                ),
              ), 
            ],
          ),
        )
      ),
      backgroundColor: Color(0xFFe4e9ed),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';

// class Leaderboard extends StatefulWidget {  
//   String matchId;
//   Leaderboard(String mId){
//     matchId=mId;
//   }
//   @override
//   _LeaderboardState createState() => _LeaderboardState(this.matchId);
// }

// class _LeaderboardState extends State<Leaderboard> {
//   String matchId;
//   String overs;
//   String score;
//   String runRate;
//   String currentInning;
//   String tossWonBy;
//   String battingTeam;
//   String bowlingTeam;
//   Map<String,String> teamName;
//   Set<int> index;
//   _LeaderboardState(String mId){
//     matchId=mId;
//   }
//   @override
//   void initState() {
//     super.initState();
//     overs="23.1/50";
//     score="130/1";
//     runRate="6.67";
//     currentInning="1";
//     tossWonBy="South Africa";
//     battingTeam="South Africa";
//     bowlingTeam="South Africa";
//     teamName = <String, String>{};
//     teamName["sr:competitor:142708"]="South Africa";
//     teamName["sr:competitor:142690"]="Australia";
//     teamName["sr:competitor:107205"]="England";
//     teamName["sr:competitor:142702"]="New Zealand";
//     teamName["sr:competitor:107203"]="India";
//     teamName["sr:competitor:142704"]="Pakistan";
//     teamName["sr:competitor:142710"]="Sri Lanka";
//     teamName["sr:competitor:142692"]="Bangladesh";
//     teamName["sr:competitor:142714"]="West Indies";
//     teamName["sr:competitor:142688"]="Afghanistan";
//     index=new Set();
//     // Timer.periodic(Duration(seconds: 3), (timer){
//     //   fetch(this.matchId);
//     // });
//     // fetch(this.matchId); 
//   }
//   void fetch(String mId) async{
//     final response =
//         await http.get('https://api.sportradar.com/cricket-t2/en/matches/'+ mId +'/timeline/delta.json?api_key=wggcfwq4abb33tg44sw33dtg'); 
//     if (response.statusCode == 200) {
//        //If the call to the server was successful, parse the JSON
//       Map<String, dynamic> data=json.decode(response.body);
//       // print(data);
//       overs=data['sport_event_status']['display_score'].toString();
//       score=data['sport_event_status']['period_scores'][0]['display_overs'].toString()+"/"+data['sport_event_status']['period_scores'][0]['allotted_overs'].toString();
//       runRate=data['sport_event_status']['run_rate'];
//       currentInning=data['sport_event_status']['current_inning'];
//       tossWonBy=teamName[data['sport_event_status']['toss_won_by']];
//       battingTeam=teamName[data['statistics']['innings']['currentInning']['batting_team']];
//       bowlingTeam=teamName[data['statistics']['innings']['currentInning']['bowling_team']];

//       setState(() {
//         overs=overs;
//         score=score;
//         runRate=runRate;
//         currentInning=currentInning;
//         tossWonBy=tossWonBy;
//         battingTeam=battingTeam;
//         bowlingTeam=bowlingTeam;
//       });
//       // print(data['standings'][0]['groups'][0]['team_standings']);
//       // LeaderBoardRow header=LeaderBoardRow.fromData("Team","Rank","M","W","D","L","PTS","NRR");
//       // _LeaderBoardRows.add(header);
//       // for(var i=0;i<data['standings'][0]['groups'][0]['team_standings'].length;i++){
//       //   LeaderBoardRow currRow=LeaderBoardRow.fromJSON(data['standings'][0]['groups'][0]['team_standings'][i]);
//       //   setState(() => _LeaderBoardRows.add(currRow));
//       // }

//     } else {
//        //If that call was not successful, throw an error.
//       throw Exception('Failed to load post');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     print(this.matchId);
//     return Scaffold(
//       appBar: new AppBar(
//         automaticallyImplyLeading: true,
//         title: new Text("Leaderboards Status"),
//         leading: IconButton(icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context,false),
//         )
//       ),
//       body: new Center(
//         child: new Container(
//           child: new Column(
//             children: <Widget>[
//               new Container(
//                 padding: EdgeInsets.all(5.0),
//                 decoration: new BoxDecoration(
//                   boxShadow:[
//                     new BoxShadow(
//                       color: Colors.black,
//                       blurRadius: 3.0
//                     )
//                   ],
//                   color: Color.fromRGBO(230, 230, 230, 1.0)
//                 ),
//                 margin: EdgeInsets.all(15.0),
//                 child: new Row(
//                   children: <Widget>[
//                     new Container(
//                         child: new Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: <Widget>[
//                             new Text("Batting",style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
//                             new SizedBox(height: 10.0,),
//                             new CircleAvatar(
//                               backgroundImage: new AssetImage("assets/images/"+battingTeam.toLowerCase().replaceAll(' ','-')+".jpg"),
//                               backgroundColor: Colors.red,
//                               radius: 30.0,
//                             ),
//                             new SizedBox(height: 10.0,),
//                             new Text(battingTeam.toUpperCase(),style: new TextStyle(fontSize: 13.0),)
//                           ],
//                         )
//                       ),
//                       new Expanded(
//                         child: new Container(
//                                 // decoration: new BoxDecoration(border: Border.all()),
//                                 padding: new EdgeInsets.all(8.0),
//                                 child: new Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: <Widget>[
//                                     new Text("Current Inning: "+currentInning,style: new TextStyle(fontWeight: FontWeight.bold),),
//                                     new Text("Score: "+score,style: new TextStyle(fontWeight: FontWeight.bold),),
//                                     new Text("Overs: "+overs,style: new TextStyle(fontWeight: FontWeight.bold),),
//                                     new Text("*Toss Won By: "+tossWonBy,style: new TextStyle(fontSize: 10.0),),
//                                   ],
//                                 ),
//                               ),
//                       ),
//                       new Container(
//                         child: new Column(
//                           children: <Widget>[
//                             new Text("Bowling",style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
//                             new SizedBox(height: 10.0,),
//                             new CircleAvatar(
//                               backgroundImage: new AssetImage("assets/images/"+bowlingTeam.toLowerCase().replaceAll(' ','-')+".jpg"),
//                               backgroundColor: Colors.red,
//                               radius: 30.0,
//                             ),
//                             new SizedBox(height: 10.0,),
//                             new Text(bowlingTeam.toUpperCase(),style: new TextStyle(fontSize: 13.0),)
//                           ],
//                         )
//                       ),
//                   ],
//                 ),
//               ),
//               new Row(
                
//               ),
//               new InkWell(
//                 onTap :(){
//                   if(index.contains(1)){
//                     index.remove(1);
//                   }
//                   else{
//                     index.add(1);
//                   }
//                   setState(() {
//                     index=index;
//                   });
//                 } ,
//                 child:new Heading("Inning 1")
//               ),
//               new Offstage(
//                 offstage: !index.contains(1),
//                 child: new Text("IN2data"),
//               ),
//               new InkWell(
//                 onTap :(){
//                   if(index.contains(2)){
//                     index.remove(2);
//                   }
//                   else{
//                     index.add(2);
//                   }
//                   setState(() {
//                     index=index;
//                   });
//                 } ,
//                 child:new Heading("Inning 2")
//               ),
//               new Offstage(
//                 offstage: !index.contains(2),
//                 child: new Text("IN2data"),
//               ),
//             ],
//           ),
//         ),
//       ),
//       backgroundColor: Color(0xFFe4e9ed),
//     );
//   }
// }
// // type-[sport_event][season][name]
// // time-[sport_event][scheduled]
// // team1-[sport_event][competitors][0][name]
// // team2-[sport_event][competitors][1][name]
// // venue-[sport_event][venue]
// // weather=[sport_event_conditions][weather_info][weather_conditions]
// // toss_won_by=[sport_event_status][run_rate]

// class Heading extends StatelessWidget{
//   String header;
//   Heading(String head){
//     header=head;
//   }
//   @override
//   Widget build(BuildContext context){
//     return new Container(
//       margin: EdgeInsets.all(10.0),
//       padding: EdgeInsets.all(10.0),
//       decoration: new BoxDecoration(
//         color: Colors.blue,
//         border: Border.all(),
//       ),
//       child: new Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           new Text(header,style: new TextStyle(fontSize: 20.0,color: Colors.white),),
//           new Icon(Icons.arrow_forward_ios,color: Colors.white,)
//         ],
//       ),
//     );
//   }
// }