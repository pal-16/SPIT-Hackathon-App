import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terna_app/screens/getallplans.dart';
//import 'package:flutter/services.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/home.dart';
import 'screens/upload.dart';
import 'screens/createtravel.dart';
import 'screens/createtravels.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'global.dart';
import 'package:sms/sms.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'screens/getallcities.dart';
import 'dart:math';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void main() {
  runApp(TernaApp());
}

class TernaApp extends StatefulWidget {
  @override
  _TernaAppState createState() => _TernaAppState();
}

class _TernaAppState extends State<TernaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Terna App",
      theme: ThemeData(
        primaryColor: Color.fromRGBO(191, 229, 255, 1),
        accentColor: Color(0xff8f94fb),
        backgroundColor: Colors.white,
        bottomAppBarColor: Colors.white,
      ),
      routes: {
        Home.routeName: (ctx) => Home(),
        Signup.routeName: (ctx) => Signup(),
        Login.routeName: (ctx) => Login(),
        Upload.routeName: (ctx) => Upload(),
        GetTravel.routeName: (ctx) => GetTravel(),
        CreateTravel.routeName: (ctx) => CreateTravel(),
        CreateTravels.routeName: (ctx) => CreateTravels(),
        GetCities.routeName: (ctx) => GetCities(),
        // TestMyApp.routeName: (ctx) => TestMyApp(),
      },
      home: MyConditionalWidget(),
    );
  }
}

class MyConditionalWidget extends StatefulWidget {
  @override
  _MyConditionalWidgetState createState() => _MyConditionalWidgetState();
}

class _MyConditionalWidgetState extends State<MyConditionalWidget> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String email;
  String username;

  newFunc(SmsMessage msg) async {
    print(msg.body);
    final String url = yashServer + "get-new-task";
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'message': msg.body,
      }),
    );
    print(response.body);

    dynamic res = jsonDecode(response.body);
    print(res);
    if (res['status'] == 1) {
      final String url = urlInitial + "api/travel_plans/";
      print(url);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String authtoken = await prefs.get("token");
      print(authtoken);
      List<String> city = [];
      var rng = new Random();

      var x = rng.nextInt(100);

      city.add(res['location'].toString());
      final response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: authtoken,
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "name": "Sms Generated Plan" + x.toString(),
          "start_date": res['date'],
          "end_date": "2021-12-31",
          "cities": city,
          "pills": [],
        }),
      );
      print(response.headers);
      print(response.body);
    }
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) {
      print("YSRT");
      print(token);
      fcm_token = token;
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  Future<Map<String, String>> checkLogin() async {
    email = await _prefs.then((prefs) {
      return (prefs.getString('email') ?? '');
    });
    print(email);
    username = await _prefs.then((prefs) {
      return (prefs.getString('name') ?? '');
    });
    return (email == '' && username == '')
        ? Future.value(null)
        : Future.value({"email": email, "username": username});
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
    firebaseCloudMessaging_Listeners();
    print("palak=====================");
    SmsReceiver receiver = new SmsReceiver();
    print(receiver);

    receiver.onSmsReceived.listen((SmsMessage msg) => newFunc(msg));
  }

  @override
  Widget build(BuildContext context) {
    print(email);
    return FutureBuilder(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['email'] != null &&
              snapshot.data['username'] != null)
            return Home(snapshot.data['username'], snapshot.data['email']);
        }
        return Login();
      },
    );
  }
}
