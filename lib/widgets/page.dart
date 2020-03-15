import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Page extends StatelessWidget {
  final Widget child;
  final String title;
  Page({@required this.child, @required this.title});

  List<Widget> _actionList(BuildContext context) {
    final currentRoute = ModalRoute.of(context).settings.name;
    final conditionedList = [
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          Navigator.of(context).pushNamed("/settings");
        },
      )
    ];
    return currentRoute == '/' ? conditionedList : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
          ),
          actions: _actionList(context),
        ),
        backgroundColor: Color(0XECECEEFF),
        body: SafeArea(
          minimum: EdgeInsets.all(10),
          child: child,
        ));
  }
}
