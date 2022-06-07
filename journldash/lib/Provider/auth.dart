import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/UserInfo.dart';

class Auth with ChangeNotifier {
  String ?token;
  UserInfo? user;

  BaseOptions options = new BaseOptions(
    baseUrl: "http://192.168.43.250:8000",
    connectTimeout: 4000,
    receiveTimeout: 4000,
    contentType: 'application/json',
    validateStatus: (status) {
      return status! < 600;
    },
  );

  signIN(String email, String password) async {
    try {
      var dio = Dio(options);
      final url = '/api/v1/auth/login';

      Response response = await dio.post(url, data: {
        'email': email,
        'password': password,
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        token = response.data['token'];
        print(token);
        getUserData();
        return "success";
      } else {
        return response.data.errorMessage.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  getUserData() async {
    Dio dio = Dio(options);

    dio.options.headers["authorization"] = 'Bearer $token';
    Response response = await dio.post('/api/v1/auth/me');

    final data = response.data['data'];
    user = UserInfo.fromMap(data);
  }
}
