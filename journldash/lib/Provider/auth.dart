import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:journldash/utils/const.dart';

import '../models/UserInfo.dart';

class Auth with ChangeNotifier {
  String ?token;
  UserInfo? user;


  signIN(String email, String password) async {
    try {
      Dio dio = AljaredaConst().GetdioX();
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
      Dio dio = AljaredaConst().GetdioX();

    dio.options.headers["authorization"] = 'Bearer $token';
    Response response = await dio.post('/api/v1/auth/me');

    final data = response.data['data'];
    user = UserInfo.fromMap(data);
  }
}
