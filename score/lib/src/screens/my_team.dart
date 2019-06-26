import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/result.dart';
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
  @override 
  void initState() {
    super.initState();
    loadTeamName();
    loadTeamResult();
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
    final response =
        await http.get('https://api.sportradar.com/cricket-t2/en/teams/'+ myTeam +'/results.json?api_key='+key); 
    if (response.statusCode == 200) {
       //If the call to the server was successful, parse the JSON
      Map<String, dynamic> data=json.decode(response.body);
      print(data);
      for(var i=0;i<data['results'].length;i++){
        String unique_id=data['results'][i]['sport_event']['id'];
        String date=data['results'][i]['sport_event']['scheduled'];
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
        // print(data['results'][i]['sport_event']['season']['name']);
        // print(data['results'][i]['sport_event']['competitors'][0]['name']);
        // print(data['results'][i]['sport_event']['venue']['name']);
        // print(data['results'][i]['sport_event']['venue']['city_name']);
        // print(data['results'][i]['sport_event']['venue']['country_name']);
        // print(data['results'][i]['sport_event_status']['match_status']);
        // if(data['results'][i]['sport_event_status']['match_status']=='cancelled'){
        //   continue;
        // }
        // // print(data['results'][i]['sport_event_status']['period_scores'][0]['home_score']);
        // // print(data['results'][i]['sport_event_status']['period_scores'][0]['home_wickets']);
        // print(data['results'][i]['sport_event_status']['period_scores'][0]['type']+data['results'][i]['sport_event_status']['period_scores'][0]['number'].toString());
        // print(data['results'][i]['sport_event_status']['period_scores'][0]['display_overs']);
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
        title: new Text("MyTeam"),
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context,false),
        )
      ),
      body: new Center(
        child: new Container(
          padding: EdgeInsets.all(10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text((teamName[teamValue]==null)?"Your Team":teamName[teamValue]),
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
                child:new Column(
                  children: <Widget>[
                    new Expanded(//use Expanded to wrap list view in case of error for unbound height
                      child: new ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: _Result.length,
                        itemBuilder: (context, index) => ResultTile(_Result[index]),
                      ),
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
                child:new Heading("Players")
              ),
              new Offstage(
                offstage: !index.contains(1),
                child: new Text("IN2data"),
              ),
            ],
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
  ResultTile(Result _Result){
    _Result=_Result;
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
          new Text(_Result.team_1,style: new TextStyle(fontSize: 20.0,color: Colors.white),),
          new Icon(Icons.arrow_forward_ios,color: Colors.white,)
        ],
      ),
    );
  }
}
