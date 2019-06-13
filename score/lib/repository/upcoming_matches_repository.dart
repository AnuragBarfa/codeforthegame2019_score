import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/upcoming_match.dart';

Future<Stream<UpMatche>> getUpMatches() async {
  final String url = 'https://cricapi.com/api/matches?apikey=FEOXAZzomMhoqW1tqDBttVccWfp2';

  final client = new http.Client();
  final streamedRest = await client.send(
      http.Request('get', Uri.parse(url))
  );
  print("inside");
  print(streamedRest);
  print(streamedRest.stream);
  print(streamedRest.stream.transform(utf8.decoder));
  print(streamedRest.stream.transform(utf8.decoder).expand((data) =>(data as List)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .expand((data) => (data as List))
      .map((data) => UpMatche.fromJSON(data));
}