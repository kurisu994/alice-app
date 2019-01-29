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
          body: new SafeArea(

            ///解决键盘弹出遮挡输入框的解决方案
            child: new SingleChildScrollView(
              child: new Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      colors: const [Color(0xFFfbab66), Color(0xFFf7418c)],
                      stops: const [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )),
                child: new LoginHomePage(),
              ),
            ),
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
  bool showPassword = true;

  void _submit() {}

  void _showPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.center,
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
                  height: 165.0,
                  fit: BoxFit.fitHeight,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '用户名',
                        icon: new Icon(Icons.supervisor_account),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '请输入用户名';
                        }
                      },
                      controller: _userNameTextController,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: '密码',
                          icon: new Icon(Icons.lock),
                          suffixIcon: new IconButton(
                            icon: new Icon(Icons.remove_red_eye,
                                color: Colors.black),
                            onPressed: _showPassword,
                          )),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '请输入密码';
                        }
                      },
                      controller: _passwordTextController,
                      obscureText: !showPassword,
                    ),
                  ),
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
