class Result{
  final String unique_id;
  final String date;
  final String time;
  final String team_1;
  final String team_2;
  final String type;
  final String status;
  final String winner;
  final String result;
  static String change(String time,int flag){
    var x=DateTime.parse(time);
    if(flag==1){
      x=x.add(Duration(hours: 5,minutes:30));       
    }
    String ans=x.toString().split(' ')[1].split('.')[0];
    return ans;
  }
  Result.fromData(String id, String date, String time, String team1, String team2, String type, String status, String winner, String result):
    unique_id=id,
    date=date,
    time=time,
    team_1=team1,
    team_2=team2,
    type=type,
    status=status,
    winner=winner,
    result=result;


  // Result.fromJSON(Map jsonMap):
  //   unique_id=jsonMap['unique_id'],
  //   date=jsonMap['date'].toString().split('T')[0],
  //   time=change(jsonMap['dateTimeGMT'].toString(),0),
  //   team_1=jsonMap['team-1'],
  //   team_2=jsonMap['team-2'],
  //   type=jsonMap['type'],
  //   status=jsonMap['squad'];
}