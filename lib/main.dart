import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'ui/FingerboardPainter.dart';
import 'ui/SoundButton.dart';
import 'package:responsive_framework/responsive_framework.dart';

typedef Fn = void Function();

void main() {
  runApp(MaterialApp(home: MyApp()));
}

/*
      home: new SharedPreferencesDemo(),


      home: ResponsiveWrapper.builder(
        SharedPreferencesDemo(),
        maxWidth: 1200,
        minWidth: 480,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(480, name: TABLET),
        ],
      ),
 */
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Learn the Neck Tuner',
      home: ResponsiveWrapper.builder(
        Tuner(),
        maxWidth: 1200,
        minWidth: 480,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(480, name: TABLET),
          ResponsiveBreakpoint.autoScale(280, name: PHONE),
        ],
      ),
    );
  }
}

class Tuner extends StatefulWidget {
  Tuner({Key? key}) : super(key: key);

  @override
  TunerState createState() => new TunerState();
}

class TunerState extends State<Tuner> {
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

  bool isPlaying = false;

  void playNote() {
    if (isPlaying)
      player.stop();
    else
      play(player, data[firstDay]);
    isPlaying = !isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Learn the Neck Tuner"),
      ),
      body: GuitarNeck(),
      floatingActionButton: new FloatingActionButton(
        onPressed: playNote,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  final data = [
    "220_",
    "246_94",
    "261_63",
    "293_66",
    "329_63",
    "349_23",
    "392_"
  ];

  IntrinsicHeight GuitarNeck() {
    return IntrinsicHeight(
      //sizes its child to the child's intrinsic height.
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: CustomPaint(painter: FingerboardPainter(firstDay)),
        ),
        Column(children: [
          SoundButton(
            name: "A",
            btn: () => setState(() {
              firstDay = 0;
              if (isPlaying) play(player, data[firstDay]);
            }),
          ),
          SoundButton(
            name: "B",
            btn: () => setState(() {
              firstDay = 1;
              if (isPlaying) play(player, data[firstDay]);
            }),
          ),
          SoundButton(
            name: "C",
            btn: () => setState(() {
              firstDay = 2;
              if (isPlaying) play(player, data[firstDay]);
            }),
          ),
          SoundButton(
            name: "D",
            btn: () => setState(() {
              firstDay = 3;
              if (isPlaying) play(player, data[firstDay]);
            }),
          ),
          SoundButton(
            name: "E",
            btn: () => setState(() {
              firstDay = 4;
              if (isPlaying) play(player, data[firstDay]);
            }),
          ),
          SoundButton(
            name: "F",
            btn: () => setState(() {
              firstDay = 5;
              if (isPlaying) play(player, data[firstDay]);
            }),
          ),
          SoundButton(
            name: "G",
            btn: () => setState(() {
              firstDay = 6;
              if (isPlaying) play(player, data[firstDay]);
            }),
          ),
        ]),
      ]),
    );
  }
}

Future<void> play(var player, var freq) async {
  player.setAsset('assets/' + freq + ".mp3");
  player.play(); // Usually you don't want to wait for playback to finish.
  //await player.seek(Duration(seconds: 10));
  //await player.pause();
}
