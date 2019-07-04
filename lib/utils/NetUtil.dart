import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter1/utils/MessageUtil.dart';
import 'package:flutter1/utils/Msg.dart';

import 'LocalStorage.dart';

class NetUtil {
  static final TOKEN_KEY = "Authorization";
  static final debug = false;

  /// 服务器路径
  static final host = 'http://192.168.0.109:8080';
  static final baseUrl = host;

  ///  基础信息配置
  static final Dio _dio = new Dio(new BaseOptions(
      method: "get",
      baseUrl: baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 5000,
      followRedirects: true));

  static Future<T> getJson<T>(String uri, Map<String, dynamic> paras) =>
      _httpJson("get", uri, data: paras).then(logicalErrorTransform);

  static Future<T> getForm<T>(String uri, Map<String, dynamic> paras) =>
      _httpJson("get", uri, data: paras, dataIsJson: false)
          .then(logicalErrorTransform);

  /// 表单方式的post
  static Future<T> postForm<T>(String uri, Map<String, dynamic> paras) =>
      _httpJson("post", uri, data: paras, dataIsJson: false)
          .then(logicalErrorTransform);

  /// requestBody (json格式参数) 方式的 post
  static Future<T> postJson<T>(String uri, Map<String, dynamic> body) =>
      _httpJson("post", uri, data: body).then(logicalErrorTransform);

  static Future<T> deleteJson<T>(String uri, Map<String, dynamic> body) =>
      _httpJson("delete", uri, data: body).then(logicalErrorTransform);

  /// requestBody (json格式参数) 方式的 put
  static Future<T> putJson<T>(String uri, Map<String, dynamic> body) =>
      _httpJson("put", uri, data: body).then(logicalErrorTransform);

  /// 表单方式的 put
  static Future<T> putForm<T>(String uri, Map<String, dynamic> body) =>
      _httpJson("put", uri, data: body, dataIsJson: false)
          .then(logicalErrorTransform);

  /// 文件上传  返回json数据为字符串
  static Future<T> postFile<T>(String uri, String filePath) async {
    var name =
        filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    FormData formData = new FormData.from({
      "multipartFile": new UploadFileInfo(new File(filePath), name,
          contentType: ContentType.parse("image/$suffix"))
    });
    return _dio
        .put<Map<String, dynamic>>("$uri",
            data: formData,
            options: await getOptions("post", "multipart/form-data"))
        .then(logicalErrorTransform)
        .catchError((e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      DioError error = e as DioError;
      print(error.response);
      if (e.response) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    });
  }

  static Future<Response<Map<String, dynamic>>> _httpJson(
      String method, String uri,
      {Map<String, dynamic> data, bool dataIsJson = true}) async {
    // 判断网络

    /// 如果为 get方法，则进行参数拼接
    if (method == "get") {
      dataIsJson = false;
      if (data == null) {
        data = new Map<String, dynamic>();
      }
    }

    /// 根据当前 请求的类型来设置 如果是请求体形式则使用json格式
    /// 否则则是表单形式的（拼接在url上）
    Options op = await getOptions(method, "application/json");
    return _dio
        .request<Map<String, dynamic>>(uri, data: data, options: op)
        .catchError((e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      DioError error = e as DioError;
      String errMsg;
      switch (error.response.statusCode) {
        case 403:
          errMsg = "授权失败,请重新登录";
          break;
        case 404:
          errMsg = "未找到对应接口";
          break;
        case 500:
          errMsg = "服务器内部错误,请稍后重试";
          break;
      }
      MessageUtil.showErrorToast(errMsg);
    });
  }

  static Future<T> logicalErrorTransform<T>(
      Response<Map<String, dynamic>> resp) {
    return logicalErrorTransformInfo(resp, debug);
  }

  /// 对请求返回的数据进行统一的处理
  /// 如果成功则将我们需要的数据返回出去，否则进异常处理方法，返回异常信息
  static Future<T> logicalErrorTransformInfo<T>(
      Response<Map<String, dynamic>> resp, bool showTip) {
    if (resp != null) {
      if (debug) {
        print('resp--------$resp');
        print('resp.data--------${resp.data}');
      }
      Msg msg;
      switch (resp.data["code"]) {
        case 1:
          msg = Msg.full(1, resp.data["data"], resp.data["msg"]);
          if (showTip) MessageUtil.showErrorToast(msg.msg);
          break;
        case 2:
          msg = Msg.full(2, resp.data["data"], resp.data["msg"]);
          if (showTip) MessageUtil.showErrorToast(msg.msg);
          break;
        case 3:
          msg = Msg.full(3, resp.data["data"], resp.data["msg"]);
          if (showTip) MessageUtil.showErrorToast(msg.msg);
          break;
        case 4:
        default:
          msg = Msg.full(4, resp.data["data"], "系统内部错误");
          if (showTip) MessageUtil.showErrorToast(msg.msg);
          break;
      }
      if (msg.code == 1 || msg.code == 2) {
        return Future.value(msg.data);
      }
      return Future.error(msg.msg);
    }
  }

  static Future<Options> getOptions(String method, String contentType) async {
    Options op = new Options(contentType: ContentType.parse(contentType));
    op.method = method;

    /// 统一带上token
    String token = await LocalStorage.getToken();
    print("123$token");
    if (token != null && token != "") {
      var header = op.headers;
      header.addAll({TOKEN_KEY: token});
      op.headers = header;
    }
    return op;
  }
}
