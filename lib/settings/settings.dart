import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/services/service.dart'
    show updateState$, prefFs, selectedVoiceFs, selectedColorFs;
import 'package:schedule/utils/constants.dart'
    show
        PREFS_SELECTED_VOICE,
        PREFS_CUSTOM_VOICE_PATH,
        MD_COLORS,
        PREFS_SELECTED_COLOR;
import 'package:schedule/utils/util.dart' show checkResourceValid, voiceVMap;
import 'package:toast/toast.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _groupVoiceKey;
  String _groupColor;

  void _saveSelectedVoice(String key, {String path}) {
    setState(() {
      if (path != null) {
        prefFs.setString(PREFS_CUSTOM_VOICE_PATH, key);
      }
      selectedVoiceFs = key;
      if (checkResourceValid()) {
        prefFs.setString(PREFS_SELECTED_VOICE, key);
      } else {
        return Toast.show('资源不可用', context, gravity: Toast.CENTER);
      }
    });
  }

  void _saveSelectedColor(String key) {
    setState(() {
      selectedColorFs = key;
      prefFs.setString(PREFS_SELECTED_COLOR, key);
    });
    updateState$.add(true);
  }

  @override
  void initState() {
    _groupVoiceKey = selectedVoiceFs;
    _groupColor = selectedColorFs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Text('响铃设置'),
              trailing: PopupMenuButton(
                initialValue: _groupVoiceKey,
                onSelected: (value) {
                  _groupVoiceKey = value;
                  _saveSelectedVoice(value);
                },
                child: Text('${voiceVMap[_groupVoiceKey]}'),
                itemBuilder: (ctx0) {
                  return voiceVMap.keys
                      .map((k) => PopupMenuItem(
                    value: k,
                    child: Text('${voiceVMap[k]}'),
                  ))
                      .toList();
                },
              ),
            ),
            ListTile(
              leading: Text('主题设置(重启生效)'),
              trailing: PopupMenuButton(
                initialValue: _groupColor,
                onSelected: (value) {
                  _groupColor = value;
                  _saveSelectedColor(value);
                },
                child: Text('$selectedColorFs'),
                itemBuilder: (ctx0) {
                  return MD_COLORS.keys
                      .map((k) => PopupMenuItem(
                            value: k,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: MD_COLORS[k]),
                              child: Text(
                                '$k',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))
                      .toList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
