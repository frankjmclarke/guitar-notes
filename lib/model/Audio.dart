import 'package:delme/infra/PubSubClass.dart';
import 'package:local_pubsub/local_pubsub.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Audio {
  static final Audio shared = Audio._();

  Audio._() {
    player.setLoopMode(LoopMode.one);
    Subscription? sub = PubSubClass.shared.subscribe('buttonPress');
    if (sub==null)
      print("SUB NULL ");
    sub?.stream?.listen((index) {
      //print("MESSAGE " + index.toString() + " " + prev.toString());
      selected = index;
      //if (prev != ind) {
      playDifferentNote();
      //}
      prev = index;
    });
    Subscription? sub2 = PubSubClass.shared.subscribe('changeSound');
    sub2?.stream?.listen((index) {
      print("changeSound " + index.toString());
      if (index == "toggle")
        toggleSound();
      else if (index == "decrease") {
        if (volume > 0.05) {
          volume -= 0.1;
          //saveVolume(audio.volume);
          setVolume();
        }
      } else if (index == "increase") {
        if (volume < 0.95) {
          volume += 0.1;
          //saveVolume(audio.volume);
          setVolume();
        }
      }
      //setCounter(audio.selected);
    });
  }

  int selected = 0;
  double volume = 0.5;
  final player = AudioPlayer(
    userAgent: 'myradioapp/1.0 (Linux;Android 11) https://myradioapp.com',
  );
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  bool isPlaying = false;
  final data = [
    "220_",
    "246_94",
    "261_63",
    "293_66",
    "329_63",
    "349_23",
    "392_"
  ];
  int prev = -1;

  void setVolume() {
    player.setVolume(volume);
  }

  void toggleSound() {
    if (isPlaying && player.playing)
      player.stop();
    else {
      play(player, data[selected]);
    }
    isPlaying = !isPlaying;
  }

  void playDifferentNote() {
    if (isPlaying) play(player, data[selected]);
  }

  Future<void> play(var player, var freq) async {
    player.setAsset('assets/' + freq + ".mp3");
    player.play(); // Usually you don't want to wait for playback to finish.
    //await player.seek(Duration(seconds: 10));
    //await player.pause();
  }
}