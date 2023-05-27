import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kb_ui/constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';

class ServerApiMethods {
  static Future<void> uploadFileSystemItem(FileSystemItem item) async {
    final uri = Uri.http(ServerConstants.serverUrl,
        ServerConstants.createFileSystemItemEndpoint);
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(item.toJson());
    final response = await http.post(uri, headers: headers, body: body);
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to upload FileSystemItem.');
    }
  }

  // Will be removed soon
  static Future<bool> uploadFile(
      PlatformFile uploadedFile, FileSystemItem item) async {
    var postUri =
        Uri.http(ServerConstants.serverUrl, ServerConstants.ingestFileEndpoint);

    var request = http.MultipartRequest(
      "POST",
      postUri,
    );
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        uploadedFile.bytes!,
        contentType: MediaType('application', 'octet-stream'),
        filename: uploadedFile.name,
      ),
    );
    request.fields.addAll(
      {
        'file_system_item': jsonEncode(item.toJson()),
      },
    );
    request.headers.addAll(
      {
        'Content-Type': 'application/json',
      },
    );

    var streamedResponse = await request.send();
    var result = await http.Response.fromStream(streamedResponse);
    print(result.body);
    return Future.value(result.statusCode == 200);
  }
}
