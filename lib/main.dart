import 'package:delme/ui/CustomRadio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/Audio.dart';
import 'ui/FingerboardPainter.dart';
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
  var audio = new Audio();
  List<RadioModel> radioData = <RadioModel>[]; //List<RadioModel>();
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();

  Future<Null> getData() async {
    final SharedPreferences prefs = await _sprefs;
    int data = prefs.getInt('firstDay') ?? 0;
    print ("index "+data.toString());
    this.setState(() {
      audio.selected = data;
      radioData[audio.selected].isSelected = true;
    });
  }

  Future<Null> setCounter(int index) async {
    final SharedPreferences prefs = await _sprefs;
    setState(() {
      audio.selected = index;
      prefs.setInt('firstDay', audio.selected);
      print ("index set "+index.toString());
    });
  }

  Future<Null> saveVolume(double vol) async {
    final SharedPreferences prefs = await _sprefs;
    setState(() {
      prefs.setDouble('volume', vol);
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await audio.player.dispose();
  }

  @override
  void initState() {
    super.initState();
    radioData.add(new RadioModel(false, 'A'));
    radioData.add(new RadioModel(false, 'B'));
    radioData.add(new RadioModel(false, 'C'));
    radioData.add(new RadioModel(false, 'D'));
    radioData.add(new RadioModel(false, 'E'));
    radioData.add(new RadioModel(false, 'F'));
    radioData.add(new RadioModel(false, 'G'));
    getData();
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
              Expanded(child: GuitarNeck()), //max horizontal in row
              Column(
                children: [
                  Container(
                    height: 250,
                    width: 50,
                    child: new ListView.builder(
                      itemCount: radioData.length,
                      itemBuilder: (BuildContext context, int index) {
                        print("ListView.builder " + index.toString() + " "+ radioData[index].isSelected.toString());
                        return new InkWell(
                          highlightColor: Colors.lightBlueAccent,
                          splashColor: Colors.blueAccent,
                          onTap: () {
                            setState(() {
                              radioData
                                  .forEach((element) => element.isSelected = false);
                              radioData[index].isSelected = true;
                            });
                            audio.selected = index;
                            setCounter(index);
                            audio.playDifferentNote();
                          },
                          child: new RadioItem(radioData[index]),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () {
                        if (audio.volume < 0.95) {
                          audio.volume += 0.1;
                          saveVolume(audio.volume);
                          audio.setVolume();
                        }

                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                      icon: Icon(Icons.volume_down),
                      onPressed: () {
                        if (audio.volume > 0.05) {
                          audio.volume -= 0.1;
                          saveVolume(audio.volume);
                          audio.setVolume();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: fab,
        onPressed: () => setState(() {

          setCounter(audio.selected);
          audio.playNote();
          if (fabIconNumber == 0) {
            fab = Icon(
              Icons.stop,
            );
            fabIconNumber = 1;
          } else {
            fab = Icon(Icons.play_arrow);
            fabIconNumber = 0;
          }
        }),
        tooltip: 'Increment',
      ),
    );
  }

  Icon fab = Icon(
    Icons.play_arrow,
  );

  int fabIconNumber = 0;

  IntrinsicHeight GuitarNeck() {
    return IntrinsicHeight(
      //sizes its child to the child's intrinsic height.
      child: CustomPaint(painter: FingerboardPainter(audio.selected)),
    );
  }
}
