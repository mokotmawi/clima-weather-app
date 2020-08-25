import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';

class ListDesc extends StatelessWidget {
  ListDesc({this.mainText, this.subText});

  final String mainText;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(mainText, style: kTextStyleRegularBlack),
        SizedBox(
          width: 20.0,
        ),
        Text(subText, style: kTextStyleRegularGrey),
      ],
    );
  }
}
