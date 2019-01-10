import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

var dio = new Dio();

class NetUtils {
  static final ContentType jsonParam =
      ContentType.parse("application/x-www-form-urlencoded");
  static final ContentType json = ContentType.json;
  static final ContentType formData = ContentType.parse("multipart/form-data");

  static Future get(String url, {Map<String, dynamic> params}) async {
    dio.cookieJar = new PersistCookieJar("./cookies");
    var response = await dio.get(url, data: params);
    return response.data;
  }

  static Future post(
      String url, Map<String, dynamic> params, ContentType contentType) async {
    final prefs = await SharedPreferences.getInstance();
    if (contentType == null) {
      contentType = json;
    }
    final token =
        prefs.getString('token') == null ? "" : prefs.getString('token');
    var options = new Options();
    var map = new Map<String, String>();
    map['Authorization'] = token;
    options.headers = map;
    options.contentType = contentType;
    options.connectTimeout = 15000;
    options.responseType = ResponseType.JSON;
    var response = await dio.post(url, data: params, options: options);
    return response.data;
  }
}
