class UpMatche{
  final int unique_id;
  final String date;
  final String dateTimeGMT;
  final String team_1;
  final String team_2;
  final String type;
  final bool squad;
  final bool matchStarted;
  final String winner_team;
  final String toss_winner_team;

  UpMatche.fromJSON(Map jsonMap):
    unique_id=jsonMap['unique_id'],
    date=jsonMap['date'],
    dateTimeGMT=jsonMap['dateTimeGMT'],
    team_1=jsonMap['team-1'],
    team_2=jsonMap['team-2'],
    type=jsonMap['type'],
    squad=jsonMap['squad'],
    matchStarted=jsonMap['matchStarted'],
    winner_team=jsonMap['winner_team'],
    toss_winner_team=jsonMap['toss_winner_team'];
}