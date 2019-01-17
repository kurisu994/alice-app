import 'package:alice/common/common.dart';
import 'package:alice/models/models.dart';

//模拟网络请求数据
class HttpUtils {
  Future<SplashModel> getSplash() {
    return Future.delayed(new Duration(milliseconds: 300), () {
      return new SplashModel(
        title: '启动页',
        content: '这是一个启动页',
        url: 'https://github.com/kurisu994/alice-app',
        imgUrl: 'assets/images/splash.jpeg',
      );
    });
  }

  Future<VersionModel> getVersion() async {
    return Future.delayed(new Duration(milliseconds: 300), () {
      return new VersionModel(
        title: '有新版本，去更新吧！',
        content: '',
        url: '',
        version: AppConfig.version,
      );
    });
  }

  Future<ComModel> getRecItem() async {
    return Future.delayed(new Duration(milliseconds: 300), () {
      return null;
    });
  }

  Future<List<ComModel>> getRecList() async {
    return Future.delayed(new Duration(milliseconds: 300), () {
      return new List();
    });
  }
}
