import 'package:dio/dio.dart';

class AljaredaConst {
  // ignore: non_constant_identifier_names
  static String NetworkBaseUrL = "http://192.168.252.52:8000";
  static String BasePicUrl = 'http://192.168.252.52:8000/uploads/photos/';

  BaseOptions option = BaseOptions(
    baseUrl: NetworkBaseUrL,
    connectTimeout: Duration(seconds:10 ),
    receiveTimeout: Duration(seconds: 10),
    contentType: 'application/json',
    validateStatus: (status) {
      return status! < 600;
    },
  );

  GetdioX() {
    return Dio(option);
  }
}
