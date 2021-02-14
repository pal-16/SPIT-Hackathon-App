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
import '../screens/getallcities.dart';

class GetTravel extends StatefulWidget {
  static const routeName = '/getplans';
  @override
  _GetTravelState createState() => _GetTravelState();
}

class _GetTravelState extends State<GetTravel> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> planslist;
  void initState() {
    super.initState();
  }

  List<dynamic> text;
  List<String> curr_cities = [];
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> routeArgs =
        ModalRoute.of(context).settings.arguments;
    planslist = routeArgs["planslist"];
    return Scaffold(
        appBar: AppBar(
          title: Text("Get all your Travel Plans"),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () => {
                        print(planslist[index]["cities"]),
                        for (int i = 0;
                            i < planslist[index]["cities"].length;
                            i++)
                          {
                            curr_cities
                                .add(planslist[index]["cities"][i]["name"]),
                          },
                        print(curr_cities),
                        Navigator.of(context)
                            .pushNamed(GetCities.routeName, arguments: {
                          "plancities": curr_cities,
                        }),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                        ),
                      },
                  child: Card(
                      child: Container(
                    padding: EdgeInsets.all(30.0),
                    child: Column(children: <Widget>[
                      Text(
                        planslist[index]["name"].toString(),
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      // Text("Hello")
                    ]),
                  )));
            },
            itemCount: planslist.length));
  }
}
