import 'package:dio/dio.dart';

class HttpService {
  late Dio dio;
  static final HttpService _instance = HttpService._();
  factory HttpService() {
    return _instance;
  }
  HttpService._() : dio = _configureDio();

  static Dio _configureDio() {
    final options = BaseOptions(
      baseUrl: 'http://localhost:8000/default/todo',
    );
    return Dio(options);
  }
}
