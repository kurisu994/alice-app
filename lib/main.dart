import 'package:alice/home/ui/index.dart';
import 'package:alice/main/ui/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  Future<String> get() async {
    String token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    return token;
  }

  @override
  Widget build(BuildContext context) {
    get().then((String token) {
      if (token != null && token != "") {
        return new Main();
      } else {
        return new HomePage();
      }
    });
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new HomePage()
    );
  }
}
