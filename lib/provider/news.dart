import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_feed/models/config_item.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:xml/xml.dart' as xml;
import '../models/news_item.dart';

class News with ChangeNotifier {
  static const _serviceUrl = "https://news.yahoo.com/rss/entertainment";
  static const _platformChannel = const MethodChannel('feed_news');

  //Methods
  static const _reminderHour = "reminderHour";
  static const _reminderMin = "reminderMin";
  static const _backgroundFetch = "backgroundFetch";
  static const _offlineData = "offlineData";
  static const _saveSettings = "saveSettings";
  static const _setReminder = "scheduleReminder";

  var _logger = Logger();
  List<NewsItem> _items = [];
  ConfigItem _config =
      ConfigItem(backgroundFetch: false, remindHour: 0, remindMin: 0);

  ConfigItem get config {
    return _config;
  }

  List<NewsItem> get items {
    return [..._items];
  }

  Future<void> getConfig() async {
    try {
      bool bgFetch = await _platformChannel.invokeMethod(_backgroundFetch);
      int rHour = await _platformChannel.invokeMethod(_reminderHour);
      int rMin = await _platformChannel.invokeMethod(_reminderMin);
      _config = ConfigItem(
          backgroundFetch: bgFetch, remindHour: rHour, remindMin: rMin);
    } on PlatformException catch (e) {
      _logger.e(e);
    }
    notifyListeners();
  }

  Future<void> saveSettings(bool bgFetch, int rMin, int rHour) async {
    try {
      await _platformChannel.invokeMethod(
          _saveSettings, {"bg": bgFetch, "rhour": rHour, "rmin": rMin});
      await _setRemainder();
    } on PlatformException catch (e) {
      _logger.e(e);
    }
    notifyListeners();
  }

  Future<bool> getOfflineData() async {
    try {
      String data = await _platformChannel.invokeMethod(_offlineData);
      if (data.isNotEmpty) {
        var jsonData = jsonDecode(data);
        if (jsonData != null) {
          final listOfItems = (jsonData as List).map((item) {
            return NewsItem(
                headline: item['headline'] as String,
                preview: item['preview'] as String,
                source: item['source'] as String,
                date: item['date'] as String,
                link: item['link'] as String);
          }).toList();
          _logger.i(
              "Loaded Offline Items => ${listOfItems.map((ni) => ni.headline)}");
          _items = listOfItems;
          return true;
        } else {
          _logger.i("Json is null");
          return false;
        }
      } else {
        _logger.i("Got empty data");
        return false;
      }
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> refresh() async {
    _items.clear();

    notifyListeners();
    _logger.i("Cleared Old Items => ${_items.length}");
    return fetchNews().catchError((onError) {
      _logger.e(onError);
      throw onError;
    });
  }

  Future<void> _setRemainder() async {
    try {
      await _platformChannel.invokeMethod(_setReminder);
    } on PlatformException catch (e) {
      _logger.e(e);
    }
  }

  Future<void> fetchNews() async {
    final response = await http.get(_serviceUrl);
    final xmlParser = xml.parse(response.body);

    //Parse XML
    final newsData = xmlParser.findAllElements("item").map((node) {
      final title = node
          .findElements("title")
          .map((subNode) => subNode.text)
          .firstWhere((c) => c.isNotEmpty);

      final preview = node
          .findElements("media:content")
          .map((subNode) => subNode.getAttribute("url"))
          .firstWhere((c) => c.isNotEmpty);

      final date = node
          .findElements("pubDate")
          .map((subNode) => subNode.text)
          .firstWhere((c) => c.isNotEmpty);

      final link = node
          .findElements("link")
          .map((subNode) => subNode.text)
          .firstWhere((c) => c.isNotEmpty);

      final source = node
          .findElements("source")
          .map((subNode) => subNode.text)
          .firstWhere((c) => c.isNotEmpty);

      _logger.d("Parsed Item => $title");

      return NewsItem(
          headline: title,
          preview: preview,
          source: source,
          date: date,
          link: link);
    });
    _items.addAll(newsData);
    notifyListeners();
  }
}
