import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

class CurrentWeather extends StatefulWidget {
  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  bool isLoading = false;
  var weatherData;
  var aqiData;
  var w;

  var humidity;
  var aqi;
  var pm25;
  var pm10;
  var temp;

  List<String> message;

  String wData;
  String fData;

  Future<void> loadWeather() async {
    Position position;
    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    } catch (e) {
      print(e);
    }

    if (position != null) {
      final lat = position.latitude;
      final lon = position.longitude;

      final weatherResponse = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?id=524901&appid=26bacc76e3b1b456766796b413dd26b6&lat=${lat.toString()}&lon=${lon.toString()}');
      final aqiResponse = await http.get(
          'http://api.openweathermap.org/data/2.5/air_pollution?lat=${lat.toString()}&lon=${lon.toString()}&appid=26bacc76e3b1b456766796b413dd26b6');

      if (weatherResponse.statusCode == 200 && aqiResponse.statusCode == 200) {
        weatherData = jsonDecode(weatherResponse.body);
        aqiData = jsonDecode(aqiResponse.body);

        aqi = aqiData['list'][0]['main']['aqi'];
        if (aqi <= 50) {
          message.add("The air quality index is good");
        } else if (aqi > 50 && aqi <= 100) {
          message.add("The air quality index is satisfactory");
        } else if (aqi > 100 && aqi <= 200) {
          message.add("The air quality index is moderately polluted");
        } else if (aqi > 200 && aqi <= 300) {
          message.add("The air quality index is poor");
        } else if (aqi > 300 && aqi <= 400) {
          message.add("The air quality index is very poor");
        } else if (aqi > 400 && aqi <= 500) {
          message.add("The air quality index is severe");
        }
        pm25 = aqiData['list'][0]['components']['pm2_5'];
        if (pm25 > 80) {
          message.add(
              "The pm2.5 level is above 0, you might want to wear a mask!");
        }
        pm10 = aqiData['list'][0]['components']['pm10'];
        if (pm10 > 140) {
          message
              .add("The pm10 level is above 0, you might want to wear a mask!");
        }

        humidity = weatherData['main']['humidity'];
        if (humidity > 80) {
          message.add(
              "The humidity is above 80%, you might want to carry an umbrella");
        }

        temp = weatherData['main']['temp'];
        if (temp < 60) {
          message.add(
              "The temparture is below 60 Fahrenheit, you might want to wear warm clothes");
        } else if (temp > 95) {
          message.add(
              "The temparture is above 95 Fahrenheit, you might want to wear  clothes");
        }
        var rng = new Random();
        if (message.length != 0) {
          var n = rng.nextInt(message.length);
          var realMessage = message[n];
          final response = await http.post(
            'http://<link>/api/send_message',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'msg': realMessage,
            }),
          );
          print(response.body);
        }

        return;
      }
    }
  }

  @override
  void initState() async {
    await loadWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Current Location Weather'),
        ),
        body: Text("hello"));
  }
}
