import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override 
  void initState() {
    super.initState();
    loadTeamName();                                        
  }
  void loadTeamName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      teamValue=prefs.getString('fav_team');
    });
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
              new Text(teamValue),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFe4e9ed),
    );
  }
}

