import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
class StopDB {
  var db = FirebaseFirestore.instance;
  var test = [];
  Future<List> readStops(String stopid) async{
    var stopData = [];
    await db.collection("fermate").get().then((event) {
     for(var i = 0; i < event.docs.length; i++){
       var stop = event.docs[i].data();
       if(stop["stopCode"] == int.parse(stopid)){
         stopData.add(stop["stopName"]);
         stopData.add(stop["stopLat"]);
         stopData.add(stop["stopLon"]);
       }
     }
    });
    return stopData;
  }
}
class GTTAPI {

  Future<List> getstop(String stop) async {
    var endpoint = Uri.parse('https://www.gtt.to.it/cms/index.php?option=com_gtt&task=palina.getTransitiOld&palina=$stop&bacino=U&realtime=true&get_param=value');
    var stops = await http.get(endpoint);
    var parsedStops = jsonDecode(stops.body);
    if(parsedStops[0]["PassaggiRT"].isEmpty && parsedStops[0]["PassaggiPR"].isEmpty){
      parsedStops = [];
      
    }
    return parsedStops;
  }
}

class ORDER {
  List<dynamic> orderTime(List<dynamic> times, index){
    List<dynamic> times_order = [];
    for(var i = 0; i < times[index]["PassaggiRT"].length; i++){
      times_order.add("${times[index]["PassaggiRT"][i]}*");
    }
    for(var i = 0; i < times[index]["PassaggiPR"].length; i++){
      times_order.add(times[index]["PassaggiPR"][i]);
    }
    times_order.sort();
    return times_order;
  }
}