import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerWidget extends StatefulWidget {
  @override
  _FilePickerWidgetState createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: pickFile,
            child: Text('Pick a file'),
          ),
          SizedBox(height: 20),
          Text('Selected file: ${_fileName ?? 'No file selected'}'),
        ],
      ),
    );
  }

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
      setState(() {
        _fileName = file.name;
      });
    } else {
      print('User canceled the file picker');
    }
  }
}
