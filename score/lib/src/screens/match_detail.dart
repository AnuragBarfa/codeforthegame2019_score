import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  _DetailState(String mId){
    matchId=mId;
  }
  @override
  void initState() {
    super.initState();
    fetch(this.matchId);
    index=new Set();
  }
  void fetch(String mId) async{
    final response =
        await http.get('https://api.sportradar.com/cricket-t2/en/matches/'+ mId +'/timeline.json?api_key=wggcfwq4abb33tg44sw33dtg'); 
    if (response.statusCode == 200) {
       //If the call to the server was successful, parse the JSON
      Map<String, dynamic> data=json.decode(response.body);
      // print(data);
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
    final response1 =
        await http.get('https://api.sportradar.com/cricket-t2/en/matches/'+ mId +'/probabilities.json?api_key=wggcfwq4abb33tg44sw33dtg'); 
    if (response1.statusCode == 200) {
       //If the call to the server was successful, parse the JSON
      Map<String, dynamic> data=json.decode(response1.body);
      // print(data);
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
    print(this.matchId);
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        title: new Text("Match Details"),
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context,false),
        )
      ),
      body: new Center(
        child: new Container(
          margin: new EdgeInsets.only(top:20.0),
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
                child: new Text("IN1data"),
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
                child:new Heading("Match Results")
              ),
              new Offstage(
                offstage: !index.contains(1),
                child: new Text("IN2data"),
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
                child:new Heading("Match Conditions")
              ),
              new Offstage(
                offstage: !index.contains(2),
                child: new Text("IN3data"),
              ),
              new InkWell(
                onTap :(){
                  if(index.contains(3)){
                    index.remove(3);
                  }
                  else{
                    index.add(3);
                  }
                  setState(() {
                    index=index;
                  });
                } ,
                child:new Heading("Match Notes")
              ),
              new Offstage(
                offstage: !index.contains(3),
                child: new Text("IN4data"),
              ),

            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFe4e9ed),
    );
  }
}
// type-[sport_event][season][name]
// time-[sport_event][scheduled]
// team1-[sport_event][competitors][0][name]
// team2-[sport_event][competitors][1][name]
// venue-[sport_event][venue]
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