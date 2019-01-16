import 'package:alice/utils/util_index.dart';

class WanAndroidApi {
  static const String _HOST = "127.0.0.1:8080";

  static const String USER_REGISTER = "user/register"; //注册
  static const String USER_LOGIN = "user/login"; //登录
  static const String USER_LOGOUT = "user/logout"; //退出

  static String getPath(String path) {
    StringBuffer sb = new StringBuffer(_HOST);
    if (StringUtils.isValid(path)) {
      sb.write('/$path');
      return sb.toString();
    }
    return '';
  }
}
