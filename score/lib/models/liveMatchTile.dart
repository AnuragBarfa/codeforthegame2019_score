import 'package:flutter/material.dart';
import '../models/liveMatch.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/inningTile.dart';
import '../models/inning.dart';
class LiveMatchTile extends StatelessWidget {
  LiveMatch _LiveMatch;
  LiveMatchTile(LiveMatch live){
    _LiveMatch=live;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: (_LiveMatch.status=="live")?new Container(
          child: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: new BoxDecoration(
                    boxShadow:[
                      new BoxShadow(
                        color: Colors.black,
                        blurRadius: 3.0
                      )
                    ],
                    color: Color.fromRGBO(230, 230, 230, 1.0)
                  ),
                  margin: EdgeInsets.all(15.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Text("Batting",style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                              new SizedBox(height: 10.0,),
                              new CircleAvatar(
                                backgroundImage: new AssetImage("assets/images/"+_LiveMatch.battingTeam.toLowerCase().replaceAll(' ','-')+".jpg"),
                                backgroundColor: Colors.red,
                                radius: 30.0,
                              ),
                              new SizedBox(height: 10.0,),
                              new Text(_LiveMatch.battingTeam.toUpperCase(),style: new TextStyle(fontSize: 13.0),)
                            ],
                          )
                        ),
                        new Expanded(
                          child: new Container(
                                  // decoration: new BoxDecoration(border: Border.all()),
                                  padding: new EdgeInsets.all(8.0),
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new Text("Inning: "+_LiveMatch.currentInning,style: new TextStyle(fontWeight: FontWeight.bold),),
                                      new Text("Score: "+_LiveMatch.score,style: new TextStyle(fontWeight: FontWeight.bold),),
                                      new Text("Overs: "+_LiveMatch.overs,style: new TextStyle(fontWeight: FontWeight.bold),),
                                      new Text("Run Rate: "+_LiveMatch.runRate,style: new TextStyle(fontWeight: FontWeight.bold),),
                                      new Text("*Toss Won By: "+_LiveMatch.tossWonBy,style: new TextStyle(fontSize: 10.0),),
                                    ],
                                  ),
                                ),
                        ),
                        new Container(
                          child: new Column(
                            children: <Widget>[
                              new Text("Bowling",style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                              new SizedBox(height: 10.0,),
                              new CircleAvatar(
                                backgroundImage: new AssetImage("assets/images/"+_LiveMatch.bowlingTeam.toLowerCase().replaceAll(' ','-')+".jpg"),
                                backgroundColor: Colors.red,
                                radius: 30.0,
                              ),
                              new SizedBox(height: 10.0,),
                              new Text(_LiveMatch.bowlingTeam.toUpperCase(),style: new TextStyle(fontSize: 13.0),)
                            ],
                          )
                        ),
                    ],
                  ),
                ),
                new DropWindow(_LiveMatch.inning1,"Inning 1"),
                new DropWindow(_LiveMatch.inning2,"Inning 2")
              ],
            ),
          ),
        ):new Container(
          child: (_LiveMatch.status=="fetching")?new Container(
            child: new Container(height: 0,),
          ):new Container(
            margin: EdgeInsets.all(15.0),
            decoration: new BoxDecoration(
              boxShadow:[
                new BoxShadow(
                  color: Colors.black,
                  blurRadius: 3.0
                )
              ],
              color: Colors.white
            ),
            child:new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new CircleAvatar(
                            backgroundImage: new AssetImage("assets/images/"+_LiveMatch.bowlingTeam.toLowerCase().replaceAll(' ','-')+".jpg"),
                            backgroundColor: Colors.red,
                            radius: 20.0,
                          ),
                          new SizedBox(height: 10.0,),
                          new Text(_LiveMatch.bowlingTeam.toUpperCase(),style: new TextStyle(fontSize: 13.0),)
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Container(
                            padding: new EdgeInsets.only(right:20,left:20),
                            decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: new Border.all(
                                color: Colors.blueGrey[200],
                                width:1.0,
                              ),
                              borderRadius: new BorderRadius.circular(10.0),
                              color: Colors.blueGrey[100],
                            ),
                            child: new Text("Vs"),
                          ),
                          new SizedBox(height: 10,),
                          new Text("Status: "+_LiveMatch.status),
                        ],
                      ),
                      
                       new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new CircleAvatar(
                            backgroundImage: new AssetImage("assets/images/"+_LiveMatch.battingTeam.toLowerCase().replaceAll(' ','-')+".jpg"),
                            backgroundColor: Colors.red,
                            radius: 20.0,
                          ),
                          new SizedBox(height: 10.0,),
                          new Text(_LiveMatch.battingTeam.toUpperCase(),style: new TextStyle(fontSize: 13.0),)
                        ],
                      ),
                    ],
                  ),
                ),
                new Container(
                  child:(_LiveMatch.status=="closed")?new Text(_LiveMatch.tossWonBy):new Container(height: 0,)
                ),
              ],
            ),
          ),
        ),
    );
  }
}
class DropWindow extends StatefulWidget {
  Inning inning;
  String heading;
  DropWindow(Inning inn,String head){
    inning=inn;
    heading=head;
  }
  @override
  _DropWindowState createState() => _DropWindowState(inning,heading);
}

class _DropWindowState extends State<DropWindow> {
  Set<int> index;
  Inning inning;
  String heading;
  _DropWindowState(Inning inn,String head){
    inning=inn;
    heading=head;
  }
  @override
  void initState(){
    super.initState();
    index=new Set();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
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
            child:new Heading(heading)
          ),
          new Offstage(
            offstage: !index.contains(1),
            child: new InningTile(inning),
          ),
        ],
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