import 'package:flutter/material.dart';
import '../models/leaderBoardRow.dart';
class LeaderBoardTile extends StatelessWidget{
  final LeaderBoardRow _LeaderBoardRow;
  final String myTeam;
  LeaderBoardTile(this._LeaderBoardRow,this.myTeam);
  @override 
  Widget build(BuildContext context)=>Column(
    children: <Widget>[ 
      new Container(
          margin: new EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
            color: (this.myTeam==_LeaderBoardRow.name)?Colors.teal[100]:Colors.white,
          ),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Container(
            padding: new EdgeInsets.all(8.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  flex: 1,
                  child: new Text(_LeaderBoardRow.rank),
                ),
                new Expanded(
                  flex: 5,
                  child: new Container(
                    child: new Row(
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundImage: new AssetImage("assets/images/"+_LeaderBoardRow.name.toLowerCase().replaceAll(' ','-')+".jpg"),
                          backgroundColor: Colors.red,
                          radius: 20.0,
                        ),
                        new Text("  "+_LeaderBoardRow.name),
                      ],
                    ),
                  ),
                ),
                new Expanded(
                  flex: 1,
                  child:new Text(_LeaderBoardRow.played) ,
                ),
                new Expanded(
                  flex: 1,
                  child: new Text(_LeaderBoardRow.win),
                ),
                new Expanded(
                  flex: 1,
                  child: new Text(_LeaderBoardRow.loss),
                ),
                new Expanded(
                  flex: 1,
                  child: new Text(_LeaderBoardRow.points),
                ),
                new Expanded(
                  flex: 2,
                  child:new Text(_LeaderBoardRow.netRunRate) ,
                ),      
              ],
            )
          )
      ), 
    ]
    );
}
