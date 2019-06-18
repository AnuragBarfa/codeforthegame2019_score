import 'package:flutter/material.dart';
import '../models/leaderBoardRow.dart';
class LeaderBoardTile extends StatelessWidget{
  final LeaderBoardRow _LeaderBoardRow;
  LeaderBoardTile(this._LeaderBoardRow);
  @override 
  Widget build(BuildContext context)=>Column(
    children: <Widget>[
      new Row(
        children: <Widget>[
          new Text(_LeaderBoardRow.rank.toString()),
          new Text(_LeaderBoardRow.name)
        ],
      ),
      new Row(
        children: <Widget>[
          new Text(_LeaderBoardRow.played.toString()),
          new Text(_LeaderBoardRow.win.toString()),
          new Text(_LeaderBoardRow.loss.toString()) 
        ],
      )
    ]
    );
}
