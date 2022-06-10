import 'dart:convert';
import 'package:http/http.dart' as http;

class GTTAPI {

  Future<List> getstop(String stop) async {
    print(stop);
    var endpoint = Uri.parse('https://www.gtt.to.it/cms/index.php?option=com_gtt&task=palina.getTransitiOld&palina=$stop&bacino=U&realtime=true&get_param=value');
    var stops = await http.get(endpoint);
    var parsedStops = jsonDecode(stops.body);
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
    print(times_order);
    return times_order;
  }
}