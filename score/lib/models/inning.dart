class Inning{
  final String number;
  final String batting_team;
  final String bowling_team;
  final List<Over> overs;
  final Bowling bowling;
  final Batting batting;
  static String change(String time,int flag){
    var x=DateTime.parse(time);
    if(flag==1){
      x=x.add(Duration(hours: 5,minutes:30));       
    }
    String ans=x.toString().split(' ')[1].split('.')[0];
    return ans;
  }
  Inning.fromData(String num, String bat_team, String bowl_team, List<Over> overs, Bowling bowl, Batting bat):
    number=num,
    batting_team=bat_team,
    bowling_team=bowl_team,
    overs=overs,
    bowling=bowl,
    batting=bat;


  // Result.fromJSON(Map jsonMap):
  //   unique_id=jsonMap['unique_id'],
  //   date=jsonMap['date'].toString().split('T')[0],
  //   time=change(jsonMap['dateTimeGMT'].toString(),0),
  //   team_1=jsonMap['team-1'],
  //   team_2=jsonMap['team-2'],
  //   type=jsonMap['type'],
  //   status=jsonMap['squad'];
}
class Over{
  final String number;
  final String runs;
  final String wickets;
  Over.fromData(String no, String run, String wick):
    number=no,
    runs=run,
    wickets=wick;
}
class Bowling{
  final String overs;
  final String wickets;
  final String maiden;
  final List<Bowler> bolwer;
  Bowling.fromData(String over, String wick, String maiden, List<Bowler> bolwer):
    overs=over,
    wickets=wick,
    maiden=maiden,
    bolwer=bolwer;
}
class Bowler{
  final String name;
  final String runs_conceded;
  final String overs_bowled;
  final String wickets;
  Bowler.fromData(String name,String runs,String overs, String wick):
    name=name,
    runs_conceded=runs,
    overs_bowled=overs,
    wickets=wick;
}
class Batting{
  final String runs;
  final String run_rate;
  final String balls_faced;
  Batting.fromData(String run, String run_rate, String balls_faced):
    runs=run,
    run_rate=run_rate,
    balls_faced=balls_faced;
}
