import '../models/inning.dart';
class LiveMatch {
  String matchId;
  String status;
  String overs;
  String score;
  String runRate;
  String currentInning;
  String tossWonBy;
  String battingTeam;
  String bowlingTeam;
  Set<int> index;
  Inning inning1;
  Inning inning2;
  LiveMatch.fromData(String matchId,String status, String overs, String score, String runRate, String currentInning, String tossWonBy, String battingTeam, String bowlingTeam, Set<int> index, Inning inn1,Inning inn2):
    matchId=matchId,
    status=status,
    overs=overs,
    score=score,
    runRate=runRate,
    currentInning=currentInning,
    tossWonBy=tossWonBy,
    battingTeam=battingTeam,
    bowlingTeam=bowlingTeam,
    index=index,
    inning1=inn1,
    inning2=inn2;
}