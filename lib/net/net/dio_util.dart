import 'dart:convert';
import 'dart:io';

import 'package:alice/utils/util_index.dart';
import 'package:dio/dio.dart';

/// <BaseResp<T> 返回 status code msg data.
class BaseResp<T> {
  bool success;
  int code;
  String result;
  T data;

  BaseResp(this.success, this.code, this.result, this.data);

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"success\":\"$success\"");
    sb.write(",\"code\":$code");
    sb.write(",\"result\":\"$result\"");
    sb.write(",\"data\":\"$data\"");
    sb.write('}');
    return sb.toString();
  }
}

/// 请求方法.
class Method {
  static final String get = "GET";
  static final String post = "POST";
  static final String put = "PUT";
  static final String head = "HEAD";
  static final String delete = "DELETE";
  static final String patch = "PATCH";
}

/// 单例 DioUtil.
class DioUtil {
  static final DioUtil _singleton = DioUtil._init();
  static Dio _dio;

  static final ContentType paramString = ContentType.parse(
      "application/x-www-form-urlencoded");
  static final ContentType jsonString = ContentType.json;

  Options _options = getDefOptions();

  /// 是否是debug模式.
  static bool _isDebug = false;

  static DioUtil getInstance() {
    return _singleton;
  }

  factory DioUtil() {
    return _singleton;
  }

  DioUtil._init() {
    _dio = new Dio(_options);
  }

  /// 打开debug模式.
  static void openDebug() {
    _isDebug = true;
  }

  ///get请求
  Future<BaseResp<T>> getRequest<T>(String path,
      {responseType: ResponseType.JSON, data}) async {
    String token = SpUtil.getString("token");
    Map<String, dynamic> map = new Map.identity();
    map['Authorization'] = token;
    Options option = this._mergeOption(
        Method.get, ContentType.json, responseType, map);
    Response response = await _dio.request(path, data: data, options: option);
    _printHttpLog(response);
    bool _success;
    int _code;
    String _result;
    T _data;
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          _success = response.data['success'];
          _code = (response.data['code'] is String)
              ? int.tryParse(response.data['code'])
              : response.data['code'];
          _result = response.data['result'];
          _data = response.data['data'];
        } else {
          Map<String, dynamic> _dataMap = _decodeData(response);
          _success = _dataMap['success'];
          _code = (_dataMap['code'] is String)
              ? int.tryParse(_dataMap['code'])
              : _dataMap['code'];
          _result = _dataMap['result'];
          _data = _dataMap['data'];
        }
        return new BaseResp(_success, _code, _result, _data);
      } catch (e) {
        return new Future.error(new DioError(
          response: response,
          message: "data parsing exception...",
          type: DioErrorType.RESPONSE,
        ));
      }
    }
    return new Future.error(new DioError(
      response: response,
      message: "statusCode: $response.statusCode, service error",
      type: DioErrorType.RESPONSE,
    ));
  }

  ///post请求
  Future<BaseResp<T>> postRequest<T>(String path,
      {contentType, responseType: ResponseType.JSON, data}) async {
    String token = SpUtil.getString("token");
    Map<String, dynamic> map = new Map.identity();
    map['Authorization'] = token;
    Options option = this._mergeOption(
        Method.post, contentType, responseType, map);
    Response response = await _dio.request(path, data: data, options: option);
    _printHttpLog(response);
    bool _success;
    int _code;
    String _result;
    T _data;
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          _success = response.data['success'];
          _code = (response.data['code'] is String)
              ? int.tryParse(response.data['code'])
              : response.data['code'];
          _result = response.data['result'];
          _data = response.data['data'];
        } else {
          Map<String, dynamic> _dataMap = _decodeData(response);
          _success = _dataMap['success'];
          _code = (_dataMap['code'] is String)
              ? int.tryParse(_dataMap['code'])
              : _dataMap['code'];
          _result = _dataMap['result'];
          _data = _dataMap['data'];
        }
        return new BaseResp(_success, _code, _result, _data);
      } catch (e) {
        return new Future.error(new DioError(
          response: response,
          message: "data parsing exception...",
          type: DioErrorType.RESPONSE,
        ));
      }
    }
    return new Future.error(new DioError(
      response: response,
      message: "statusCode: $response.statusCode, service error",
      type: DioErrorType.RESPONSE,
    ));
  }



  /// decode response data.
  Map<String, dynamic> _decodeData(Response response) {
    if (response == null ||
        response.data == null ||
        response.data.toString().isEmpty) {
      return new Map();
    }
    return json.decode(response.data.toString());
  }


  Options _mergeOption(String method, ContentType contentType,
      ResponseType responseType, Map<String, dynamic> headers
  ) {
    _options.headers = (new Map.from(_options.headers))
      ..addAll(headers);
    _options.method = method ?? _options.method;
    _options.responseType = responseType ?? _options.responseType;
    _options.contentType = contentType ?? _options.contentType;
    return _options;
  }

  void _printHttpLog(Response response) {
    if (!_isDebug) {
      return;
    }
    try {
      print("----------------Http Log----------------" +
          "\n[statusCode]:   " +
          response.statusCode.toString() +
          "\n[request   ]:   " +
          _getOptionsStr(response.request));
      _printDataStr("reqdata ", response.request.data);
      _printDataStr("response", response.data);
    } catch (ex) {
      print("Http Log" + " error......");
    }
  }

  /// get Options Str.
  String _getOptionsStr(Options request) {
    return "method: " +
        request.method +
        "  baseUrl: " +
        request.baseUrl +
        "  path: " +
        request.path;
  }

  void _printDataStr(String tag, Object value) {
    String da = value.toString();
    while (da.isNotEmpty) {
      if (da.length > 512) {
        print("[$tag  ]:   " + da.substring(0, 512));
        da = da.substring(512, da.length);
      } else {
        print("[$tag  ]:   " + da);
        da = "";
      }
    }
  }

  Dio getDio() {
    return _dio;
  }

  static Dio createNewDio([Options options]) {
    options = options ?? getDefOptions();
    Dio dio = new Dio(options);
    return dio;
  }

  static Options getDefOptions() {
    Options options = new Options();
    options.contentType = ContentType.json;
    options.connectTimeout = 1000 * 10;
    options.receiveTimeout = 1000 * 20;
    options.responseType = ResponseType.JSON;
    return options;
  }
}
