import 'package:alice/utils/util_index.dart';

class ApiUtil {
  static const String _HOST = "https://wapp.kurisu.top";

  static const String USER_REGISTER = "user/auth/register"; //注册
  static const String USER_LOGIN = "user/auth/login"; //登录
  static const String USER_LOGOUT = "user/logout"; //退出
  static const String QUERY_ACCOUNT = "account/list"; //查询账号
  static const String ADD_ACCOUNT = "account/save"; //添加账号

  static String getPath(String path) {
    StringBuffer sb = new StringBuffer(_HOST);
    if (StringUtils.isValid(path)) {
      sb.write('/$path');
      return sb.toString();
    }
    return '';
  }
}
