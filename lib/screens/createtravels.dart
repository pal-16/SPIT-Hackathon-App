import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:terna_app/screens/getallplans.dart';
import '../global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class CreateTravels extends StatefulWidget {
  static const routeName = '/createtravelssplan';
  @override
  _CreateTravelsState createState() => _CreateTravelsState();
}

class _CreateTravelsState extends State<CreateTravels> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _startDate = TextEditingController();

  TextEditingController _endDate = TextEditingController();

  TextEditingController planname = TextEditingController();

  DateTime _sdateTime = DateTime.now();
  DateTime _edateTime = DateTime.now();

  List<String> cities = [];
  List<dynamic> pills = [];
  _selectStartDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _sdateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_pickedDate != null) {
      setState(() {
        _sdateTime = _pickedDate;
        _startDate.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  _selectEndDate(BuildContext context) async {
    var _epickedDate = await showDatePicker(
        context: context,
        initialDate: _edateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_epickedDate != null) {
      setState(() {
        _edateTime = _epickedDate;
        _endDate.text = DateFormat('yyyy-MM-dd').format(_epickedDate);
      });
    }
  }

  void initState() {
    super.initState();
  }

  List<dynamic> finalholder = [];
  List<String> holdercity = [];
  addCity() {
    TextEditingController customController = TextEditingController();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Enter city name",
          style: TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold),
        ),
        content: TextFormField(controller: customController),
        actions: <Widget>[
          FlatButton(
            child: Text("Submit",
                style:
                    TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold)),
            onPressed: () {
              if (customController.text != '')
                holdercity.add(customController.text);
              Navigator.of(context).pop();
              return setState(() {
                cities = holdercity;
              });
            },
          )
        ],
      ),
    );
  }

  addPill() {
    TextEditingController period = TextEditingController();
    TextEditingController stock = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController timeh = TextEditingController();
    TextEditingController timem = TextEditingController();

    TextEditingController dosage = TextEditingController();
    Map<String, dynamic> holder = {};
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Add Pill Info",
          style: TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold),
        ),
        content: ListView(children: <Widget>[
          TextFormField(
            controller: period,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15.0),
              ),
              labelText: "Period",
            ),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: stock,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15.0),
              ),
              labelText: "Stock",
            ),
          ),
          TextFormField(
            controller: name,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15.0),
              ),
              labelText: "Name of Pill",
            ),
            keyboardType: TextInputType.text,
          ),
          TextFormField(
            controller: timeh,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15.0),
              ),
              labelText: "Time in hours",
            ),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: timem,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15.0),
              ),
              labelText: "Time in minutes",
            ),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: dosage,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15.0),
              ),
              labelText: "Dosage",
            ),
            keyboardType: TextInputType.number,
          ),
        ]),
        actions: <Widget>[
          FlatButton(
            child: Text("Submit",
                style:
                    TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold)),
            onPressed: () {
              holder["period"] = period.text;
              holder["stock"] = stock.text;
              holder["name"] = name.text;
              holder["time"] = "09:27:00";
              // (timeh.text + ":" + timem.text + ":00").toString();
              holder["dosage"] = dosage.text;
              finalholder.add(holder);
              Navigator.of(context).pop();

              return setState(() {
                pills = finalholder;
              });
            },
          )
        ],
      ),
    );
  }

  void _saveForm() async {
    final String url = urlInitial + "api/travel_plans/";
    print(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(_startDate.text);

    String authtoken = await prefs.get("token");
    print(authtoken);
    final response = await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: authtoken,
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: json.encode({
        "name": planname.text,
        "start_date": _startDate.text,
        "end_date": _endDate.text,
        "cities": holdercity,
        "pills": finalholder,
      }),
    );
    print(response.headers);
    print(response.body);
    holdercity = [];
    finalholder = [];
    return setState(() {
      pills = [];
      cities = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Travel Plan"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: planname,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelText: "Travel Plan Name",
                ),
              ),
              TextField(
                controller: _startDate,
                decoration: InputDecoration(
                    labelText: 'Start Date',
                    hintText: 'Pick a Date',
                    prefixIcon: InkWell(
                      onTap: () {
                        _selectStartDate(context);
                      },
                      child: Icon(Icons.calendar_today),
                    )),
              ),
              TextField(
                controller: _endDate,
                decoration: InputDecoration(
                    labelText: 'End Date',
                    hintText: 'Pick a Date',
                    prefixIcon: InkWell(
                      onTap: () {
                        _selectEndDate(context);
                      },
                      child: Icon(Icons.calendar_today),
                    )),
              ),
              SizedBox(
                height: 25,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: RaisedButton(
                    shape: StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add),
                        Text(
                          " Add city",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    onPressed: addCity,
                    color: Color(0xff8f94fb),
                    textColor: Colors.white,
                    splashColor: Colors.grey,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: RaisedButton(
                    shape: StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add),
                        Text(
                          " Add Pill Information",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    onPressed: addPill,
                    color: Color(0xff8f94fb),
                    textColor: Colors.white,
                    splashColor: Colors.grey,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    _saveForm();
                    //  Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GetTravel()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
              Container(
                child: Column(children: [
                  Text("Cities you have Added"),
                  Card(
                      child: (cities != null)
                          ? Column(children: [
                              for (var i in cities) Card(child: Text(i))
                            ])
                          : Text("")),
                ]),
              ),
              Container(
                child: Column(children: [
                  Text("Pills that you have added"),
                  Card(
                      child: (pills != null)
                          ? Column(children: [
                              for (var i in pills) Card(child: Text(i['name']))
                            ])
                          : Text("")),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
