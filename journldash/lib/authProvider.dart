import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'models/UserInfo.dart';

class AuthProvider with ChangeNotifier {
  UserInfo? user;
  String? token;

  BaseOptions options = new BaseOptions(
    baseUrl: "http://192.168.43.250:8000",
    connectTimeout: 8000,
    receiveTimeout: 8000,
      

    contentType: 'application/json',
    validateStatus: (status) {
      return status! < 600;
    },
  );

  updateUserImage(XFile image) async {
    try {
      var imagByts;

      Dio dio = Dio(options);
      dio.options.headers["authorization"] = 'Bearer $token';

      if (image != null) {
        imagByts = await image.readAsBytes();
      }
      FormData formData = FormData.fromMap({
        "userPhoto":
            image != null ? await MultipartFile.fromBytes(imagByts) : null,
      });

      //Continue from here

      Response response = await dio.put("/api/v1/auth/update", data: formData);
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data.toString());
        return 'success';
      } else {
        String error = response.data.errorMessage.toString();
        print(error);
        return error;
      }
    } catch (e) {
      print("$e error bitch");
      return e.toString();
    }
  }

  signIN(String email, String password) async {
    // try {
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
        await getUserData();
        print(user!.role);
        if (user!.role == 'journlist')
          return "success";
        else
          return 'غير مصرح';
      } else {
        return response.data["errorMessage"].toString();
      }
    // } catch (e) {
    //   return e.toString();
    // }
  }

  getUserData() async {
    Dio dio = Dio(options);

    dio.options.headers["authorization"] = 'Bearer $token';
    Response response = await dio.post('/api/v1/auth/me');

    final data = response.data['data'];
    user = UserInfo.fromMap(data);
    print(user!.id);
  }

  updateUserDes(String des) async {
    try {
      Dio dio = Dio(options);
      dio.options.headers["authorization"] = 'Bearer $token';

      //Continue from here

      Response response =
          await dio.put("/api/v1/auth/update", data: {"description": des});
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data.toString());
        await getUserData();
        return 'success';
      } else {
        return response.data["errorMessage"].toString();
      }
    } catch (e) {
      print("$e error bitch");
      return e.toString();
    }
  }
}
