class WeatherDay {
  Weather currentWeather;
  Weather morningWeather;
  Weather dayWeather;
  Weather eveningWeather;
  Weather nightWeather;
  double windSpeed;
  int humidity;
  int pressure;
  String cityName;
  String countryCode;
  double minTemp;
  double maxTemp;
  double uv;
  int timeStamp;

  WeatherDay(
      {this.currentWeather,
      this.morningWeather,
      this.dayWeather,
      this.eveningWeather,
      this.nightWeather,
      this.windSpeed,
      this.humidity,
      this.pressure,
      this.cityName,
      this.countryCode,
      this.minTemp,
      this.maxTemp,
      this.uv,
      this.timeStamp});
}

class Weather {
  double temp;
  int cond;
  int stamp;

  Weather(this.temp, this.cond, this.stamp);
}
