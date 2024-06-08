import 'package:cookie_jar/cookie_jar.dart';

class MyCookieManager {
  static final MyCookieManager _instance = MyCookieManager._internal();
  late CookieJar cookieJar;

  factory MyCookieManager() {
    return _instance;
  }

  MyCookieManager._internal() {
    cookieJar = CookieJar(); // 또는 PersistCookieJar로 영구 저장
  }

  static MyCookieManager get instance => _instance;
}
