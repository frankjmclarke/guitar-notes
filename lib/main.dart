import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'ui/FingerboardPainter.dart';
import 'ui/SoundButton.dart';

/*
E2	82.41
A2	110
D3	146.83
G3	196
B3	246.94
E4	329.63
 */
typedef Fn = void Function();

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Learn the Neck Tuner',
      home: new SharedPreferencesDemo(),
    );
  }
}

class SharedPreferencesDemo extends StatefulWidget {
  SharedPreferencesDemo({Key? key}) : super(key: key);

  @override
  SharedPreferencesDemoState createState() => new SharedPreferencesDemoState();
}

class SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  int firstDay = 0;
  final player = AudioPlayer(
    userAgent: 'myradioapp/1.0 (Linux;Android 11) https://myradioapp.com',
  );

  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();

  Future<Null> getData() async {
    final SharedPreferences prefs = await _sprefs;
    int data = prefs.getInt('firstDay') ?? 2;
    this.setState(() {
      firstDay = data;
    });
  }

  Future<Null> incrementCounter() async {
    final SharedPreferences prefs = await _sprefs;
    setState(() {
      firstDay = firstDay + 1;
      prefs.setInt('firstDay', firstDay);
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await player.dispose();
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Learn the Neck Tuner"),
      ),
      body: GuitarNeck(),
      floatingActionButton: new FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  IntrinsicHeight GuitarNeck() {
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: CustomPaint(painter: FingerboardPainter(firstDay)),
        ),
        Expanded(
          child: Column(children: [
            SoundButton(
              name: "A",
              btn: () => setState(() {
                firstDay = 0;
                play(player, "220_.mp3");
              }),
            ),              SoundButton(
              name: "B",
              btn: () => setState(() {
                firstDay = 1;
                play(player, "246_94.mp3");
              }),
            ),
            SoundButton(
              name: "C",
              btn: () => setState(() {
                firstDay = 2;
                play(player, "261_63.mp3");
              }),
            ),
            SoundButton(
              name: "D",
              btn: () => setState(() {
                firstDay = 3;
                play(player, "293_66.mp3");
              }),
            ),
            SoundButton(
              name: "E",
              btn: () => setState(() {
                firstDay = 4;
                play(player, "329_63.mp3");
              }),
            ),
            SoundButton(
              name: "F",
              btn: () => setState(() {
                firstDay = 5;
                play(player, "349_23.mp3");
              }),
            ),
            SoundButton(
              name: "G",
              btn: () => setState(() {
                firstDay = 6;
                play(player, "392_.mp3");
              }),
            ),
            SoundButton(
              name: "Stop",
              btn: () => setState(() {
                player.stop();
              }),
            ),
          ]),
        ),
      ]),
    );
  }
}

Future<void> play(var player, var freq) async {
  player.setAsset('assets/' + freq);
  player.play(); // Usually you don't want to wait for playback to finish.
  //await player.seek(Duration(seconds: 10));
  //await player.pause();
}


