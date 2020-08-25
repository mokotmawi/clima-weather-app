import 'package:clima/Widgets/list_desc.dart';
import 'package:clima/models/date.dart';
import 'package:clima/models/weather_data_brain.dart';
import 'package:clima/models/weather_day_data.dart';
import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class WeeklyScreen extends StatefulWidget {
  @override
  _WeeklyScreenState createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weekly Chart',
          style: TextStyle(
              fontFamily: 'Gilroy',
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigation(),
      body: WeeklyWeather(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;

  List<BottomNavigationBarItem> getBottomItems() {
    WeatherDayData weatherData = Provider.of<WeatherDayData>(context);

    List<BottomNavigationBarItem> list = [];
    for (int i = 0; i < weatherData.weekWeather.length; i++) {
      list.add(BottomNavigationBarItem(
          icon: Icon(
            getWeatherIcon(
                weatherData.weekWeather[i].currentWeather.cond, false),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, top: 10.0),
            child: Text(getDay(weatherData.weekWeather[i].currentWeather.stamp)
                .substring(0, 2)),
          )));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherDayData>(
      builder: (context, weatherData, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: getBottomItems(),
          backgroundColor: Colors.white,
          currentIndex: selectedIndex,
          selectedItemColor: Color(0xFF48567B),
          unselectedItemColor: kColorGreyTranspernt,
          showUnselectedLabels: true,
          elevation: 0,
          iconSize: 20.0,
          selectedLabelStyle:
              TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
          onTap: (index) {
            setState(() {
              selectedIndex = index;
              Provider.of<WeatherDayData>(context, listen: false)
                  .setWeeklyIndex(index);
            });
          },
        );
      },
    );
  }
}

class WeeklyWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherDayData>(
      builder: (context2, weatherData, child) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    getWeatherIcon(
                        weatherData.weekWeather[weatherData.weeklyIndex]
                            .currentWeather.cond,
                        false),
                    size: 30.0,
                    color: kColorGrey,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    getDay(weatherData.weekWeather[weatherData.weeklyIndex]
                        .currentWeather.stamp),
                    style: kTextStyleMediumRegularBlack,
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '${weatherData.weekWeather[weatherData.weeklyIndex].maxTemp.round()}°',
                    style: kTextStyleMediumRegularBlack,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '${weatherData.weekWeather[weatherData.weeklyIndex].minTemp.round()}°',
                    style: kTextStyleMediumRegularGrey,
                  )
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListDesc(
                        mainText: 'Wind',
                        subText:
                            '${weatherData.weekWeather[weatherData.weeklyIndex].windSpeed.toStringAsFixed(0)} m/h',
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ListDesc(
                        mainText: 'Humidity',
                        subText:
                            '${weatherData.weekWeather[weatherData.weeklyIndex].humidity} %',
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListDesc(
                        mainText: 'Pressure',
                        subText:
                            '${weatherData.weekWeather[weatherData.weeklyIndex].pressure} hPa',
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ListDesc(
                        mainText: 'UV',
                        subText:
                            '${weatherData.weekWeather[weatherData.weeklyIndex].uv}',
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 60.0,
              ),
              ListWeeklyDetails(
                hour: '9',
                condition: getWeatherCond(weatherData
                    .weekWeather[weatherData.weeklyIndex].morningWeather.cond),
                tempreture:
                    '${weatherData.weekWeather[weatherData.weeklyIndex].morningWeather.temp.round()}°',
              ),
              SizedBox(
                height: 20.0,
              ),
              ListWeeklyDetails(
                hour: '15',
                condition: getWeatherCond(weatherData
                    .weekWeather[weatherData.weeklyIndex].dayWeather.cond),
                tempreture:
                    '${weatherData.weekWeather[weatherData.weeklyIndex].dayWeather.temp.round()}°',
              ),
              SizedBox(
                height: 20.0,
              ),
              ListWeeklyDetails(
                hour: '21',
                condition: getWeatherCond(weatherData
                    .weekWeather[weatherData.weeklyIndex].eveningWeather.cond),
                tempreture:
                    '${weatherData.weekWeather[weatherData.weeklyIndex].eveningWeather.temp.round()}°',
              ),
              SizedBox(
                height: 20.0,
              ),
              ListWeeklyDetails(
                hour: '0',
                condition: getWeatherCond(weatherData
                    .weekWeather[weatherData.weeklyIndex].nightWeather.cond),
                tempreture:
                    '${weatherData.weekWeather[weatherData.weeklyIndex].nightWeather.temp.round()}°',
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        );
      },
    );
  }
}

class ListWeeklyDetails extends StatelessWidget {
  ListWeeklyDetails({this.hour, this.condition, this.tempreture});

  final String hour;
  final String condition;
  final String tempreture;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          hour,
          style: kTextStyleCardHour.copyWith(color: Colors.black),
        ),
        SizedBox(
          width: 30.0,
        ),
        Text(
          condition,
          style: kTextStyleMediumRegularBlack,
        ),
        Expanded(
          child: SizedBox(),
        ),
        Text(
          tempreture,
          style: kTextStyleMediumRegularBlack,
        )
      ],
    );
  }
}
