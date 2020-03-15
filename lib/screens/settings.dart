import 'package:flutter/material.dart';
import '../widgets/pref-alert.dart';
import 'package:provider/provider.dart';
import '../widgets/page.dart';
import '../widgets/pref_tile.dart';
import '../provider/news.dart';
import 'package:logger/logger.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TimeOfDay setTime;
  bool changeFlag = false;
  bool backgroundFetch;
  var message = "";
  var color = Colors.black87;
  var _logger = Logger();
  IconData icon;

  @override
  void didChangeDependencies() {
    final configProvider = Provider.of<News>(context, listen: false);
    _refreshConfig(configProvider);
    super.didChangeDependencies();
  }

  void _refreshConfig(News provider) {
    provider.getConfig().catchError((onError) {
      _logger.e(onError);
    });
  }

  void _stageChanges() {
    setState(() {
      changeFlag = true;
      color = Colors.red;
      message = "You have unsaved Changes";
      icon = Icons.warning;
    });
  }

  void _saveChanges(News configProvider) {
    bool bg = (backgroundFetch) ?? configProvider.config.backgroundFetch;
    int rMin = (setTime?.minute) ?? configProvider.config.remindMin;
    int rHour = (setTime?.hour) ?? configProvider.config.remindHour;

    configProvider.saveSettings(bg, rMin, rHour).then((onValue) {
      _logger.i("Saved");
      setState(() {
        changeFlag = true;
        color = Colors.green;
        message = "Saved Changes";
        icon = Icons.done;
        _refreshConfig(configProvider);
      });
    }).catchError((onError) {
      _logger.i(onError);
      setState(() {
        changeFlag = true;
        color = Colors.red;
        message = "Unable to save settings, try later.";
        icon = Icons.done;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<News>(context);
    final configItem = configProvider.config;

    return Page(
        title: "PREFERENCES",
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                PrefAlert(message: message, icon: icon, color: color),
                Divider(),
                PrefTile(
                  title: "Background Fetch",
                  description:
                      "Fetch news in the background while your mobile is on charging.",
                  child: Switch(
                      value: configItem.backgroundFetch ?? false,
                      onChanged: (v) {
                        backgroundFetch = v;
                        _stageChanges();
                      }),
                ),
                PrefTile(
                    title: "Set Remainder",
                    description:
                        "Reminds you to check news on saved time everyday.",
                    child: FlatButton(
                        onPressed: () {
                          var time = DateTime.now();
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(
                                      hour: configItem.remindHour > 0
                                          ? configItem.remindHour
                                          : time.hour,
                                      minute: configItem.remindMin > 0
                                          ? configItem.remindMin
                                          : time.minute))
                              .then((onValue) {
                            setTime = onValue;
                            _stageChanges();
                          });
                        },
                        child: Text(
                            "Change ${configItem.remindHour > 0 ? configItem.remindHour : "00"} : ${configItem.remindMin > 0 ? configItem.remindMin : "00"}"))),
                Padding(
                  padding: EdgeInsets.all(15),
                ),
                FlatButton(
                    onPressed:
                        changeFlag ? () => _saveChanges(configProvider) : null,
                    color: Colors.amber,
                    child: Text("Save Changes"))
              ],
            ),
          ),
        ));
  }
}
