import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
import '../../models/quiz.dart';
class FunPage extends StatefulWidget {
  @override
  _FunPageState createState() => _FunPageState();
}

class _FunPageState extends State<FunPage> {

  Quiz quiz;
  List<Results> results;
  var unescape = new HtmlUnescape();
  Future<void> fetchQuestions()async{
    var res = await http.get("https://opentdb.com/api.php?amount=5&category=21&type=multiple");
    var decRes = jsonDecode(res.body);
    // print(decRes);
    quiz = Quiz.fromJson(decRes);
    results = quiz.results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        title: new Text("Quiz"),
        elevation: 0.0,
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context,false),
        )
      ),
      body: RefreshIndicator(
        onRefresh: fetchQuestions,
              child: new FutureBuilder(
          future: fetchQuestions(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
                return Text("Press Button to Start !");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if(snapshot.hasError) return errorData(
                  snapshot
                );
              return questionsList();
            }
            return null;
          },
        ),
      ),
    );
  }

  Padding errorData(AsyncSnapshot snapshot){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Error :${snapshot.error}"),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            onPressed: (){
              fetchQuestions();
              setState(() {
                              
                            });
            },
            child: new Text("Try Again"),
          )
        ],
      ),
    );
  }

  ListView questionsList(){
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context,i)=>Card(
        color: Colors.white,
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(unescape.convert(results[i].question),style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
              ],
            ),
            leading: new CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: new Text((i+1).toString()),
            ),
            children: results[i].incorrectAnswers.map((m){
              return AnswerWidget(results, i, m);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class AnswerWidget extends StatefulWidget {

  final List<Results> results;
  final int index;
  final String m;

  AnswerWidget(this.results,this.index,this.m);


  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {

  Color c = Colors.black;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        setState(() {
                  if(widget.m == widget.results[widget.index].correctAnswer){
          c = Colors.green;
        }
        else{
          c = Colors.red;
        }
                });
      },
      title: new Text(
        widget.m,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: c,
          fontWeight: FontWeight.bold,
        )
      ),
    );
  }
}