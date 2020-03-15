import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrefTile extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;
  PrefTile(
      {@required this.title, @required this.description, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xDDDDDDFF)))),
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  style: GoogleFonts.roboto(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                child //Child Widget
              ],
            ),
          ),
          Container(alignment: Alignment.centerLeft,
            child: Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(fontSize: 14,color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
