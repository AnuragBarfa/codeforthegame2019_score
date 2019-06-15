class UpMatche{
  final int unique_id;
  final String date;
  final String dateTimeGMT;
  final String dateTimeIST;
  final String team_1;
  final String team_2;
  final String type;
  final bool squad;
  final bool matchStarted;
  final String winner_team;
  final String toss_winner_team;
  static String change(String time,int flag){
    var x=DateTime.parse(time);
    if(flag==1){
      x=x.add(Duration(hours: 5,minutes:30));       
    }
    String ans=x.toString().split(' ')[1].split('.')[0];
    return ans;
  }
  UpMatche.fromJSON(Map jsonMap):
    unique_id=jsonMap['unique_id'],
    date=jsonMap['date'].toString().split('T')[0],
    dateTimeGMT=change(jsonMap['dateTimeGMT'].toString(),0),
    dateTimeIST=change(jsonMap['dateTimeGMT'].toString(),1),
    team_1=jsonMap['team-1'],
    team_2=jsonMap['team-2'],
    type=jsonMap['type'],
    squad=jsonMap['squad'],
    matchStarted=jsonMap['matchStarted'],
    winner_team=jsonMap['winner_team'],
    toss_winner_team=jsonMap['toss_winner_team'];
}