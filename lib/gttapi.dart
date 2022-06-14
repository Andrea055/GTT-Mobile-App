import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

class StopDB {
  var db = FirebaseFirestore.instance;
  var test = [];
  Future<List> readStops(String stopid) async {
    var stopData = [];
    var stopsRaw = await rootBundle.loadString('assets/stops.json');
    var stops = jsonDecode(stopsRaw);
    for (var i = 0; i < stops.length; i++) {
      if (stops[i]["stop_code"] == int.parse(stopid)) {
        stopData.add(stops[i]["stop_name"]);
        stopData.add(stops[i]["stop_lat"]);
        stopData.add(stops[i]["stop_lon"]);
      }
    }
    return stopData;
  }
}

class GTTAPI {
  Future<List> getstop(String stop) async {
    var endpoint = Uri.parse(
        'https://www.gtt.to.it/cms/index.php?option=com_gtt&task=palina.getTransitiOld&palina=$stop&bacino=U&realtime=true&get_param=value');
    var stops = await http.get(endpoint);
    var parsedStops = jsonDecode(stops.body);
    if (parsedStops[0]["PassaggiRT"].isEmpty &&
        parsedStops[0]["PassaggiPR"].isEmpty) {
      parsedStops = [];
    }
    return parsedStops;
  }
}

class ORDER {
  List<dynamic> orderTime(List<dynamic> times, index) {
    List<dynamic> timesOrder = [];
    for (var i = 0; i < times[index]["PassaggiRT"].length; i++) {
      timesOrder.add("${times[index]["PassaggiRT"][i]}*");
    }
    for (var i = 0; i < times[index]["PassaggiPR"].length; i++) {
      timesOrder.add(times[index]["PassaggiPR"][i]);
    }
    timesOrder.sort();
    return timesOrder;
  }
}
