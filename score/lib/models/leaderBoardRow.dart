class LeaderBoardRow{
  String name;
  int rank;
  int played;
  int win;
  int draw;
  int loss;
  int points;
  double netRunRate;
  static String change(String time,int flag){
    var x=DateTime.parse(time);
    if(flag==1){
      x=x.add(Duration(hours: 5,minutes:30));       
    }
    String ans=x.toString().split(' ')[1].split('.')[0];
    return ans;
  }
  LeaderBoardRow.fromJSON(Map jsonMap):
    name=jsonMap['team']['name'],
    rank=jsonMap['rank'],
    played=jsonMap['played'],
    win=jsonMap['win'],
    draw=jsonMap['draw'],
    loss=jsonMap['loss'],
    points=jsonMap['points'],
    netRunRate=jsonMap['net_run_rate'];

}