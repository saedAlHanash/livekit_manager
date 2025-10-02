import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:logger/logger.dart';
import 'package:m_cubit/util.dart';

import '../strings/enum_manager.dart';
import '../util/shared_preferences.dart';
import 'helpers_api/helper_api_service.dart';
import 'helpers_api/log_api.dart';

var loggerObject = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    // number of method calls to be displayed
    errorMethodCount: 0,
    // number of method calls if stacktrace is provided
    lineLength: 300,
    // width of the output
    colors: true,
    // Colorful log messages
    printEmojis: false,
  ),
);

class APIService {
  static final APIService _singleton = APIService._internal();

  APIService._internal() {
    Timer.periodic(Duration(seconds: 30), (t) => serverTime = serverTime.addFromNow(second: 30));
  }

  DateTime serverTime = DateTime.now().toUtc();

  factory APIService() => _singleton;

  Map<String, String> get innerHeader {
    return {
      'Content-Type': 'Application/json',
      'Accept': 'Application/json',
      'accept-language': AppSharedPreference.getLocal,
      'Authorization': 'Bearer ${AppSharedPreference.getToken}',
    };
  }

  Future<http.Response> callApi({
    required String url,
    required ApiType type,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? header,
    String? path,
    String? hostName,
  }) async {
    // if (!await network.isConnected) noInternet;

    fixQuery(query);

    fixBody(body);

    final uri = getUri(url: url, hostName: hostName, query: query, path: path, body: body, type: type);

    try {
      late final http.Response response;

      switch (type) {
        case ApiType.get:
          response = await http
              .get(uri, headers: (header ?? innerHeader))
              .timeout(connectionTimeOut, onTimeout: () => timeOut);
        case ApiType.post:
          response = await http
              .post(uri, body: jsonEncode(body), headers: (header ?? innerHeader))
              .timeout(connectionTimeOut, onTimeout: () => timeOut);
        case ApiType.put:
          response = await http
              .put(uri, body: jsonEncode(body), headers: (header ?? innerHeader))
              .timeout(connectionTimeOut, onTimeout: () => timeOut);
        case ApiType.patch:
          response = await http
              .patch(uri, body: jsonEncode(body), headers: (header ?? innerHeader))
              .timeout(connectionTimeOut, onTimeout: () => timeOut);
        case ApiType.delete:
          response = await http
              .delete(uri, body: jsonEncode(body), headers: (header ?? innerHeader))
              .timeout(connectionTimeOut, onTimeout: () => timeOut);
      }

      logResponse(url: url, response: response, type: type);

      try {
        serverTime = kIsWeb ? DateTime.now().toUtc() : response.serverTime;
      } catch (e) {
        loggerObject.e('serverTime:$e');
      }

      return response;
    } catch (e) {
      loggerObject.e('API service: $e');
      return anError;
    }
  }

  Future<http.Response> uploadMultiPart({
    required String url,
    String? path,
    String type = 'POST',
    List<UploadFile?>? files,
    Map<String, dynamic>? fields,
    String? hostName,
  }) async {
    for (var i = 0; i < (files ?? []).length; i++) {
      fields?['File$i'] = files![i]!.fileBytes?.length.toString();
    }

    final uri = getUri(url: url, hostName: hostName, query: fields, path: path, type: ApiType.post);

    var request = http.MultipartRequest(type, uri);

    for (var uploadFile in (files ?? <UploadFile?>[])) {
      if (uploadFile?.fileBytes == null) continue;

      final multipartFile = http.MultipartFile.fromBytes(
        uploadFile!.nameField,
        uploadFile.fileBytes!,
        filename: '${getRandomString(10)}.${uploadFile.type ?? 'jpg'}',
      );

      request.files.add(multipartFile);
    }

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers.addAll(innerHeader);
    request.fields.addAll(fixFields(fields));

    final stream = await request.send().timeout(
      const Duration(seconds: 40),
      onTimeout: () => http.StreamedResponse(Stream.value([]), 481),
    );

    final response = await http.Response.fromStream(stream);

    logResponse(url: url, response: response, type: ApiType.post);

    return response;
  }
}

class UploadFile {
  UploadFile({
    this.fileBytes,
    this.initialImage,
    this.nameField = 'File',
    this.assetImage = '',
    this.tempId,
    this.type,
  });

  Uint8List? fileBytes;
  String nameField;
  String? initialImage;
  dynamic assetImage;
  String? tempId;
  String? type;

  dynamic get getImage => fileBytes ?? (initialImage.isBlank ? null : initialImage) ?? assetImage;

  UploadFile copyWith({Uint8List? fileBytes, String? nameField}) {
    return UploadFile(fileBytes: fileBytes ?? this.fileBytes, nameField: nameField ?? this.nameField);
  }

  Map<String, dynamic> toJson() {
    return {'fileBytes': fileBytes, 'nameField': nameField};
  }

  factory UploadFile.fromJson(Map<String, dynamic> map) {
    return UploadFile(fileBytes: map['fileBytes'] ?? Uint8List.fromList([]), nameField: map['nameField'] ?? '');
  }
}
