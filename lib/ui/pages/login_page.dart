import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: '登录页',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('登录页'),
          ),
          body: new Center(
            child: new LoginHomePage(),
          ),
        ));
  }
}

class LoginHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginHomePageState();
}

class LoginHomePageState extends State<LoginHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _showLoading = false;

  void _submit() => {};

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/amadeus.png',
                  height: 180.0,
                  fit: BoxFit.fitHeight,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: '用户名'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '请输入用户名';
                    }
                  },
                  controller: _userNameTextController,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: '密码'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '请输入密码';
                    }
                  },
                  controller: _passwordTextController,
                  obscureText: true,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: _submit,
                    splashColor: Colors.orangeAccent,
                    child: Text(
                      '登录',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
