import 'dart:convert';

import 'package:clima/models/date.dart';
import 'package:clima/models/weather_day.dart';
import 'package:flutter/cupertino.dart';
import 'package:clima/models/location.dart';
import 'package:clima/models/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';

const apiKey = 'YOR API KEY HERE';
const openWeatherMapURL5Days =
    'https://api.openweathermap.org/data/2.5/forecast';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/onecall';

class WeatherDayData extends ChangeNotifier {
  bool loading = true;
  String country;
  String city;
  String lastUpdate;

  WeatherDayData() {
    setLastUpdate();
    getLocalData();
    getLocationWeather();
  }

  WeatherDay todayWeather = WeatherDay(
      currentWeather: Weather(20, 20, 10),
      morningWeather: Weather(20, 20, 10),
      eveningWeather: Weather(20, 20, 10),
      dayWeather: Weather(20, 20, 10),
      nightWeather: Weather(20, 20, 10),
      humidity: 10,
      uv: 10,
      pressure: 5,
      timeStamp: 500021);

  List<WeatherDay> weekWeather = [];
  int weeklyIndex = 0;
  void setWeeklyIndex(int index) {
    weeklyIndex = index;
    notifyListeners();
  }

  Future<void> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&exclude=minutely&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();

    NetworkHelper networkHelper5Days = NetworkHelper(
        '$openWeatherMapURL5Days?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

    var weatherData5Days = await networkHelper5Days.getData();

    if (weatherData != null && weatherData5Days != null) {
      setData(jsonDecode(weatherData), jsonDecode(weatherData5Days));
      storeLocal('weatherData', weatherData);
      storeLocal('weatherData5Days', weatherData5Days);
    }
    storeLocal('LastUpdate', getNowDate());
    lastUpdate = getNowDate();
    return;
  }

  void setData(var weatherData, var weatherData5Days) {
    country = weatherData5Days['city']['country'];
    city = weatherData5Days['city']['name'];

    todayWeather.currentWeather.temp =
        weatherData['current']['temp'].toDouble();
    todayWeather.currentWeather.cond =
        weatherData['current']['weather'][0]['id'];
    todayWeather.currentWeather.stamp = weatherData['current']['dt'];

    todayWeather.morningWeather.temp =
        weatherData['hourly'][3]['temp'].toDouble();
    todayWeather.morningWeather.cond =
        weatherData['hourly'][3]['weather'][0]['id'];
    todayWeather.morningWeather.stamp = weatherData['hourly'][3]['dt'];

    todayWeather.dayWeather.temp = weatherData['hourly'][9]['temp'] + .0;
    todayWeather.dayWeather.cond = weatherData['hourly'][9]['weather'][0]['id'];
    todayWeather.dayWeather.stamp = weatherData['hourly'][9]['dt'];

    todayWeather.nightWeather.temp =
        weatherData['hourly'][15]['temp'].toDouble();
    todayWeather.nightWeather.cond =
        weatherData['hourly'][15]['weather'][0]['id'];
    todayWeather.nightWeather.stamp = weatherData['hourly'][15]['dt'];

    todayWeather.windSpeed = weatherData['daily'][0]['wind_speed'].toDouble();
    todayWeather.humidity = weatherData['daily'][0]['humidity'];
    todayWeather.pressure = weatherData['daily'][0]['pressure'];
    todayWeather.uv = weatherData['daily'][0]['uvi'];

    int startIndex = 0;
    for (int i = 0; i < 40; i++) {
      if (getDate(weatherData5Days['list'][i]['dt']) ==
          getDate(weatherData['daily'][1]['dt'])) {
        startIndex = i;
        print(startIndex);
        break;
      }
    }

    weekWeather.clear();

    for (int i = startIndex; i < 40;) {
      weekWeather.add(WeatherDay(
        morningWeather: Weather(
            weatherData5Days['list'][i + 3]['main']['temp'].toDouble(),
            weatherData5Days['list'][i + 3]['weather'][0]['id'],
            weatherData5Days['list'][i + 3]['dt']),
        dayWeather: Weather(
            weatherData5Days['list'][i + 5]['main']['temp'].toDouble(),
            weatherData5Days['list'][i + 5]['weather'][0]['id'],
            weatherData5Days['list'][i + 5]['dt']),
        eveningWeather: Weather(
            weatherData5Days['list'][i + 7]['main']['temp'].toDouble(),
            weatherData5Days['list'][i + 7]['weather'][0]['id'],
            weatherData5Days['list'][i + 7]['dt']),
        nightWeather: Weather(
            weatherData5Days['list'][i + 8]['main']['temp'].toDouble(),
            weatherData5Days['list'][i + 8]['weather'][0]['id'],
            weatherData5Days['list'][i + 8]['dt']),
      ));

      i += 8;
      if (i + 8 >= 40) {
        break;
      }
    }

    for (int i = 0; i < weekWeather.length; i++) {
      weekWeather[i].uv = weatherData['daily'][i + 1]['uvi'];
      weekWeather[i].humidity = weatherData['daily'][i + 1]['humidity'];
      weekWeather[i].pressure = weatherData['daily'][i + 1]['pressure'];
      weekWeather[i].windSpeed =
          weatherData['daily'][i + 1]['wind_speed'].toDouble();
      weekWeather[i].currentWeather = Weather(
          weatherData['daily'][i + 1]['temp']['day'].toDouble(),
          weatherData['daily'][i + 1]['weather'][0]['id'],
          weatherData['daily'][i + 1]['dt']);
      weekWeather[i].minTemp =
          weatherData['daily'][i + 1]['temp']['min'].toDouble();
      weekWeather[i].maxTemp =
          weatherData['daily'][i + 1]['temp']['max'].toDouble();
    }

    loading = false;

    notifyListeners();
  }

  void getLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var weatherData = preferences.get('weatherData');
    var weatherData5Days = preferences.get('weatherData5Days');
    if (weatherData != null && weatherData5Days != null) {
      setData(jsonDecode(weatherData), jsonDecode(weatherData5Days));
    }
  }

  void storeLocal(String key, String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, data);
  }

  void setLastUpdate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String date = preferences.getString('LastUpdate');
    lastUpdate = date ?? '16/8/2020';
  }
}
