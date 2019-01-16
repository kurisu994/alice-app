import 'dart:convert';
import 'dart:io';

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
/// debug模式下可以打印请求日志. DioUtil.openDebug().
/// dio详细使用请查看dio官网(https://github.com/flutterchina/dio).
class DioUtil {
  static final DioUtil _singleton = DioUtil._init();
  static Dio _dio;

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

  /// set Config.
  void setConfig(HttpConfig config) {
    _statusKey = config.status ?? _statusKey;
    _codeKey = config.code ?? _codeKey;
    _msgKey = config.msg ?? _msgKey;
    _dataKey = config.data ?? _dataKey;
    _mergeOption(config.options);
    _pem = config.pem ?? _pem;
    if (_dio != null) {
      _dio.options = _options;
      if (_pem != null) {
        _dio.onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            if (cert.pem == _pem) {
              // 证书一致，则放行
              return true;
            }
            return false;
          };
        };
      }
      if (_pKCSPath != null) {
        _dio.onHttpClientCreate = (HttpClient client) {
          SecurityContext sc = new SecurityContext();
          //file为证书路径
          sc.setTrustedCertificates(_pKCSPath, password: _pKCSPwd);
          HttpClient httpClient = new HttpClient(context: sc);
          return httpClient;
        };
      }
    }
  }

  /// Make http request with options.
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  /// [options] The request options.
  /// <BaseResp<T> 返回 status code msg data .
  Future<BaseResp<T>> request<T>(String method, String path,
      {data, Options options, CancelToken cancelToken}) async {
    Response response = await _dio.request(path,
        data: data,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
    _printHttpLog(response);
    String _status;
    int _code;
    String _msg;
    T _data;
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          _status = (response.data[_statusKey] is int)
              ? response.data[_statusKey].toString()
              : response.data[_statusKey];
          _code = (response.data[_codeKey] is String)
              ? int.tryParse(response.data[_codeKey])
              : response.data[_codeKey];
          _msg = response.data[_msgKey];
          _data = response.data[_dataKey];
        } else {
          Map<String, dynamic> _dataMap = _decodeData(response);
          _status = (_dataMap[_statusKey] is int)
              ? _dataMap[_statusKey].toString()
              : _dataMap[_statusKey];
          _code = (_dataMap[_codeKey] is String)
              ? int.tryParse(_dataMap[_codeKey])
              : _dataMap[_codeKey];
          _msg = _dataMap[_msgKey];
          _data = _dataMap[_dataKey];
        }
        return new BaseResp(_status, _code, _msg, _data);
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

  /// Make http request with options.
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  /// [options] The request options.
  /// <BaseRespR<T> 返回 status code msg data  Response.
  Future<BaseRespR<T>> requestR<T>(String method, String path,
      {data, Options options, CancelToken cancelToken}) async {
    Response response = await _dio.request(path,
        data: data,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
    _printHttpLog(response);
    String _status;
    int _code;
    String _msg;
    T _data;
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          _status = (response.data[_statusKey] is int)
              ? response.data[_statusKey].toString()
              : response.data[_statusKey];
          _code = (response.data[_codeKey] is String)
              ? int.tryParse(response.data[_codeKey])
              : response.data[_codeKey];
          _msg = response.data[_msgKey];
          _data = response.data[_dataKey];
        } else {
          Map<String, dynamic> _dataMap = _decodeData(response);
          _status = (_dataMap[_statusKey] is int)
              ? _dataMap[_statusKey].toString()
              : _dataMap[_statusKey];
          _code = (_dataMap[_codeKey] is String)
              ? int.tryParse(_dataMap[_codeKey])
              : _dataMap[_codeKey];
          _msg = _dataMap[_msgKey];
          _data = _dataMap[_dataKey];
        }
        return new BaseRespR(_status, _code, _msg, _data, response);
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

  /// Download the file and save it in local. The default http method is "GET",you can custom it by [Options.method].
  /// [urlPath]: The file url.
  /// [savePath]: The path to save the downloading file later.
  /// [onProgress]: The callback to listen downloading progress.please refer to [OnDownloadProgress].
  Future<Response> download(
    String urlPath,
    savePath, {
    OnDownloadProgress onProgress,
    CancelToken cancelToken,
    data,
    Options options,
  }) {
    return _dio.download(urlPath, savePath,
        onProgress: onProgress,
        cancelToken: cancelToken,
        data: data,
        options: options);
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

  /// check Options.
  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  /// merge Option.
  void _mergeOption(
    String method,
  ) {
    _options.method = method ?? _options.method;
    _options.headers = (new Map.from(_options.headers))..addAll(opt.headers);
    _options.receiveTimeout = opt.receiveTimeout ?? _options.receiveTimeout;
    _options.responseType = opt.responseType ?? _options.responseType;
    _options.contentType = opt.contentType ?? _options.contentType;
    _options.validateStatus = opt.validateStatus ?? _options.validateStatus;
    _options.followRedirects = opt.followRedirects ?? _options.followRedirects;
  }

  /// print Http Log.
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

  /// print Data Str.
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

  /// get dio.
  Dio getDio() {
    return _dio;
  }

  /// create new dio.
  static Dio createNewDio([Options options]) {
    options = options ?? getDefOptions();
    Dio dio = new Dio(options);
    return dio;
  }

  /// get Def Options.
  static Options getDefOptions() {
    Options options = new Options();
    options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    options.connectTimeout = 1000 * 10;
    options.receiveTimeout = 1000 * 20;
    options.responseType = ResponseType.JSON;
    return options;
  }
}
