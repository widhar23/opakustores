import 'package:flutter/material.dart';

class IconOpaku extends StatelessWidget {
  IconOpaku({this.textSize});
  final double textSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'O',
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w900,
            color: Colors.yellow.shade700,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'PAKU',
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
