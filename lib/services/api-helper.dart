import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class ApiHelper {
  
  static final Dio _dio = Dio(BaseOptions(connectTimeout: 5000, receiveTimeout: 15000));

  static Dio get dio {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };
    return _dio;
  }
}
