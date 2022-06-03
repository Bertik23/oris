import 'dart:convert';

import 'package:http/http.dart' as http;

const baseUrl = "https://oris.orientacnisporty.cz/API/?format=json&method=";

String weekDay(int num){
  return ["po", "út", "st", "čt", "pá", "so", "ne"][num-1];
}

class OrisEvent{
  String id = "";
  String name = "";
  DateTime date;
  List<String> orgs;

  OrisEvent({required this.id, required this.name, required this.date, required this.orgs});

  factory OrisEvent.fromJson(Map<String, dynamic> json){
    List<String> orgs;
    if (json["Org2"].runtimeType == List){
      orgs = [json["Org1"]["Abbr"],];
    } else {
      orgs = [json["Org1"]["Abbr"], json["Org2"]["Abbr"]];
    }
    return OrisEvent(
      id: json["ID"],
      name: json["Name"],
      date: DateTime.parse(json["Date"]),
      orgs: orgs,
    );
  }

  String get listDate{
    return "${weekDay(date.weekday)} ${date.day}.${date.month}";
  }
}

Future<List<OrisEvent>> getEventList() async {
  Uri url = Uri.parse("${baseUrl}getEventList&datefrom=2022-06-01&dateto=2022-06-30");
  http.Response response = await http.get(url);
  //print(response.body);
  //print(jsonDecode(response.body)["Data"]);
  print("Got data");
  return jsonDecode(response.body)["Data"].entries.map<OrisEvent>((event) => OrisEvent.fromJson(event.value)).toList();
}