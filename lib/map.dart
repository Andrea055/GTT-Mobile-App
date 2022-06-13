import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:map_launcher/map_launcher.dart';

class Mapview extends StatefulWidget {
  double lat;
  double long;
  String fermata;
  Mapview(
      {super.key,
      required this.lat,
      required this.long,
      required this.fermata});
  @override
  _Mapview createState() => _Mapview(lat: lat, long: long, fermata: fermata);
}

class _Mapview extends State<Mapview> {
  double lat = 0;
  double long = 0;
  String fermata;
  _Mapview({required this.lat, required this.long, required this.fermata});
  List<dynamic> files = <dynamic>[];

  @override
  Widget build(BuildContext context) {
    MapController controller = MapController(
        initMapWithUserPosition: false,
        initPosition: GeoPoint(latitude: lat, longitude: long));

    return Scaffold(
        appBar: AppBar(title: Text(fermata), actions: const <Widget>[]),
        body: Center(
            child: Stack(children: <Widget>[
          OSMFlutter(
              onMapIsReady: (ready) async {
                await controller.addMarker(
                  GeoPoint(latitude: lat, longitude: long),
                  markerIcon: const MarkerIcon(
                    icon: Icon(
                      Icons.train,
                      color: Color.fromARGB(255, 166, 0, 255),
                      size: 128,
                    ),
                  ),
                );
              },
              controller: controller,
              trackMyPosition: false,
              initZoom: 19,
              minZoomLevel: 8,
              maxZoomLevel: 14,
              stepZoom: 1.0),
          SizedBox(
              width: 2000,
              height: 100,
              child: Center(
                  child: ElevatedButton(
                child: const Text("Naviga alla fermata"),
                onPressed: () async {
                  final availableMaps = await MapLauncher.installedMaps;
                  await availableMaps.first.showMarker(
                    coords: Coords(lat, long),
                    title: fermata,
                  );
                },
              ))),
          Column(
            children: [
              ElevatedButton(
                child: const Text("+"),
                onPressed: () async {
                  await controller.zoomIn();
                },
              ),
              ElevatedButton(
                child: const Text("-"),
                onPressed: () async {
                  await controller.zoomOut();
                },
              )
            ],
          )
        ])));
  }
}
