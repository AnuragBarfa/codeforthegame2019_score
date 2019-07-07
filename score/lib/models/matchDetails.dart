class MatchDetails{
  String date;
  String team1;
  String team2;
  Venue venue;
  String status;
  String result;
  
  static String change(String time,int flag){
    var x=DateTime.parse(time);
    if(flag==1){
      x=x.add(Duration(hours: 5,minutes:30));       
    }
    String ans=x.toString().split(' ')[1].split('.')[0];
    return ans;
  }
  MatchDetails.fromData(String date, String team1, String team2, Venue venue, String status, String result):
    date=date,
    team1=team1,
    team2=team2,
    venue=venue,
    status=status,
    result=result;
}

class Venue{
  String name;
  String city;
  String country;
  Venue.fromData(String name, String city, String country):
    name=name,
    city=city,
    country=country;
}