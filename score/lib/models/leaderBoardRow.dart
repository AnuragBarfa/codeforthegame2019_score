class LeaderBoardRow{
  String name;
  String rank;
  String played;
  String win;
  String draw;
  String loss;
  String points;
  String netRunRate;
  static String change(String time,int flag){
    var x=DateTime.parse(time);
    if(flag==1){
      x=x.add(Duration(hours: 5,minutes:30));       
    }
    String ans=x.toString().split(' ')[1].split('.')[0];
    return ans;
  }
  LeaderBoardRow.fromData(String name1, String rank1, String played1, String win1, String draw1, String loss1, String points1, String netRunRate1):
    name=name1,
    rank=rank1,
    played=played1,
    win=win1,
    draw=draw1,
    loss=loss1,
    points=points1,
    netRunRate=netRunRate1;

  LeaderBoardRow.fromJSON(Map jsonMap):
    name=jsonMap['team']['name'].toString(),
    rank=jsonMap['rank'].toString(),
    played=jsonMap['played'].toString(),
    win=jsonMap['win'].toString(),
    draw=jsonMap['draw'].toString(),
    loss=jsonMap['loss'].toString(),
    points=jsonMap['points'].toString(),
    netRunRate=jsonMap['net_run_rate'].toString();

}