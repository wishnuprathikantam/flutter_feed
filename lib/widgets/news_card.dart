import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String preview;
  final String source;
  final String date;
  final Function onTap;

  NewsCard(
      {@required this.title,
      @required this.preview,
      @required this.source,
      @required this.date,
      @required this.onTap});

  final _captionStyle =
      GoogleFonts.roboto(color: Colors.black38, fontWeight: FontWeight.bold);

  String _readableDate(String dateStr) {
    var whiteSpace = " ";
    var initial = dateStr.split(",");
    var dateString =
        initial.skip(1).first.split(whiteSpace).skip(1).take(3).join("/");
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.jpg',
                        image: preview),
                  ),
                  Spacer(),
                  Expanded(
                      flex: 13,
                      child: Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 12,
                      child: Text(
                        _readableDate(date),
                        style: _captionStyle,
                      )),
                  Chip(
                      backgroundColor: Color(0xEEEEEEFF),
                      label: Text(
                        source,
                        style: _captionStyle,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
