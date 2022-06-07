import 'dart:convert';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../models/Article.dart';
import '../models/UserInfo.dart';

class ArticlePrvider with ChangeNotifier {
  String? articleType;
  UserInfo? user;
  String? token;
  String? articleHtmlText;

  List? journlistArticles;

  BaseOptions options = new BaseOptions(
    baseUrl: "http://192.168.43.250:8000",
    connectTimeout: 8000,
    receiveTimeout: 8000,
    contentType: 'application/json',
    validateStatus: (status) {
      return status! < 600;
    },
  );

  _pickHtmFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      return file;
    } else {
      // User canceled the picker
    }
  }

  _write(String text, String title) async {
// prepare
    final bytes = utf8.encode(text);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$title ${DateTime.now()}.htm';
    html.document.body!.children.add(anchor);

// download
    anchor.click();

// cleanup
    html.document.body!.children.remove(anchor);
  }

  createAnArticle(String title, String des, String category, String place,
      List<Uint8List>? images) async {
    try {
      //Dio option config
      if (place == null) {
        place = '';
      }

      var imagByts;
      Dio dio = Dio(options);
      dio.options.headers["authorization"] = 'Bearer $token';
      List<MultipartFile> assets = [];

      if (images != null) {
        for (int i = 0; i < images.length; i++) {
          MultipartFile image = MultipartFile.fromBytes(images[i],
              filename: DateTime.now().toString(),
              contentType: MediaType('image', 'xyz'));

          assets.add(image);
        }
      }
      print(assets);

      await _write(des, title);
      final file = await _pickHtmFile();
      // if (image != null) {
      //   imagByts = await image.readAsBytes();
      // }

      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(file.bytes),
        "title": title,
        // "photoFile":
        //     image != null ? await MultipartFile.fromBytes(imagByts) : null,
        "assets": assets.length == 1 ? assets.toList() : assets,
        "articletype": ["$articleType"],
        "category": [category],
        "place": place
      });

      print({
        "file": MultipartFile.fromBytes(file.bytes),
        "title": title,
        // "photoFile":
        //     image != null ? await MultipartFile.fromBytes(imagByts) : null,
        "assets": assets,
        "articletype": ["$articleType"],
        "category": [category],
        "place": place
      });
      //Continue from here

      Response response =
          await dio.post("/api/v1/articles/assets", data: formData);
      print(response.data);
      if (response.statusCode == 201) {
        print(response.data.toString());
        return 'success';
      } else {
        String error = response.data["errorMessage"].toString();
        print(error);
        return error;
      }
    } catch (e) {
      print("$e error bitch");
      return e.toString();
    }
  }

  createNew(String title, String des, String category, String place,
      Uint8List? image) async {
    try {
      //Dio option config
      if (place == null) {
        place = '';
      }
      var imagByts;
      Dio dio = Dio(options);
      dio.options.headers["authorization"] = 'Bearer $token';

      await _write(des, title);
      final file = await _pickHtmFile();
      // if (image != null) {
      //   imagByts = await image.readAsBytes();
      // }

      print({
        "file": MultipartFile.fromBytes(file.bytes),
        "title": title,
        "photoFile": image != null ? MultipartFile.fromBytes(image) : null,
        "articletype": ["$articleType"],
        "category": [category],
        "place": place
      });

      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(file.bytes),
        "title": title,
        "photoFile": image != null ? MultipartFile.fromBytes(image) : null,
        "articletype": ["$articleType"],
        "category": [category],
        "place": place
      });

      //Continue from here

      Response response = await dio.post("/api/v1/articles", data: formData);
      print(response.data);
      if (response.statusCode == 201) {
        print(response.data.toString());
        return 'success';
      } else {
        String error = response.data["errorMessage"].toString();
        print(error);
        return error;
      }
    } catch (e) {
      print("$e error bitch");
      return e.toString();
    }
  }

  breakingNews(String headLine) async {
    try {
      Dio dio = Dio(options);
      dio.options.headers["authorization"] = 'Bearer $token';

      var formData = {
        "title": headLine,
        "articletype": ["$articleType"]
      };

      //Continue from here

      Response response = await dio.post("/api/v1/articles", data: formData);

      if (response.statusCode == 201) {
        return 'success';
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

  createGame(
    List<String> rowWords,
    List<String> columnWords,
    List<String> rowQes,
    List<String> columnQes,
  ) async {
    Dio dio = Dio(options);

    dio.options.headers["authorization"] = 'Bearer $token';
    Response response = await dio.post('/api/v1/games/crossword', data: {
      "rowsWords": rowWords,
      "columnsWords": columnWords,
      "rowsQuestions": rowQes,
      "columnsQuestions": columnQes
    });

    try {
      if (response.statusCode == 201) {
        return "success";
      } else {
        return response.data;
      }
    } catch (e) {
      return "$e";
    }
  }

  getJournlistArticles(String id, String token) async {
    //Dio option config

    // var calendarTime = CalendarTime(DateTime.now());

    // var dayBefore = calendarTime.startOfToday.subtract(Duration(days: 1));
    // var dayEnd = calendarTime.endOfToday;

    Dio dio = Dio(options);
    dio.options.headers["authorization"] = 'Bearer $token';
    Response response = await dio.get("/api/v1/articles/journlistarticles",
        queryParameters: {'user': id});
    if (response.statusCode == 200) {
      final map = response.data['data'];

      journlistArticles = map.map((i) => ArticleModel.fromMap(i)).toList();
      // DateTime

      return 'success';
    } else {
      String error = response.data['errorMessage'].toString();
      return error;
    }
  }

  Future<String> getHtml(ArticleModel articleModel) async {
    Dio dio = Dio(options);

    Response htmlPage =
        await dio.get('/uploads/htmlarticles/' + articleModel.description!);
    articleHtmlText = htmlPage.data;
    return 'success';
  }
}
