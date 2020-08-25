import 'package:clima/Widgets/list_desc.dart';
import 'package:clima/Widgets/weather_card.dart';
import 'package:clima/models/date.dart';
import 'package:clima/models/weather_data_brain.dart';
import 'package:clima/models/weather_day_data.dart';
import 'package:clima/screens/weekly_screen.dart';
import 'package:clima/utilities/constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather Forecast',
          style: TextStyle(
              fontFamily: 'Gilroy',
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: DaysWeather(),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavHome(),
    );
  }
}

class BottomNavHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            FontAwesomeIcons.home,
            size: 20.0,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          'Home',
          style: kTextStyleRegularBlack,
        ),
        Expanded(
          child: SizedBox(),
        ),
        FlatButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return WeeklyScreen();
            }));
          },
          child: Icon(
            FontAwesomeIcons.cloudSunRain,
            size: 20.0,
            color: kColorGrey,
          ),
        ),
      ],
    );
  }
}

class DaysWeather extends StatefulWidget {
  @override
  _DaysWeatherState createState() => _DaysWeatherState();
}

class _DaysWeatherState extends State<DaysWeather> {
  void _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No Internet connection',
            style: kTextStyleSmallGrey.copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  void _checkGPS() async {
    bool gpsOn = await Geolocator().isLocationServiceEnabled();
    if (!gpsOn) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please Turn On GPS',
            style: kTextStyleSmallGrey.copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _checkGPS();
  }

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    void _onRefresh() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No Internet connection',
              style: kTextStyleSmallGrey.copyWith(color: Colors.white),
            ),
          ),
        );
        _refreshController.refreshFailed();
      } else {
        await Provider.of<WeatherDayData>(context, listen: false)
            .getLocationWeather();
        _refreshController.refreshCompleted();
      }
      bool gpsOn = await Geolocator().isLocationServiceEnabled();
      if (!gpsOn) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please Turn On GPS and Try Again',
              style: kTextStyleSmallGrey.copyWith(color: Colors.white),
            ),
          ),
        );
      }
    }

    if (Provider.of<WeatherDayData>(context).loading) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: kColorMorning,
      ));
    } else {
      return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        header: WaterDropHeader(),
        physics: BouncingScrollPhysics(),
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(15),
          children: <Widget>[
            Icon(
              getWeatherIcon(
                  Provider.of<WeatherDayData>(context)
                      .todayWeather
                      .currentWeather
                      .cond,
                  isNight(getHour(Provider.of<WeatherDayData>(context)
                      .todayWeather
                      .currentWeather
                      .stamp))),
              size: 60.0,
              color: getTimeColor(getHour(Provider.of<WeatherDayData>(context)
                  .todayWeather
                  .currentWeather
                  .stamp)),
            ),
            SizedBox(
              height: 10.0,
              width: double.infinity,
            ),
            Text(
                '${Provider.of<WeatherDayData>(context).todayWeather.currentWeather.temp.round()}°',
                textAlign: TextAlign.center,
                style: kTextStyleTitle),
            Text(
                '${Provider.of<WeatherDayData>(context).city}, ${Provider.of<WeatherDayData>(context).country}',
                textAlign: TextAlign.center,
                style: kTextStyleTitle2),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: WeatherCard(
                    tempreture:
                        '${Provider.of<WeatherDayData>(context).todayWeather.morningWeather.temp.round()}°',
                    hour: getHourAndMinutes(Provider.of<WeatherDayData>(context)
                        .todayWeather
                        .morningWeather
                        .stamp),
                    cardBackgroundColor: getTimeColor(getHour(
                        Provider.of<WeatherDayData>(context)
                            .todayWeather
                            .morningWeather
                            .stamp)),
                    icon: getWeatherIcon(
                        Provider.of<WeatherDayData>(context)
                            .todayWeather
                            .currentWeather
                            .cond,
                        isNight(getHour(Provider.of<WeatherDayData>(context)
                            .todayWeather
                            .morningWeather
                            .stamp))),
                  ),
                ),
                Expanded(
                  child: WeatherCard(
                    tempreture:
                        '${Provider.of<WeatherDayData>(context).todayWeather.dayWeather.temp.round()}°',
                    hour: getHourAndMinutes(Provider.of<WeatherDayData>(context)
                        .todayWeather
                        .dayWeather
                        .stamp),
                    cardBackgroundColor: getTimeColor(getHour(
                        Provider.of<WeatherDayData>(context)
                            .todayWeather
                            .dayWeather
                            .stamp)),
                    icon: getWeatherIcon(
                        Provider.of<WeatherDayData>(context)
                            .todayWeather
                            .dayWeather
                            .cond,
                        isNight(getHour(Provider.of<WeatherDayData>(context)
                            .todayWeather
                            .dayWeather
                            .stamp))),
                  ),
                ),
                Expanded(
                  child: WeatherCard(
                    tempreture:
                        '${Provider.of<WeatherDayData>(context).todayWeather.nightWeather.temp.round()}°',
                    hour: getHourAndMinutes(Provider.of<WeatherDayData>(context)
                        .todayWeather
                        .nightWeather
                        .stamp),
                    cardBackgroundColor: getTimeColor(getHour(
                        Provider.of<WeatherDayData>(context)
                            .todayWeather
                            .nightWeather
                            .stamp)),
                    icon: getWeatherIcon(
                        Provider.of<WeatherDayData>(context)
                            .todayWeather
                            .nightWeather
                            .cond,
                        isNight(getHour(Provider.of<WeatherDayData>(context)
                            .todayWeather
                            .nightWeather
                            .stamp))),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Text('Additional Info', style: kTextStyleSubTitle),
            SizedBox(
              height: 20.0,
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
                          '${Provider.of<WeatherDayData>(context).todayWeather.windSpeed} km/h',
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListDesc(
                      mainText: 'Humidity',
                      subText:
                          '${Provider.of<WeatherDayData>(context).todayWeather.humidity} %',
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
                          '${Provider.of<WeatherDayData>(context).todayWeather.pressure} hPa',
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListDesc(
                      mainText: 'UV',
                      subText:
                          '${Provider.of<WeatherDayData>(context).todayWeather.uv}',
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'last update ${Provider.of<WeatherDayData>(context).lastUpdate}',
              style: kTextStyleSmallGrey,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
  }
}
