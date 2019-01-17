import 'package:alice/common/component_index.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  TimerUtil _timerUtil;

  List<String> _guideList = [
    Utils.getImgPath('guide1'),
    Utils.getImgPath('guide2'),
    Utils.getImgPath('guide3'),
    Utils.getImgPath('guide4'),
  ];

  List<Widget> _bannerList = new List();

  int _status = 0;
  int _count = 3;

  SplashModel _splashModel;

  @override
  void initState() {
    super.initState();
    _loadSplashData();
    _initAsync();
  }

  void _loadSplashData() async {
    HttpUtils httpUtil = new HttpUtils();
    httpUtil.getSplash().then((model) async {
      await SpUtil.getInstance();
      _splashModel = Utils.getSplashModel();
      if (!ObjectUtil.isEmpty(model.imgUrl)) {
        if (_splashModel == null || (_splashModel.imgUrl != model.imgUrl)) {
          Utils.putObject(Constant.KEY_SPLASH_MODEL, model);
          setState(() {
            _splashModel = model;
          });
        }
      } else {
        Utils.putObject(Constant.KEY_SPLASH_MODEL, null);
      }
    });
  }

  void _initAsync() {
    Observable.just(1).delay(new Duration(milliseconds: 1000)).listen((_) {
      if (SpUtil.getBool(Constant.KEY_GUIDE) != true &&
          ObjectUtil.isNotEmpty(_guideList)) {
        SpUtil.putBool(Constant.KEY_GUIDE, true);
        _initBanner();
      } else {
        _initSplash();
      }
    });
  }

  void _initBanner() {
    _initBannerData();
    setState(() {
      _status = 2;
    });
  }

  void _initBannerData() {
    for (int i = 0, length = _guideList.length; i < length; i++) {
      if (i == length - 1) {
        _bannerList.add(new Stack(
          children: <Widget>[
            new Image.asset(
              _guideList[i],
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            new Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                margin: EdgeInsets.only(bottom: 160.0),
                child: new InkWell(
                  onTap: () {
                    _goMain();
                  },
                  child: new CircleAvatar(
                    radius: 48.0,
                    backgroundColor: Colors.indigoAccent,
                    child: new Padding(
                      padding: EdgeInsets.all(2.0),
                      child: new Text(
                        '立即体验',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
      } else {
        _bannerList.add(new Image.asset(
          _guideList[i],
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ));
      }
    }
  }

  void _initSplash() {
    _splashModel = Utils.getSplashModel();
    if (_splashModel == null) {
      _goMain();
    } else {
      _doCountDown();
    }
  }

  void _doCountDown() {
    setState(() {
      _status = 1;
    });
    _timerUtil = new TimerUtil(mTotalTime: 3 * 1000);
    _timerUtil.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      setState(() {
        _count = _tick.toInt();
      });
      if (_tick == 0) {
        _goMain();
      }
    });
    _timerUtil.startCountDown();
  }

  void _goMain() {
    var token = SpUtil.getString("token");
    if (StringUtils.isValid(token)) {
      //TODO 跳转到首页
      Navigator.of(context).pushReplacementNamed('/MainPage');
    } else {
      //TODO 跳转到登录页
      Navigator.of(context).pushReplacementNamed('/MainPage');
    }
  }

  Widget _buildSplashBg() {
    return new Image.asset(
      Utils.getImgPath('splash_bg'),
      width: double.infinity,
      fit: BoxFit.fill,
      height: double.infinity,
    );
  }

  Widget _buildAdWidget() {
    if (_splashModel == null) {
      return new Container(
        height: 0.0,
      );
    }
    return new Offstage(
      offstage: !(_status == 1),
      child: new InkWell(
        onTap: () {
          if (ObjectUtil.isEmpty(_splashModel.url)) return;
          _goMain();
          NavigatorUtil.pushWeb(context,
              title: _splashModel.title, url: _splashModel.url);
        },
        child: new Container(
          alignment: Alignment.topLeft,
          child: new Image.asset(Utils.getImgPath('splash', format: 'jpg'),
            fit: BoxFit.none,
            height: double.nan,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: !(_status == 0),
            child: _buildSplashBg(),
          ),
          new Offstage(
            offstage: !(_status == 2),
            child: ObjectUtil.isEmpty(_bannerList)
                ? new Container()
                : new Swiper(
                    autoStart: false,
                    circular: false,
                    indicator: CircleSwiperIndicator(
                      radius: 4.0,
                      padding: EdgeInsets.only(bottom: 30.0),
                      itemColor: Colors.black26,
                    ),
                    children: _bannerList),
          ),
          _buildAdWidget(),
          new Offstage(
            offstage: !(_status == 1),
            child: new Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  _goMain();
                },
                child: new Container(
                    padding: EdgeInsets.all(12.0),
                    child: new Text(
                      '跳过 $_count',
                      style: new TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                    decoration: new BoxDecoration(
                        color: Color(0x66000000),
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        border: new Border.all(
                            width: 0.33, color: ColorT.divider))),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    ///清除timer。
    if (_timerUtil != null) _timerUtil.cancel();
  }
}
