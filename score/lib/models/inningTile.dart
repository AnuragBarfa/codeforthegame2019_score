import 'package:flutter/material.dart';
import '../models/inning.dart';
Map<String,String> teamName;
class InningTile extends StatelessWidget{
  Inning _Inning;
  InningTile(Inning inn){
    _Inning=inn;
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
  @override
  Widget build(BuildContext context){
    return new Container(
      padding: EdgeInsets.all(10.0),
      child: _Inning!=null?new Container(
        height: 500,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text("Batting Team: "+teamName[_Inning.batting_team],style: new TextStyle(fontSize: 17.0),),
            new Text("Bowling Team: "+teamName[_Inning.bowling_team],style: new TextStyle(fontSize: 17.0),),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Runs Scored: "+_Inning.batting.runs,style: new TextStyle(fontSize: 17.0),),
                new Text("Overs Bowled: "+_Inning.bowling.overs,style: new TextStyle(fontSize: 17.0),),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Run Rate: "+_Inning.batting.run_rate,style: new TextStyle(fontSize: 17.0),),
                new Text("Wickets: "+_Inning.bowling.wickets,style: new TextStyle(fontSize: 17.0),),
              ],
            ),
            new SizedBox(height: 10.0,),
            new Text("Bowlers Details",style: new TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),),
            new Expanded(//use Expanded to wrap list view in case of error for unbound height
              child:new Scrollbar(
                child: new ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: _Inning.bowling.bolwer.length,
                  itemBuilder: (context, index) => new BowlerTile(_Inning.bowling.bolwer[index]),
                ),
              ),
            ),
            new SizedBox(height: 10.0,),
            new Text("Overwise Stats",style: new TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text("Over",style: new TextStyle(fontSize: 15.0),),
                new Text("Runs",style: new TextStyle(fontSize: 15.0),),
                new Text("Wickets",style: new TextStyle(fontSize: 15.0),)
              ],
            ),
            new Expanded(//use Expanded to wrap list view in case of error for unbound height
              child:new Scrollbar(
                child: new ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: _Inning.overs.length,
                  itemBuilder: (context, index) => new OverTile(_Inning.overs[index]),
                ),
              ),
            ),
          ],
        ),
      ):new Container(height: 0.0,),
    );
  }
}
class OverTile extends StatelessWidget{
  Over _Over;
  OverTile(Over over){
    _Over=over;
  }
  @override
  Widget build(BuildContext context){
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Text(_Over.number),
          new Text(_Over.runs),
          new Text(_Over.wickets)
        ],
      ),
    );
  }
}

class BowlerTile extends StatelessWidget{
  Bowler _Bowler;
  BowlerTile(Bowler bowler){
    _Bowler=bowler;
  }
  @override
  Widget build(BuildContext context){
    return new Container(
      padding: EdgeInsets.all(5.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text("Name: "+_Bowler.name,style: new TextStyle(fontSize: 15.0)),
          new Text("Overs Bowled: "+_Bowler.overs_bowled),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text("Runs Conceded: "+_Bowler.runs_conceded),
              new Text("Wickets: "+_Bowler.wickets)
            ],
          ),
        ],
      ),
    ); 
  }
}