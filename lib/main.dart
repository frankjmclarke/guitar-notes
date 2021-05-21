import 'package:delme/ui/CustomRadio.dart';
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
  List<RadioModel> sampleData = <RadioModel>[]; //List<RadioModel>();
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
    sampleData.add(new RadioModel(false, 'A', 'April 18'));
    sampleData.add(new RadioModel(false, 'B', 'April 17'));
    sampleData.add(new RadioModel(false, 'C', 'April 16'));
    sampleData.add(new RadioModel(false, 'D', 'April 15'));
    sampleData.add(new RadioModel(false, 'E', 'April 18'));
    sampleData.add(new RadioModel(false, 'F', 'April 17'));
    sampleData.add(new RadioModel(false, 'G', 'April 16'));
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
      body: IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: GuitarNeck()),
              Expanded(
                child: Container(
                  height: 300,
                  child: new ListView.builder(
                    itemCount: sampleData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                        //highlightColor: Colors.red,
                        splashColor: Colors.blueAccent,
                        onTap: () {
                          setState(() {
                            sampleData.forEach(
                                (element) => element.isSelected = false);
                            sampleData[index].isSelected = true;
                          });
                        },
                        child: Column(
                          children: [
                            new RadioItem(sampleData[index]),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]),
      ),
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
      child: CustomPaint(painter: FingerboardPainter(firstDay)),
    );
  }
}

Future<void> play(var player, var freq) async {
  player.setAsset('assets/' + freq + ".mp3");
  player.play(); // Usually you don't want to wait for playback to finish.
  //await player.seek(Duration(seconds: 10));
  //await player.pause();
}
