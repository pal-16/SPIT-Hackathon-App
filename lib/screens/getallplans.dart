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
                        Navigator.of(context)
                            .pushNamed(GetCities.routeName, arguments: {
                          "plancities": ["Mumbai", "Delhi", "Pune"],
                        }),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                        ),
                      },
                  child: Column(children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 6.0)
                        ],
                      ),
                    ),
                    Text(planslist[index]["name"].toString()),
                    // Text("Hello")
                  ]));
            },
            itemCount: 3));
  }
}
