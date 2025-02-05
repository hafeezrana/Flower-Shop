import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiCalls {
  static Future<dynamic> post({required String url, body, headers}) async {
    var uri = Uri.parse(url);
    log(url);
    final response = await http
        .post(uri, body: body, headers: headers)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw "Request time out";
    });

    log("status : ${response.statusCode}");
    final jsonData = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      return jsonData;
    } else {
      return null;
    }
  }

  static Future<dynamic> put({required String url, body, headers}) async {
    var uri = Uri.parse(url);
    log(url);
    final response = await http
        .put(uri, body: body, headers: headers)
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw "Request time out";
    });
    final jsonData = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      return jsonData;
    } else {
      return null;
    }
  }

  static Future<dynamic> patch({required String url, body, headers}) async {
    var uri = Uri.parse(url);
    log(url);
    final response = await http
        .patch(uri, body: body, headers: headers)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw "Request time out";
    });
    final jsonData = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      return jsonData;
    } else {
      return null;
    }
  }

  static Future<dynamic> delete({required String url, body, headers}) async {
    var uri = Uri.parse(url);
    log(url);
    final response = await http
        .delete(uri, body: body, headers: headers)
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw "Request time out";
    });
    final jsonData = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      return jsonData;
    } else {
      return null;
    }
  }

  static Future<dynamic> get({
    required String url,
    Map<String, String>? queryParams, // Change the value type to String
    headers,
  }) async {
    var uri = Uri.parse(url).replace(queryParameters: queryParams);
    log(uri.queryParameters.toString());
    final response = await http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 15), onTimeout: () {
      throw "Request time out";
    });
    log("response: ${response.body}");
    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return jsonData;
    } else {}
  }

  static Future<dynamic> uploadFile({
    required String url,
    required File file,
    String fieldName = "file",
  }) async {
    var uri = Uri.parse(url);
    log(url);

    var request = http.MultipartRequest('POST', uri);

    var fileStream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile =
        http.MultipartFile(fieldName, fileStream, length, filename: file.path);

    // if (headers != null) {
    //   request.headers.addAll(headers);
    // }
    //
    // if (body != null) {
    //   request.fields.addAll(body);
    // }

    request.files.add(multipartFile);

    final response = await request.send().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw "Request time out";
      },
    );

    final responseJson = await response.stream.bytesToString();
    log(responseJson);
    log(responseJson);

    if (response.statusCode == 200) {
      return jsonDecode(responseJson);
    } else {
      return null;
    }
  }

  static Future multipartRequest(
      String url, Map<String, String> body, String methodName,
      {Map<String, String>? header, File? image, String? imageKey}) async {
    var client = http.Client();
    try {
      String fullURL = url;

      log('API body: $body');
      log('API header: $header');

      var request = http.MultipartRequest(methodName, Uri.parse(fullURL));
      request.headers.addAll(header!);
      request.fields.addAll(body);
      if (image != null) {
        request.files.add(
            await http.MultipartFile.fromPath(imageKey!, image.absolute.path));
      }

      http.StreamedResponse response = await request.send();

      log('Response status: ${response.statusCode}');

      String jsonDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonDataString);

      // if (jsonData["status"] == "Fail") {
      //   throw AppException(message: jsonData['message'], errorCode: 0);
      // }

      return jsonData;
    } catch (exception) {
      client.close();
      rethrow;
    }
  }

  static Future multipartRequest2(
    String url,
    Map<String, String> body,
    String methodName, {
    Map<String, String>? header,
    List<File>? images,
    String? imageKey,
  }) async {
    var client = http.Client();
    try {
      String fullURL = url;

      log('API Url: $fullURL', level: 1);
      log('API body: $body');
      log('API header: ${images}');

      var request = http.MultipartRequest(methodName, Uri.parse(fullURL));
      request.headers.addAll(header!);
      request.fields.addAll(body);
      List<String> subAdPaths = [];

      if (images != null && images.isNotEmpty) {
        images.forEach((va) {
          subAdPaths.add(va.absolute.path);
        });
        log('paths: ${subAdPaths.join(',')}');
        for (int i = 0; i < subAdPaths.length; i++) {
          final imageFile = subAdPaths[i]; // Access image using its index
          final imageKey = "images[]"; // Use index for each image key
          request.files.add(
            await http.MultipartFile.fromPath(imageKey, imageFile),
          );
        }
      }

      http.StreamedResponse response = await request.send().timeout(
        const Duration(seconds: 50),
        onTimeout: () {
          throw "Request time out";
        },
      );

      String jsonDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonDataString);
      log('Response data: ${jsonDataString}');

      // if (jsonData["status"] == "Fail") {
      //   throw AppException(message: jsonData['message'], errorCode: 0);
      // }

      return jsonData;
    } catch (exception) {
      client.close();
      rethrow;
    }
  }
}
