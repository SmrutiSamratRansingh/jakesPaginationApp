import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';
import 'package:flutter/services.dart';
import 'package:jakes_git_app/datamodel/jake_model.dart';
import 'package:local_auth/local_auth.dart';

class ApiClient {
  final Dio dio = Dio();
  static final _auth = LocalAuthentication();

  ApiClient() {
    dio.interceptors.add(dioLoggerInterceptor);
  }

  Future<JakeDataResponse> getJakeData(int pageNo) async {
    try {
      Response response = await this.dio.get(
            "https://api.github.com/users/JakeWharton/repos?page=$pageNo&per_page=15",
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return JakeDataResponse.fromJson(response.data);
      } else {
        return JakeDataResponse.fromError("Error Occurred. Please try again.");
      }
    } catch (error) {
      print(error);
      if (error is DioError) {
        print('error is');
        print(error.message);
      }
      return JakeDataResponse.fromError("Error Occurred. Please try again.");
    }
  }

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    print(isAvailable);
    if (!isAvailable) {
      return false;
    } else {
      try {
        return await _auth.authenticate(
          biometricOnly: true,
          localizedReason: 'Scan Fingerprint to Authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
        );
      } on PlatformException catch (e) {
        print('platform exception is');
        print(e.message);
        return false;
      }
    }
  }
}
