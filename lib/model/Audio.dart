
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Audio {
  int selected = 0;
  double volume =0.5;
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
  Audio(){
    player.setLoopMode(LoopMode.one);
  }

  void setVolume (){
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
    if (isPlaying)
      play(player, data[selected]);
  }

  Future<void> play(var player, var freq) async {
    player.setAsset('assets/' + freq + ".mp3");
    player.play(); // Usually you don't want to wait for playback to finish.
    //await player.seek(Duration(seconds: 10));
    //await player.pause();
  }
}