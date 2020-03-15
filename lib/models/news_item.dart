import 'package:flutter/foundation.dart';

class NewsItem {
  final String headline;
  final String preview;
  final String link;
  final String date;
  final String source;
  NewsItem(
      {@required this.headline,
      @required this.preview,
      @required this.link,
      @required this.date,
      @required this.source});
}
