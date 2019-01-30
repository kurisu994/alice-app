import 'package:alice/common/component_index.dart';
import 'package:alice/net/api/api.dart';
import 'package:alice/net/net/dio_util.dart';
import 'package:alice/ui/pages/index.dart';
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

                ///背景色渐变
//                decoration: new BoxDecoration(
//                    gradient: new LinearGradient(
//                      colors: const [Color(0xFF84b3ff), Color(0xFF518fff)],
//                      stops: const [0.0, 1.0],
//                      begin: Alignment.topCenter,
//                      end: Alignment.bottomCenter,
//                    )),
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
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showLoading = false;
  bool showPassword = false;
  final _dio = DioUtil.getInstance();

  void _submit() {
    this.setState(() {
      _showLoading = true;
    });
    if (_formKey.currentState.validate()) {
      //如果输入都检验通过，则进行登录操作
      Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text("执行登录操作")),
      );
      Map<String, dynamic> map = new Map.identity();
      map['userName'] = _userNameController.text;
      map['password'] = _passwordController.text;
      _dio.postRequest(
          ApiUtil.getPath(ApiUtil.USER_LOGIN), contentType: DioUtil.paramString,
          data: map)
          .then((data) {
        if (data.success) {
          SpUtil.putString("token", data.data);
          Navigator.push(
              context, new MaterialPageRoute(builder: (BuildContext context) {
            return new IndexPage();
          }));
        } else {
          showDialog(context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return new SingleChildScrollView(
                  child: AlertDialog(
                    title: Text('错误'),
                    content: Text(data.result),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('关闭'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              });
        }
      });
    }
    this.setState(() {
      _showLoading = false;
    });
  }

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
                      onSaved: (value) {},
                      controller: _userNameController,
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
                                color: Colors.grey),
                            onPressed: _showPassword,
                          )),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '请输入密码';
                        }
                      },
                      onSaved: (value) {},
                      controller: _passwordController,
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
                    onPressed: _showLoading ? null : _submit,
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
