import 'package:flutter/material.dart';
import 'package:flutter_feed/widgets/empty.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/news_card.dart';
import '../widgets/page.dart';
import '../widgets/sync.dart';
import '../provider/news.dart';
import '../models/news_item.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isFirstLoad = true;
  var isLoading = false;
  var _logger = Logger();
  var syncMessage = "";

  @override
  void didChangeDependencies() {
    var provider = Provider.of<News>(context, listen: false);
    provider.getConfig().catchError((onError) {
      _logger.i(onError);
    }).then((onValue) {
      if (isFirstLoad) {
        if (provider.config.backgroundFetch) {
          _getFromOffline(provider);
        } else {
          _invokeFetch(provider);
        }
      }
    });

    super.didChangeDependencies();
  }

  void _getFromOffline(News provider) {
    isLoading = true;
    provider.getOfflineData().catchError((onError) {
      _logger.e("Some Error => $onError");
        setState(() {
        syncMessage = "";
      });
    }).then((onValue) {
      setState(() {
        isLoading = false;
        syncMessage = "Offline";
      });
      _logger.i("Loaded Offline -> $syncMessage");
    });
    isFirstLoad = false;
  }

  void _invokeFetch(News provider) {
    isLoading = true;
    provider.fetchNews().catchError((onError) {
       _logger.e(onError);
      setState(() {
        syncMessage = "";
      });
    }).then((_) {
      setState(() {
        isLoading = false;
        syncMessage = "Online";
      });
      _logger.i("Fetch Complete. -> $syncMessage");
    });
    isFirstLoad = false;
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _logger.e("Could not launch $url");
      throw 'Could not launch $url';
    }
  }

  Widget _mainContent(List<NewsItem> items, News provider) {
    if (items.length > 0) {
      return _listContent(items);
    } else if (isLoading) {
      return _showLoading();
    } else {
      return _noContent(provider);
    }
  }

  Widget _showLoading() {
    return Expanded(
        child: Center(
            child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text("REFRESHING",
              style: GoogleFonts.oswald(
                  fontWeight: FontWeight.bold, color: Colors.black45)),
        )
      ],
    )));
  }

  Widget _noContent(News provider) {
    return Empty(
      onRefresh: () => _invokeFetch(provider),
    );
  }

  Widget _listContent(List<NewsItem> items) {
    return Expanded(
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, index) {
            return NewsCard(
              source: items[index].source,
              date: items[index].date,
              onTap: () {
                _launchURL(items[index].link);
              },
              title: items[index].headline,
              preview: items[index].preview,
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<News>(context);
    final items = newsProvider.items;
    return RefreshIndicator(
      onRefresh: () {
        isLoading = true;
        return newsProvider.refresh().catchError((onError) {
          //print(onError);
          setState(() {
            isLoading = false;
          });
        }).then((_) {
          setState(() {
            isLoading = false;
            syncMessage = "Online";
          });
          print("Refresh Complete.");
        });
      },
      child: Page(
          //child: Empty(),
          child: Column(
            children: <Widget>[
              SyncMessage(
                message: syncMessage,
              ),
              _mainContent(items, newsProvider),
              //_content(items)
            ],
          ),
          title: "OH NEWS"),
    );
  }
}
