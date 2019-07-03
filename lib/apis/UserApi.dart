import 'package:flutter1/utils/LocalStorage.dart';
import 'package:flutter1/utils/NetUtil.dart';

class UserApi {
  static Future<String> login(String username, String password) {
    Map<String, String> paras = Map();
    paras.addAll({"username": username, "password": password});
    return NetUtil.postJson("/user/login", paras).then((token) {
      LocalStorage.saveString(LocalStorage.SAVED_TOKEN_KEY,token);
      print("user:$username token:$token");
      Future<String> savedToken = LocalStorage.getString(LocalStorage.SAVED_TOKEN_KEY);
      savedToken.then(print);
      return Future.value(token);
    });
  }
}
