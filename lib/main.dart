import 'package:clima/models/weather_day_data.dart';
import 'package:clima/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherDayData(),
      child: MaterialApp(
        home: HomeScreen(),
        theme: ThemeData(fontFamily: 'Gilroy'),
      ),
    );
  }
}
