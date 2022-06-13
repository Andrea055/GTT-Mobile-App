import 'package:flutter/material.dart';
import 'gttapi.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'map.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orari GTT',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      home: const DefaultTabController(
        length: 1,
        child: MyHomePage(title: 'Orari Bus GTT'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> stops = [];
  bool spinner = false;
  String stopName = "";
  double lat = 45.0735;
  double lon = 7.6757;
  @override
  Widget build(BuildContext context) {
    var input = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Mapview(lat: lat, long: lon, fermata: stopName)),
              );
              break;
            default:
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.train),
            label: 'Cerca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mappa',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text("\n"),
            Text(stopName),
            TextField(
                controller: input,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      stops = [];
                      setState(() {
                        spinner = true;
                      });
                      final GTTAPI api = GTTAPI();
                      final StopDB db = StopDB();
                      db.readStops(input.text).then((stopRaw) {
                        api.getstop(input.text).then((value) async {
                          if (value.isEmpty) {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Fermata non trovata'),
                                content: const Text(
                                    'La fermata non è presente nel database GTT, probabilmente, il numero inserito non è corretto.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Ok');
                                      spinner = false;
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            setState(() {
                              stopName = stopRaw[0];
                              lat = stopRaw[1];
                              lon = stopRaw[2];
                              stops = value;
                              spinner = false;
                            });
                          }
                        });
                      });
                    },
                  ),
                )),
            const Text("\n"),
            if (spinner)
              const SpinKitCircle(
                color: Colors.white,
                size: 120.0,
              ),
            SizedBox(
                height: 450,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: stops.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ORDER order = ORDER();
                    var times = order.orderTime(stops, index);
                    return Container(
                      height: 70,
                      width: 400,
                      color: Colors.blueGrey,
                      child: Row(children: <Widget>[
                        Text(" ${stops[index]["Linea"]}"),
                        const Text(" "),
                        Text(stops[index]["DirezioneBreve"]),
                        SizedBox(
                          height: 70,
                          width: 200,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(8),
                              itemCount: times.length,
                              itemBuilder:
                                  (BuildContext context, int indexTime) {
                                return SizedBox(
                                  height: 50,
                                  width: 60,
                                  child: Center(child: Text(times[indexTime])),
                                );
                              }),
                        )
                      ]),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ))
          ],
        ),
      ),
    );
  }
}
