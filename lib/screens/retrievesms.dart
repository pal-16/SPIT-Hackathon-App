import 'package:sms/sms.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global.dart';

class MyInbox extends StatefulWidget {
  @override
  _MyInboxState createState() => _MyInboxState();
}

class _MyInboxState extends State<MyInbox> {
  SmsQuery query = new SmsQuery();
  List messages = new List();
  @override
  initState() {
    super.initState();
    SmsReceiver receiver = new SmsReceiver();
    print(receiver);
    receiver.onSmsReceived.listen((SmsMessage msg) => newFunc(msg));
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SMS Inbox"),
          backgroundColor: Colors.pink,
        ),
        body: Text("hshds")
        /* FutureBuilder(
          future: fetchSMS(),
          builder: (context, snapshot) {
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.markunread,
                        color: Colors.pink,
                      ),
                      title: Text(messages[index].address),
                      subtitle: Text(
                        messages[index].body,
                        maxLines: 2,
                        style: TextStyle(),
                      ),
                    ),
                  );
                });
          },
        )*/
        );
  }
/*
  fetchSMS() async {
    messages = await query.getAllSms;
    final response = await http.post(
      Uri.https('http://ef482bb58bd1.ngrok.io/', 'get-new-task'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'message': messages[0].body,
      }),
    );
    print(response.body);
    if (response.statusCode == 201) {
      print("Works FINE");
    } else {
      throw Exception('Failed to create album.');
    }
  }*/
}
