import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
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
    //var duration = await player.setAsset('assets/330.wav');
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



//      child:new Text(counter.toString())
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Learn the Neck Tuner"),
      ),
      body: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: CustomPaint(painter: FaceOutlinePainter(firstDay)),
          ),
          Expanded(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow),
                  ),
                  onPressed: () {
                    setState(() {
                      firstDay = 0;
                    });
                    play(player,"220.wav");
                  },
                  child: Text('A'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow),
                  ),
                  onPressed: () {
                    setState(() {
                      firstDay = 1;
                    });
                    play(player,"246.94.wav");
                  },
                  child: Text('B'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow),
                  ),
                  onPressed: () {
                    setState(() {
                      firstDay = 2;
                    });
                    play(player,"261.63.wav");
                  },
                  child: Text('C'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow),
                  ),
                  onPressed: () {
                    setState(() {
                      firstDay = 3;
                    });
                    play(player,"311.13.wav");
                  },
                  child: Text('D'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow),
                  ),
                  onPressed: () {
                    setState(() {
                      firstDay = 4;
                    });
                    play(player,"329.63.wav");
                  },
                  child: Text('E'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow),
                  ),
                  onPressed: () {
                    setState(() {
                      firstDay = 5;
                    });
                    play(player,"349.23.wav");
                  },

                  child: Text('F'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow),
                  ),
                  onPressed: () {
                    setState(() {
                      firstDay = 6;
                    });
                    play(player,"392.wav");
                  },
                  child: Text('G'),
                ),
              ),
            ]),
          ),
        ]),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> play(var player, var freq) async {
  player.setAsset('assets/'+freq);
  player.play(); // Usually you don't want to wait for playback to finish.
  //await player.seek(Duration(seconds: 10));
  //await player.pause();
}

class FaceOutlinePainter extends CustomPainter {
  int firstDay = 0;

  FaceOutlinePainter(this.firstDay);

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.indigo;

    double squareSize = size.width / 10.0;

    //drawRect(canvas, squareSize, paint);
    drawFrets(canvas, squareSize, paint);
    drawStrings(canvas, squareSize, paint);

    drawMarkers(squareSize, paint, canvas);
    var week = firstDay; //dayDiff(firstDay);
    for (double across = 0; across < 6; across++)
      drawCircles(across, squareSize, paint, canvas, week);
  }

  @override
  bool shouldRepaint(FaceOutlinePainter oldDelegate) => false;
}

void drawFrets(canvas, squareSize, paint) {
  double half = squareSize / 2;
  paint.color = Colors.cyan;
  for (double down = 0; down < 13; down++) {
    //
    canvas.drawLine(Offset(half, down * squareSize + half),
        Offset(squareSize * 5.5, down * squareSize + half), paint);
  }
}

void drawStrings(canvas, squareSize, paint) {
  double half = squareSize / 2;
  paint.color = Colors.amberAccent;
  for (double across = 0; across < 6; across++)
    canvas.drawLine(Offset(across * squareSize + half, half),
        Offset(across * squareSize + half, squareSize * 12.5), paint);
}

void drawCircles(across, squareSize, paint, canvas, week) {
  final data = [
    [5, 0, 7, 2, 10, 5],
    [7, 2, 9, 4, 0, 7],
    [8, 3, 10, 5, 1, 8],
    [10, 5, 0, 7, 3, 10],
    [0, 7, 2, 9, 5, 0],
    [1, 8, 3, 10, 6, 1],
    [3, 10, 5, 0, 8, 3],
  ];
  paint.style = PaintingStyle.fill;
  double fontsize = squareSize / 1.3;
  final textStyle = TextStyle(
    color: Colors.red,
    fontSize: 30,
  );
  final textStyle2 = TextStyle(
    color: Colors.white,
    fontSize: fontsize,
  );

  paint.color = Colors.red;

  int down = data[week][across.round()];
  canvas.drawOval(
    Rect.fromLTWH(
        squareSize * across, squareSize * down, squareSize, squareSize),
    paint,
  );

  TextSpan span2 = new TextSpan(text: down.toString(), style: textStyle2);
  TextPainter tp = new TextPainter(
      text: span2, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
  tp.text = span2;
  tp.layout();

  if (down < 10)
    tp.paint(
        canvas,
        new Offset(squareSize * across + (squareSize / 4),
            squareSize * down + squareSize / 15));
  else
    tp.paint(
        canvas,
        new Offset(squareSize * across + (squareSize / 35),
            squareSize * down + squareSize / 15));
  paint.style = PaintingStyle.stroke;
}

void drawMarkers(squareSize, paint, canvas) {
  final data = [3, 5, 7, 9, 12];
  paint.color = Colors.black;
  paint.style = PaintingStyle.fill;
  for (int i = 0; i < data.length - 1; i++) {
    canvas.drawOval(
      Rect.fromLTWH(squareSize * 2.75, squareSize * (data[i] - 0.25),
          squareSize / 2, squareSize / 2),
      paint,
    );
  }
  canvas.drawOval(
    Rect.fromLTWH(
        squareSize * 1.75,
        squareSize * (data[data.length - 1] - 0.25),
        squareSize / 2,
        squareSize / 2),
    paint,
  );
  canvas.drawOval(
    Rect.fromLTWH(
        squareSize * 3.75,
        squareSize * (data[data.length - 1] - 0.25),
        squareSize / 2,
        squareSize / 2),
    paint,
  );
  paint.style = PaintingStyle.stroke;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getScreenHeightSafe(BuildContext context) {
// Height (without SafeArea)
  var padding = MediaQuery.of(context).padding;
  return getScreenHeight(context) - padding.top - padding.bottom;
}

int weekDiff(int firstDay) {
  var now = DateTime.now();
  var hours = now.millisecondsSinceEpoch;
  int diff = firstDay - hours;

  diff = diff ~/ (1000 * 60 * 60); //minutes
  diff = diff ~/ (24 * 7); //weeks
  diff %= 7;

  return diff;
}

int dayDiff(int firstDay) {
  var now = DateTime.now();
  var hours = now.millisecondsSinceEpoch;
  int diff = firstDay - hours;

  diff = diff ~/ (1000 * 60 * 60); //minutes
  diff = diff ~/ (24); //days
  diff %= 7;
  print(diff);

  return diff;
}
