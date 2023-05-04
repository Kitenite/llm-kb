import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FileUploader extends HookWidget {
  const FileUploader({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<PlatformFile?> uploaded_file = useState(null);

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
        uploaded_file.value = file;
      } else {
        print('User canceled the file picker');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a file'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
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
                  'Selected file: ${uploaded_file.value?.name ?? 'No file selected'}'),
            ],
          ),
        ),
      ),
    );
  }
}
