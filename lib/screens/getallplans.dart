import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../global.dart';
import './weather.dart';
import 'dart:async';

class GetTravel extends StatefulWidget {
  static const routeName = '/getplans';
  @override
  _GetTravelState createState() => _GetTravelState();
}

class _GetTravelState extends State<GetTravel> {
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

  Future<void> loadWeather() async {
    Map<String, String> app_headers = {
      'x-api-key': 'QyyU0RkCkX7NVkRTrZNyq1ATTrosnJVL6rG6qC46',
      'Content-type': 'application/json'
    };

    var weather = await http.get(
      'http://api.openweathermap.org/data/2.5/weather?q=Bengaluru&appid=26bacc76e3b1b456766796b413dd26b6',
    );
    var airQuality = await http.get(
      'https://api.waqi.info/feed/Bengaluru/?token=a425003f4a4b4cf3019b1b419b7a7ec84e3ca363',
    );

    var pollen = await http.get(
        'https://api.ambeedata.com/latest/pollen/by-place?place=Bengaluru',
        headers: app_headers);

    var weatherData = jsonDecode(weather.body);
    var airQualityData = jsonDecode(airQuality.body);
    print("=====hii");
    print(airQualityData);
    var pollenData = jsonDecode(pollen.body);
    print("hellopalak");
    print(pollenData);
    print(airQualityData['data']['aqi']);
    print(airQualityData['data']['iaqi']['pm10']['v']);
    print(airQualityData['data']['iaqi']['pm25']['v']);
    print("Temperature:${weatherData['main']['temp']}");
    print("Humidity:${weatherData['main']['humidity']}");
    print("WindSpeed:${weatherData['wind']['speed']}");
    print("CloudCover:${weatherData['clouds']['all']}");
    print("print:${weatherData['main']['pressure']}");
    print("AQI:${pollenData['data'][0]['Count']['grass_pollen']}");
    print("AQI:${pollenData['data'][0]['Count']['tree_pollen']}");
    print("AQI:${pollenData['data'][0]['Count']['weed_pollen']}");
    print("AQI:${pollenData['data'][0]['Risk']['tree_pollen']}");
    print("AQI:${pollenData['data'][0]['Risk']['weed_pollen']}");
  }

  List<dynamic> text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Get all your Travel Plans"),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  child: Text(cities[index].toString()),
                  onTap: () => {
                        loadWeather(),
                        //  Navigator.push(context,
                        //    MaterialPageRoute(builder: (context) => Weather())),
                      });
            },
            itemCount: 3));
  }
}
