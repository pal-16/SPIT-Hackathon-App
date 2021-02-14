//import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:terna_app/screens/createtravel.dart';
import 'package:terna_app/screens/createtravels.dart';
import 'package:terna_app/screens/getallplans.dart';
//import 'package:flutter/services.dart';
import 'package:terna_app/screens/settings.dart';
import '../widgets/app_drawer.dart';
import '../screens/getallplans.dart';
import '../screens/weather.dart';
import '../global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class Home extends StatefulWidget {
  static const routeName = '/home';
  final String username;
  final String password;
  final String email;
  Home(
      [this.username = "Anonymus",
      this.email = "Anonymus",
      this.password = "Anonymus"]);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  @override
  initState() {
    super.initState();
  }

  Future<void> _saveForm() async {
    final String url = urlInitial + "api/travel_plans/";
    print(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authtoken = await prefs.get("token");
    print(authtoken);
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: authtoken,
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    print(response.headers);
    print(response.body);
    dynamic res = jsonDecode(response.body);
    print(res["plans"]);
    print(res["plans"][0]["name"]);
    // plans = res["plans"];
    Navigator.of(context).pushNamed(GetTravel.routeName, arguments: {
      "planslist": res["plans"],
    });
  }

  Widget appBar(scaffoldkey) {
    return AppBar(
      title: Text(
        "Terna App",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          scaffoldkey.currentState.openDrawer();
        },
        color: Colors.white,
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPage(
                          widget.username, widget.email, widget.password)));
            })
      ],
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey _scaffoldKey = new GlobalKey();

    Widget homeCard(String imageUrl, String text, String action) {
      return Padding(
        padding: const EdgeInsets.all(13.0),
        child: GestureDetector(
          onTap: () async {
            if (action == "2") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateTravels()));
            } else if (action == "1") {
              await _saveForm();

              //   Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => GetTravel()));
            } else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Weather()));
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 3.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(imageUrl),
                  radius: 50,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Flexible(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget homePage() {
      return Padding(
        padding: const EdgeInsets.only(top: 90.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            homeCard("assets/images/1.png", "View Travel Plans", "1"),
            homeCard("assets/images/2.png", "Create Travel Plan", "2"),
          ],
        ),
      );
    }

    return Stack(
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: double.infinity,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/images/homebg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
            extendBodyBehindAppBar: true,
            key: _scaffoldKey,
            drawer: MyAppDrawer(widget.username),
            appBar: appBar(_scaffoldKey),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/homebg.png'),
                      fit: BoxFit.cover)),
              child: new Center(
                child: homePage(),
              ),
            )),
      ],
    );
  }
}
