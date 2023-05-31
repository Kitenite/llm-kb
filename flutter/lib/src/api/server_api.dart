import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kb_ui/constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';

class ServerApiMethods {
  static Future<void> createFileSystemItem(FileSystemItem item) async {
    final uri = Uri.http(ServerConstants.devServerUrl,
        ServerConstants.createFileSystemItemEndpoint);
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(item.toJson());
    final response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode != 200) {
      throw Exception('Failed to upload FileSystemItem.');
    }
  }

  static Future<void> updateFileSystemItem(FileSystemItem item) async {
    final uri = Uri.http(ServerConstants.devServerUrl,
        ServerConstants.updateFileSystemItemEndpoint);
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(item.toJson());
    final response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode != 200) {
      throw Exception('Failed to update FileSystemItem.');
    }
  }

  static Future<void> deleteFileSystemItem(String itemId) async {
    final uri = Uri.http(ServerConstants.devServerUrl,
        '${ServerConstants.deleteFileSystemItemEndpoint}/$itemId');
    final response = await http.delete(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete FileSystemItem.');
    }
  }

  static Future<List<FileSystemItem>> getFileSystemItems() async {
    final uri = Uri.http(ServerConstants.devServerUrl,
        ServerConstants.getFileSystemItemsEndpoint);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => FileSystemItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load FileSystemItems from server');
    }
  }

  static Future<String?> uploadFile(PlatformFile uploadedFile) async {
    var postUri = Uri.http(
        ServerConstants.devServerUrl, ServerConstants.ingestFileEndpoint);

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

    var streamedResponse = await request.send();
    var result = await http.Response.fromStream(streamedResponse);

    if (result.statusCode == 200) {
      var responseBody = jsonDecode(result.body);
      return responseBody['file_id'];
    } else {
      print(result.body);
      return null;
    }
  }
}
