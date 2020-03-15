import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SyncMessage extends StatelessWidget {
  
  final message;
  
  SyncMessage({@required this.message});

  @override
  Widget build(BuildContext context) {
    return message.isNotEmpty ? Container(
      margin: EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(8),
          color: Color.fromRGBO(66, 66, 66, 0.2),
          child: Text(
            message.toUpperCase(),
            style: GoogleFonts.oswald(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black38),
          ),
        ),
      ),
    ): Padding(padding: EdgeInsets.all(1),);
  }
}
