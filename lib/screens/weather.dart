import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  static const routeName = '/weather';
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  bool isLoading = false;
  var weatherDataCity;
  String city;
  var pollenDataCity;
  loadWeather() async {}
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Weather'),
        ),
        body: Center(
            child: Column(children: [
          Container(
              child: weatherDataCity != null
                  ? Column(children: [
                      Text("Temperature:${weatherDataCity['main']['temp']}"),
                      Text("Humidity:${weatherDataCity['main']['humidity']}"),
                      Text("WindSpeed:${weatherDataCity['wind']['speed']}"),
                      Text("CloudCover:${weatherDataCity['clouds']['all']}"),
                      Text("Text:${weatherDataCity['main']['pressure']}")
                    ])
                  : Text("Sorry data not found")),
          Container(
              child: pollenDataCity != null
                  ? Column(children: [
                      Text("AQI:${pollenDataCity['Count']['grass_pollen']}"),
                      Text("AQI:${pollenDataCity['Count']['tree_pollen']}"),
                      Text("AQI:${pollenDataCity['Count']['weed_pollen']}"),
                      Text("AQI:${pollenDataCity['Risk']['tree_pollen']}"),
                      Text("AQI:${pollenDataCity['Risk']['weed_pollen']}"),
                    ])
                  : Text("Sorry data not found")),
        ])));
  }
}
