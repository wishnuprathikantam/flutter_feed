import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Empty extends StatelessWidget {
  final Function onRefresh;
  Empty({@required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/list.png',
              width: 250,
            ),
            Text(
              "REFRESH FAILED",
              style: GoogleFonts.oswald(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black26),
            ),
            Text(
              "Check your connection and try again",
              style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
            FlatButton(
              color: Colors.amber,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: onRefresh,
              child: Text("Try Again"),
            )
          ],
        ));
  }
}
