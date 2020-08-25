import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';


class WeatherCard extends StatelessWidget {
  WeatherCard(
      {this.icon, this.hour, this.tempreture, this.cardBackgroundColor});

  final IconData icon;
  final String hour;
  final String tempreture;
  final Color cardBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: cardBackgroundColor,
      ),
      child: Column(
        children: <Widget>[
          Text(hour, style: kTextStyleCardHour),
          SizedBox(
            height: 25.0,
          ),
          Icon(
            icon,
            size: 35.0,
            color: Colors.white,
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(tempreture, style: kTextStyleCardHour),
        ],
      ),
    );
  }
}