import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gemini_chat/core/constants/app_secret.dart';
import 'package:gemini_chat/core/repository/base_remote_repository.dart';
import 'package:http/http.dart' as http;

import 'exception/api_exception.dart';

class HttpService extends BaseRemoteRepository {
  @override
  Future post(
    String url,
    String jsonData, {
    bool passToken = true,
  }) async {
    http.Response? response;

    Map<String, String> headers;

    try {
      headers = await returnHeader(passToken: passToken);

      response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonData,
      );
    } on Exception catch (e) {
      throwExceptionTypeWise(e);
    }

    return returnResponse(response);
  }

  dynamic returnHeader({required bool passToken}) async {
    Map<String, String> headers = {};
    if (passToken) {
      headers["Authorization"] = yourGeminiAPIKey;
    }
    headers["Content-Type"] = "application/json";
    //headers["Accept"] = "application/json";

    return headers;
  }

  dynamic returnResponse(http.Response? response) {
    if (response != null) {
      if (kDebugMode) {
        debugPrint('${response.request?.url} : ${response.statusCode}');
      }

      switch (response.statusCode) {
        case 200:
          if (response.body != '') {
            // debugPrint('------ ${jsonDecode(response.body)}');
            return jsonDecode(response.body);
          } else {
            return null;
          }
        case 204:
          return {"error": "handle your self"};
        case 400:
          return response.headers['error-message'] ?? "";
        case 401:
          throw UnauthorisedException("unauthorized");
        case 403:
          throw UnauthorisedException("unauthorized");
        case 404:
          throw FetchDataException(
            message: 'With status code ${response.statusCode}',
          );
        case 500:
        default:
          throw FetchDataException(
            message: 'With status code ${response.statusCode}',
          );
      }
    } else {
      throw FetchDataException(message: 'No Internet Connection');
    }
  }

  throwExceptionTypeWise(Exception e) {
    if (e is SocketException) {
      throw FetchDataException(message: 'Poor Internet Connection');
    } else if (e is FormatException) {
      throw FetchDataException(message: 'Bad response format');
    } else {
      throw FetchDataException(message: e.toString());
    }
  }
}
