import 'package:flutter/foundation.dart';

class ConfigItem {
  final bool backgroundFetch;
  final int remindHour;
  final int remindMin;
  ConfigItem(
      {@required this.backgroundFetch,
      @required this.remindHour,
      @required this.remindMin});
}
