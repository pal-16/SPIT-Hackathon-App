import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:terna_app/screens/getallplans.dart';
import '../global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../global.dart';
import './weather.dart';
import 'dart:async';

class GetCities extends StatefulWidget {
  static const routeName = '/getcities';
  @override
  _GetCitiesState createState() => _GetCitiesState();
}

class _GetCitiesState extends State<GetCities> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> plancities;
  void initState() {
    super.initState();
  }

  var temp;
  var cloud;
  var humidity;
  var speed;

  showCities(String cityname) async {
    await loadWeather(cityname);
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Cimatic Conditions!",
          style: TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold),
        ),
        content: ListView(children: <Widget>[
          Text(
            "Chances of Rain:" + cloud.toString(),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Humidity Level:" + humidity.toString(),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Temperature:" + temp.toString(),
          ),
          SizedBox(
            height: 10,
          ),
          Text(message),
        ]),
        actions: <Widget>[
          FlatButton(
            child: Text("Got it!",
                style:
                    TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  String message;

  Future<void> loadWeather(String cityname) async {
    Map<String, String> app_headers = {
      'x-api-key': 'QyyU0RkCkX7NVkRTrZNyq1ATTrosnJVL6rG6qC46',
      'Content-type': 'application/json'
    };
    var weatherurl = "http://api.openweathermap.org/data/2.5/weather?q=" +
        cityname +
        "&appid=26bacc76e3b1b456766796b413dd26b6";
    var weather = await http.get(weatherurl
        //  'http://api.openweathermap.org/data/2.5/weather?q=Bengaluru&appid=26bacc76e3b1b456766796b413dd26b6',
        );

    var airqualityurl = "https://api.waqi.info/feed/" +
        cityname +
        "/?token=a425003f4a4b4cf3019b1b419b7a7ec84e3ca363";
    var airQuality = await http.get(
        //    'https://api.waqi.info/feed/Bengaluru/?token=a425003f4a4b4cf3019b1b419b7a7ec84e3ca363',
        airqualityurl);
    var pollenurl =
        "https://api.ambeedata.com/latest/pollen/by-place?place=" + cityname;
    var pollen = await http.get(
        //  'https://api.ambeedata.com/latest/pollen/by-place?place=Bengaluru',
        pollenurl,
        headers: app_headers);

    var weatherData = jsonDecode(weather.body);
    var airQualityData = jsonDecode(airQuality.body);
    print(airQualityData);
    var pollenData = jsonDecode(pollen.body);
    print(pollenData);
    print(airQualityData['data']['aqi']);
    // print(airQualityData['data']['iaqi']['pm10']['v']);
    //  print(airQualityData['data']['iaqi']['pm25']['v']);
    print("Temperature:${weatherData['main']['temp']}");
    temp = weatherData['main']['temp'];
    print("Humidity:${weatherData['main']['humidity']}");
    humidity = weatherData['main']['humidity'];
    print("WindSpeed:${weatherData['wind']['speed']}");
    speed = weatherData['wind']['speed'];
    print("CloudCover:${weatherData['clouds']['all']}");
    cloud = weatherData['clouds']['all'];
    //print("print:${weatherData['main']['pressure']}");
    //print("AQI:${pollenData['data'][0]['Count']['grass_pollen']}");
    //print("AQI:${pollenData['data'][0]['Count']['tree_pollen']}");
    //print("AQI:${pollenData['data'][0]['Count']['weed_pollen']}");
    //print("AQI:${pollenData['data'][0]['Risk']['tree_pollen']}");
    //print("AQI:${pollenData['data'][0]['Risk']['weed_pollen']}");

    if (temp < 60) {
      message =
          "The temparture is below 60 Fahrenheit, you might want to wear warm clothes";
    } else if (temp > 95) {
      message =
          "The temparture is above 95 Fahrenheit, you might want to wear  clothes";
    }
  }

  List<dynamic> text;
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> routeArgs =
        ModalRoute.of(context).settings.arguments;
    plancities = routeArgs["plancities"];
    print(plancities[0]);
    return Scaffold(
        appBar: AppBar(
          title: Text("Cities associated with your travel plan"),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  child: Text(
                    plancities[index].toString(),
                    style: TextStyle(fontSize: 30),
                  ),
                  onTap: () => {showCities(plancities[index])});
            },
            padding: EdgeInsets.all(0.0),
            itemCount: plancities.length));
  }
}
