import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Create a Form widget.
class Setting extends StatefulWidget {
  @override
  SettingState createState() => SettingState();
}

String dropDownValue="Chose Your Team";
// Create a corresponding State class.
// This class holds data related to the form.
class SettingState extends State<Setting> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  Map<String,String> teamName;
  List<DropdownMenuItem<String> > Options;
  BuildContext _scaffoldContext;
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
    loadTeamName();                                        
  }
  void loadTeamName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dropDownValue=prefs.getString('fav_team');
    });
  }
  @override
  Widget build(BuildContext context){
    Widget body = new Center(
        child: new Container(
          padding: EdgeInsets.all(10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    new Text("Choose Your Team to see how it's doing",style: new TextStyle(fontSize: 18.0),),
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
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('fav_team', dropDownValue);
                            Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
                              content: Text('Team Name Saved'),
                              duration: Duration(seconds: 1),
                            ));
                            // print("inside");
                            // print(dropDownValue);
                            // // Scaffold.of(context)
                            //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                          }
                        },
                        child: Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        title: new Text("Settings"),
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context,false),
        )
      ),
      body: new Builder(
        builder: (BuildContext context){
          _scaffoldContext = context;
          return body;
        },
      ),
      backgroundColor: Color(0xFFe4e9ed),
    );
  }
}

