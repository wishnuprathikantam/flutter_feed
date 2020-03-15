import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class PrefAlert extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;
  PrefAlert(
      {@required this.message, @required this.icon, @required this.color});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: color,
        ),
        Text(message,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold, color: color, fontSize: 15))
      ],
    );
  }
}
