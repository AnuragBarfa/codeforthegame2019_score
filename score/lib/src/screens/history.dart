import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class History extends StatefulWidget {
  String matchId;
  History(String mId){
    matchId=mId;
  }
  @override
  _HistoryState createState() => _HistoryState(this.matchId);
}

class _HistoryState extends State<History> {
  String matchId;
  _HistoryState(String mId){
    matchId=mId;
  }
  @override
  void initState() {
    super.initState();
    fetch(this.matchId);
  }
  void fetch(String mId) async{
    final response =
        await http.get('https://api.sportradar.com/cricket-t2/en/matches/'+ mId +'/timeline.json?api_key=wggcfwq4abb33tg44sw33dtg'); 
    if (response.statusCode == 200) {
       //If the call to the server was successful, parse the JSON
      Map<String, dynamic> data=json.decode(response.body);
      print(data);
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
      print(data);
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
        child: new Text("${widget.matchId}"),
      ),
      backgroundColor: Color(0xFFe4e9ed),
    );
  }
}
