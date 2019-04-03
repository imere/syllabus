import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:schedule/services/service.dart' show voicesFs, selectedVoiceFs;
import 'package:schedule/utils/constants.dart' show DEFAULT_VOICE;
import 'package:schedule/utils/util.dart' show checkResourceValid;

class Ring extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RingState();
}

class _RingState extends State<Ring> {
  AudioCache _audioCache;
  AudioPlayer _audioPlayer;

  @override
  void initState() {
    String voice = checkResourceValid()
        ? voicesFs[selectedVoiceFs]
        : voicesFs[DEFAULT_VOICE];
    _audioCache = AudioCache();
    _audioCache.loop(voice).then((player) => _audioPlayer = player);
    super.initState();
  }

  @override
  void dispose() {
    if (_audioPlayer != null) {
      _audioPlayer.stop().then((result) => _audioPlayer.release());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('响铃'),
      content: Text('响铃'),
      actions: <Widget>[
        FlatButton(onPressed: () => Navigator.pop(context), child: Text('确定')),
      ],
    );
  }
}
