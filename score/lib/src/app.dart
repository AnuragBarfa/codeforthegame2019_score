import 'package:flutter/material.dart';
import 'screens/main.dart';
import 'screens/match_detail.dart';
import 'screens/my_team.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter login demo',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => new MainScreen(),
      },
      home: new MyTeam(),
      // home: new MainScreen(),
    );
  }
}

 class Splash extends StatefulWidget {
   @override
   SplashState createState() => new SplashState();
 }

 class SplashState extends State<Splash> {
  
   Future checkFirstSeen() async {
     Navigator.of(context).pushReplacement(
           new MaterialPageRoute(builder: (context) => new IntroScreen()));
     SharedPreferences prefs = await SharedPreferences.getInstance();
     bool _seen = (prefs.getBool('seen') ?? false);
     String _team = (prefs.getString('fav_team') ?? 'Chose Your Team');
     _seen=false;
     if (_seen) {
       Navigator.of(context).pushReplacement(
           new MaterialPageRoute(builder: (context) => new Home()));
     } else {
       prefs.setBool('seen', true);
       Navigator.of(context).pushReplacement(
           new MaterialPageRoute(builder: (context) => new FirstTime()));
     }
   }

   @override
   void initState() {
     print("in init");
     super.initState();
     new Timer(new Duration(milliseconds: 5), () {
       print("for check");
       checkFirstSeen();
     });
   }

   @override
   Widget build(BuildContext context) {
     print("building");
     return new Scaffold(
       body: new Center(
         child: new Text('Loading...'),
       ),
     );
   }
 }

 class Home extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return new Scaffold(
       appBar: new AppBar(
         title: new Text('Hello'),
       ),
       body: new Center(
         child: new Text('This is the second page'),
       ),
     );
   }
 }

 class IntroScreen extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return new Scaffold(
       body: new Center(
         child: new Column(
           mainAxisSize: MainAxisSize.min,
           children: <Widget>[
             new Text('This is the intro page'),
             new MaterialButton(
               child: new Text('Gogo Home Page'),
               onPressed: () {
                 Navigator.of(context).pushReplacement(
                     new MaterialPageRoute(builder: (context) => new Home()));
               },
             )
           ],
         ),
       ),
     );
   }
 }
 class FirstTime extends StatefulWidget {
  @override
  FirstTimeState createState() => FirstTimeState();
}
String dropDownValue="Chose Your Team";
// Create a corresponding State class.
// This class holds data related to the form.
class FirstTimeState extends State<FirstTime> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  Map<String,String> teamName;
  List<DropdownMenuItem<String> > Options;
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
    Options = <DropdownMenuItem<String> >[];
    teamName.forEach((k,v) => Options.add(DropdownMenuItem<String>(
                          value: k,
                          child: Text(v),
                        )));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    new Text("Choose Your Favorite team",style: new TextStyle(fontSize: 18.0),),
                    new SizedBox(height: 10.0,),
                    DropdownButtonFormField<String>(
                      validator: (value){
                        print("object");
                        if(value == null || value=="Not Selected"){
                          return 'Required';
                        }
                      },
                      onSaved: (value){
                          print("as");
                      },
                      onChanged: (String newValue){
                        setState(() {
                          dropDownValue=newValue;
                        });
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        labelText: (dropDownValue=="Chose Your Team") ? dropDownValue :teamName[dropDownValue],
                      ),
                      items: Options,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () async{
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          // print("in");
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a Snackbar.
                            // print("inside");
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('fav_team', dropDownValue);
                            // print(dropDownValue);
                            var route = new MaterialPageRoute(
                              builder: (BuildContext context) => 
                                new MainScreen(),
                            );
                            Navigator.of(context).push(route);
                            // Scaffold.of(context)
                            //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                          }
                        },
                        child: Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new InkWell(
                    onTap: (){
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) => 
                          new MainScreen(),
                      );
                      Navigator.of(context).push(route);
                    },
                    child: new Container(
                      child: new Text("Skip...",style: new TextStyle(fontSize: 20.0),),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFe4e9ed),
    );
  }
}

