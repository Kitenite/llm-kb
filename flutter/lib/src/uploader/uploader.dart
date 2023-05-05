import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:kb_ui/constants.dart';
import 'package:http_parser/http_parser.dart';

class FileUploader extends HookWidget {
  const FileUploader({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<PlatformFile?> uploadedFile = useState(null);

    Future<void> pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'txt',
          'pdf',
        ], // Add the extensions you want to allow
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        uploadedFile.value = file;
      } else {
        print('User canceled the file picker');
      }
    }

    uploadFile() async {
      var postUri = Uri.http(Constants.serverUrl, '/ingest_file');

      var request = http.MultipartRequest(
        "POST",
        postUri,
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          uploadedFile.value!.bytes!,
          contentType: MediaType('application', 'octet-stream'),
          filename: uploadedFile.value!.name,
        ),
      );
      request.fields.addAll(
        {
          'path': '/some/path',
        },
      );
      request.headers.addAll(
        {
          'Content-Type': 'application/json',
        },
      );

      var streamedResponse = await request.send();
      var result = await http.Response.fromStream(streamedResponse);
      print(result);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a file'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: pickFile,
                child: const Text('Pick a file'),
              ),
              const SizedBox(height: 20),
              Text(
                  'Selected file: ${uploadedFile.value?.name ?? 'No file selected'}'),
              ElevatedButton(
                onPressed: uploadFile,
                child: const Text('uploadFile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
