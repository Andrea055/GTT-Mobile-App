import 'package:flutter/material.dart';
import 'gttapi.dart';
void main() {
  runApp(const MyApp());
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
      ),
      home: const MyHomePage(title: 'Orari Bus GTT'),
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
  @override
  Widget build(BuildContext context) {
    var input = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  <Widget>[

            const Text("\n"),
            TextField(
              controller: input,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      final GTTAPI api = GTTAPI();
                      api.getstop(input.text).then((value) {
                        stops = value;
                        setState(() {});
                      });
                    },
                  ),
                )
            ),
            SizedBox(
              height: 700,
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: stops.length,
                itemBuilder: (BuildContext context, int index) {
                  final ORDER order = ORDER();
                  var times = order.orderTime(stops, index);
                  return Container(
                    height: 70,
                    width: 400,
                    color: Colors.grey,
                    child: Row(
                        children: <Widget>[
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
                                itemBuilder: (BuildContext context, int indexTime) {
                                  return SizedBox(
                                    height: 50,
                                    width: 60,
                                    child: Center(child: Text(times[indexTime])),
                                  );
                                }
                            ),
                          )
                        ]
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              )
            )
          ],
        ),
      ),
    );
  }
}
