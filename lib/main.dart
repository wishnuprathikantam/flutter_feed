import 'package:flutter/material.dart';
import 'package:flutter_feed/provider/news.dart';
import './screens/settings.dart';
import './screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    child: MyApp(),
    create: (context) => News(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '0h News',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
      routes: {"/settings": (ctx) => Settings()},
    );
  }
}
