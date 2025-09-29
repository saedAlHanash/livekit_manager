// Future<String> fileUploadMultipart(
//     {File file, OnUploadProgressCallback onUploadProgress}) async {
//   assert(file != null);
//
//   final url = '$baseUrl/api/file';
//
//   final httpClient = getHttpClient();
//
//   final request = await httpClient.postUrl(Uri.parse(url));
//
//   int byteCount = 0;
//
//   var multipart =
//       await http.MultipartFile.fromPath(fileUtil.basename(file.path), file.path);
//
// // final fileStreamFile = file.openRead();
//
// // var multipart = MultipartFile("file", fileStreamFile, file.lengthSync(),
// //     filename: fileUtil.basename(file.path));
//
//   var requestMultipart = http.MultipartRequest("", Uri.parse("uri"));
//
//   requestMultipart.files.add(multipart);
//
//   var msStream = requestMultipart.finalize();
//
//   var totalByteLength = requestMultipart.contentLength;
//
//   request.contentLength = totalByteLength;
//
//   request.headers.set(HttpHeaders.contentTypeHeader,
//       requestMultipart.headers[HttpHeaders.contentTypeHeader]);
//
//   Stream<List<int>> streamUpload = msStream.transform(
//     new StreamTransformer.fromHandlers(
//       handleData: (data, sink) {
//         sink.add(data);
//
//         byteCount += data.length;
//
//         if (onUploadProgress != null) {
//           onUploadProgress(byteCount, totalByteLength);
// // CALL STATUS CALLBACK;
//         }
//       },
//       handleError: (error, stack, sink) {
//         throw error;
//       },
//       handleDone: (sink) {
//         sink.close();
// // UPLOAD DONE;
//       },
//     ),
//   );
//
//   await request.addStream(streamUpload);
//
//   final httpResponse = await request.close();
// //
//   var statusCode = httpResponse.statusCode;
//
//   if (statusCode ~/ 100 != 2) {
//     throw Exception('Error uploading file, Status code: ${httpResponse.statusCode}');
//   } else {
//     return await readResponseAsString(httpResponse);
//   }
// }
