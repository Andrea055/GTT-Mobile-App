import 'package:flutter/material.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class Newsview extends StatefulWidget {
  const Newsview({super.key});
  @override
  _Newsview createState() => _Newsview();
}

class _Newsview extends State<Newsview> {
  var titoli = [];
  bool spinner = true;
  bool fetched = false;
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  final Uri url = Uri.parse(
      'https://www.gtt.to.it/cms/avvisi-e-informazioni-di-servizio?start=10');

  void fetchnews() async {
    var news = await http.get(Uri.parse(
        'https://www.gtt.to.it/cms/avvisi-e-informazioni-di-servizio?format=feed&amp;type=rss'));
    var rssFeed = RssFeed.parse(news.body);
    for (var title in rssFeed.items) {
      titoli.add(title);
    }
    fetched = true;
    setState(() {
      spinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (fetched == false) {
      fetchnews();
    }

    if (spinner) {
      return Scaffold(
          appBar:
              AppBar(title: const Text("Notizie"), actions: const <Widget>[]),
          body: const Center(
              child: Center(
            child: SpinKitCircle(
              color: Colors.white,
              size: 120.0,
            ),
          )));
    } else {
      return Scaffold(
          appBar:
              AppBar(title: const Text("Notizie"), actions: const <Widget>[]),
          body: Column(children: [
            Expanded(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: titoli.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 50,
                      child: TextButton(
                        style: TextButton.styleFrom(primary: Colors.white),
                        child: Text(titoli[index].title),
                        onPressed: () async {
                          return showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(titoli[index].title),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text((titoli[index].description)
                                          .replaceAll(exp, '')),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        primary: Colors.white),
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  }),
            ),
            Container(
              child: ElevatedButton(
                  onPressed: () async {
                    await launchUrl(url);
                  },
                  child: const Text(
                      "Per informazioni complete visita il sito della GTT")),
            )
          ]));
    }
  }
}
