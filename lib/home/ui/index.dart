import 'package:alice/home/style/theme.dart' as theme;
import 'package:alice/home/ui/sign_in_page.dart';
import 'package:alice/home/ui/sign_up_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  PageController _pageController;
  PageView _pageView;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController = new PageController();

    _pageView = new PageView(
      controller: _pageController,
      children: <Widget>[
        new SignInPage(),
        new SignUpPage(),
      ],
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("首页"),
          centerTitle: true,
        ),
        //SafeArea，让内容显示在安全的可见区域
        //SafeArea，可以避免一些屏幕有刘海或者凹槽的问题
        body: new SafeArea(
          child: new SingleChildScrollView(

              ///用SingleChildScrollView+Column，避免弹出键盘的时候，出现overFlow现象
              child: new Container(
//                 这里要手动设置container的高度和宽度，不然显示不了
//                 利用MediaQuery可以获取到跟屏幕信息有关的数据
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  //设置渐变的背景
                  decoration: new BoxDecoration(
                    gradient: theme.Theme.primaryGradient,
                  ),
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: //中间的Indicator指示器
                                new Container(
                              width: 300,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0x552B2B2B),
                              ),
                              child: new Row(
                                children: <Widget>[
                                  Expanded(
                                      child: new Container(
                                    decoration: _currentPage == 0
                                        ? BoxDecoration(
                                            color: Colors.white,
                                          )
                                        : null,
                                    child: new Center(
                                      child: new FlatButton(
                                        onPressed: () {
                                          _pageController.animateToPage(0,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.decelerate);
                                        },
                                        child: new Text(
                                          "登录",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      child: new Container(
                                    decoration: _currentPage == 1
                                        ? BoxDecoration(
                                            color: Colors.white,
                                          )
                                        : null,
                                    child: new Center(
                                      child: new FlatButton(
                                        onPressed: () {
                                          _pageController.animateToPage(1,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.decelerate);
                                        },
                                        child: new Text(
                                          "注册",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
//                      new SignInPage(),
//                      new SignUpPage(),
                      new Expanded(child: _pageView),
                    ],
                  ))),
        ));
  }
}
