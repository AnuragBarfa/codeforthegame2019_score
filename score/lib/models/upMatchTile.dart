import 'package:flutter/material.dart';
import '../models/upcoming_match.dart';

class UpMatcheTile extends StatelessWidget {
  final UpMatche _UpMatche;
  UpMatcheTile(this._UpMatche);
  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Container(
        margin: new EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
          color: Colors.white
        ),
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(_UpMatche.date)
                ],
              ),
              new Container(
                margin: new EdgeInsets.only(top: 8.0),
                padding: new EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.lightBlue,
                      width:3.0
                    )
                  ),
                  boxShadow:[
                    new BoxShadow(
                      color: Colors.black,
                      blurRadius: 3.0
                    )
                  ],
                  color: Color.fromRGBO(230, 230, 230, 1.0)
                ),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      child: new CircleAvatar(
                        backgroundImage: new AssetImage("assets/images/profile.jpg"),
                        backgroundColor: Colors.red,
                        radius: 30.0,
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                              // decoration: new BoxDecoration(border: Border.all()),
                              padding: new EdgeInsets.all(8.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  new Container(
                                    padding: new EdgeInsets.only(left: 8.0,right: 8.0),
                                    color: new Color.fromRGBO(217, 217, 217, 1.0),
                                    child: new Text(_UpMatche.type),
                                  ),
                                  new SizedBox(height: 8.0),
                                  new Text(_UpMatche.team_1.toUpperCase()),
                                  new Text(" vs "),
                                  new Text(_UpMatche.team_2.toUpperCase()),
                                  new Divider(),
                                  new Text(_UpMatche.dateTimeGMT+'  |  '+_UpMatche.dateTimeIST)
                                ],
                              ),
                            ),
                    ),
                    new Container(
                      child: new CircleAvatar(
                        backgroundImage: new AssetImage("assets/images/profile.jpg"),
                        backgroundColor: Colors.red,
                        radius: 30.0,
                      ),
                    )
                  ],
                ),                            
              ),
            ],
          )
        ),
      ),
      // ListTile(
      //   title: Text(_UpMatche.team_1),
      //   subtitle: Text(_UpMatche.team_2),
      // ),
    ],
  );
}