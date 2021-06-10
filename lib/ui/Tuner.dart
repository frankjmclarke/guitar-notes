import 'package:delme/infra/PubSubClass.dart';
import 'package:delme/model/Audio.dart';
import 'package:delme/ui/CustomRadio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FingerboardPainter.dart';

class Tuner extends StatefulWidget {
  Tuner({Key? key}) : super(key: key);

  @override
  TunerState createState() => new TunerState();
}

class TunerState extends State<Tuner> {

  List<RadioModel> radioData = <RadioModel>[];
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  bool _alreadySaved = false;

  int prev = -1;
  int selected = -1;

  Future<Null> getData() async {
    final SharedPreferences prefs = await _sprefs;
    int data = prefs.getInt('firstDay') ?? 0;
    print("index " + data.toString());
    this.setState(() {
      Audio.shared.selected = data;
      radioData[Audio.shared.selected].isSelected = true;
    });
  }

  Future<Null> setCounter(int index) async {
    final SharedPreferences prefs = await _sprefs;
    setState(() {
      Audio.shared.selected = index;
      prefs.setInt('firstDay', Audio.shared.selected);
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
    await Audio.shared.player.dispose();
  }

  @override
  void initState() {
    super.initState();
    radioData.add(new RadioModel(false, 'A', 0));
    radioData.add(new RadioModel(false, 'B', 1));
    radioData.add(new RadioModel(false, 'C', 2));
    radioData.add(new RadioModel(false, 'D', 3));
    radioData.add(new RadioModel(false, 'E', 4));
    radioData.add(new RadioModel(false, 'F', 5));
    radioData.add(new RadioModel(false, 'G', 6));
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

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
                  child: guitarNeck(), //max horizontal in row
                ),
                Container(
                  child: Column(
                    children: [
                      radButton(),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: IconButton(
                          icon: Icon(Icons.volume_up),
                          onPressed: () {
                            PubSubClass.shared.publish('changeSound', "decrease"); //decoupled
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: IconButton(
                          icon: Icon(Icons.volume_down),
                          onPressed: () {
                            PubSubClass.shared.publish('changeSound', "increase"); //decoupled
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
                            onPressed: () {
                              print("onPressed " );
                              PubSubClass.shared.publish("changeSound", "toggle"); //decoupled
                              _alreadySaved = !_alreadySaved;
                            }),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Container radButton() {
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
              buttonPress(index);
            },
            child: new RadioItem(radioData[index]),
          );
        },
      ),
    );
  }

  void buttonPress(int index) {
    setState(() {
      print("setState " + index.toString());
      radioData.forEach((element) => element.isSelected = false);
      radioData[index].isSelected = true;
      PubSubClass.shared.publish('buttonPress', index); //decoupled
    });
    setCounter(index);
  }

  IntrinsicHeight guitarNeck() {
    return IntrinsicHeight(
      //sizes its child to the child's intrinsic height.
      child: CustomPaint(painter: FingerboardPainter(Audio.shared.selected)),
    );
  }
}
