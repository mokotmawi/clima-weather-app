import 'package:clima/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

IconData getWeatherIcon(int condition, bool night) {
  if (night) {
    if (condition < 300) {
      return FontAwesomeIcons.bolt;
    } else if (condition < 400) {
      return FontAwesomeIcons.cloudSunRain;
    } else if (condition < 600) {
      return FontAwesomeIcons.cloudShowersHeavy;
    } else if (condition < 700) {
      return FontAwesomeIcons.solidSnowflake;
    } else if (condition < 800) {
      return FontAwesomeIcons.smog;
    } else if (condition == 800) {
      return FontAwesomeIcons.solidMoon;
    } else if (condition <= 804) {
      return FontAwesomeIcons.cloud;
    } else {
      return FontAwesomeIcons.info;
    }
  } else {
    if (condition < 300) {
      return FontAwesomeIcons.bolt;
    } else if (condition < 400) {
      return FontAwesomeIcons.cloudMoonRain;
    } else if (condition < 600) {
      return FontAwesomeIcons.cloudShowersHeavy;
    } else if (condition < 700) {
      return FontAwesomeIcons.solidSnowflake;
    } else if (condition < 800) {
      return FontAwesomeIcons.smog;
    } else if (condition == 800) {
      return FontAwesomeIcons.solidSun;
    } else if (condition <= 804) {
      return FontAwesomeIcons.cloud;
    } else {
      return FontAwesomeIcons.info;
    }
  }
}

String getWeatherCond(int condition) {
  if (condition < 300) {
    return 'thunder';
  } else if (condition < 400) {
    return 'Rain';
  } else if (condition < 600) {
    return 'Rainy';
  } else if (condition < 700) {
    return 'Snow';
  } else if (condition < 800) {
    return 'Smog';
  } else if (condition == 800) {
    return 'Clear';
  } else if (condition <= 804) {
    return 'Cloudy';
  } else {
    return 'Error';
  }
}

bool isNight(int hour) {
  if (hour < 6) {
    return true;
  } else if (hour < 18) {
    return false;
  } else {
    return true;
  }
}

Color getTimeColor(int hour) {
  if (hour < 6) {
    return kColorNight;
  } else if (hour < 12) {
    return kColorMorning;
  } else if (hour < 18) {
    return kColorDay;
  } else {
    return kColorNight;
  }
}
