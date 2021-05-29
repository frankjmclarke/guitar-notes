import 'package:delme/model/Audio.dart';
import 'package:delme/ui/CustomRadio.dart';
import 'package:flutter/material.dart';
import 'package:local_pubsub/local_pubsub.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FingerboardPainter.dart';

class Tuner extends StatefulWidget {
  Tuner({Key? key}) : super(key: key);

  @override
  TunerState createState() => new TunerState();
}

class TunerState extends State<Tuner> {
  var audio = new Audio();
  PubSub pubsub = PubSub();

  List<RadioModel> radioData = <RadioModel>[]; //List<RadioModel>();
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  bool _alreadySaved = false;

  int prev = -1;

  Future<Null> getData() async {
    final SharedPreferences prefs = await _sprefs;
    int data = prefs.getInt('firstDay') ?? 0;
    print("index " + data.toString());
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
      print("index set " + index.toString());
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
    radioData.add(new RadioModel(false, 'A', 0, pubsub));
    radioData.add(new RadioModel(false, 'B', 1, pubsub));
    radioData.add(new RadioModel(false, 'C', 2, pubsub));
    radioData.add(new RadioModel(false, 'D', 3, pubsub));
    radioData.add(new RadioModel(false, 'E', 4, pubsub));
    radioData.add(new RadioModel(false, 'F', 5, pubsub));
    radioData.add(new RadioModel(false, 'G', 6, pubsub));
    Subscription? sub = pubsub.subscribe('buttonPress');
    sub?.stream?.listen((index) {
      print("MESSAGE " + index.toString() + " " + prev.toString());
      audio.selected = index;
      //if (prev != ind) {
      audio.playDifferentNote();
      //}
      prev = index;
    });
    Subscription? sub2 = pubsub.subscribe('changeSound');
    sub2?.stream?.listen((index) {
      if (index == "toggle")
        audio.toggleSound();
      else if (index == "decrease") {
        if (audio.volume > 0.05) {
          audio.volume -= 0.1;
          saveVolume(audio.volume);
          audio.setVolume();
        }
      }
      else if (index == "increase") {
        if (audio.volume < 0.95) {
          audio.volume += 0.1;
          saveVolume(audio.volume);
          audio.setVolume();
        }
      }
      setCounter(audio.selected);
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;

    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Learn the Neck Tuner"),
      ),
      body: SafeArea(
        child: IntrinsicHeight(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: deviceHeight * 0.95,
                  width: deviceWidth * 0.80,
                  child: guitarNeck(pubsub), //max horizontal in row
                ),
                Container(
                  child: Column(
                    children: [
                      radButton(pubsub),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: IconButton(
                          icon: Icon(Icons.volume_up),
                          onPressed: () {
                            pubsub.publish('changeSound',
                                "decrease"); //decoupled
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: IconButton(
                          icon: Icon(Icons.volume_down),
                          onPressed: () {
                            pubsub.publish('changeSound',
                                "increase"); //decoupled
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: IconButton(
                          icon: new Icon(
                            _alreadySaved ? Icons.stop : Icons.play_arrow,
                            color: _alreadySaved ? null : Colors.red,
                          ),
                          onPressed: () =>
                              setState(() {
                                pubsub.publish(
                                    'changeSound', "toggle"); //decoupled
                                _alreadySaved = !_alreadySaved;
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Container radButton(var pubsub) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHeight * 0.5,
      width: 50,
      child: new ListView.builder(
        itemCount: radioData.length,
        itemBuilder: (BuildContext context, int index) {
          //print("ListView.builder " +              index.toString() +              " " +              radioData[index].isSelected.toString());
          return new InkWell(
            highlightColor: Colors.lightBlueAccent,
            splashColor: Colors.blueAccent,
            onTap: () {
              setState(() {
                print("setState "+index.toString());
                radioData.forEach((element) => element.isSelected = false);
                radioData[index].isSelected = true;
                pubsub?.publish('buttonPress', index);//decoupled
              });
              setCounter(index);
            },
            child: new RadioItem(radioData[index]),
          );
        },
      ),
    );
  }
  IntrinsicHeight guitarNeck(pubsub) {
    return IntrinsicHeight(
      //sizes its child to the child's intrinsic height.
      child: CustomPaint(painter: FingerboardPainter(audio.selected)),//get initted 8 times for each keypress
    );
  }
}