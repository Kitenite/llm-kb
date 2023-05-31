import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/api/server_api.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';

class FileUploader extends HookWidget {
  final FileSystemItem item;

  const FileUploader({
    super.key,
    required this.item,
  });

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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Upload a file',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: pickFile,
          child: const Text('Pick a file'),
        ),
        const SizedBox(height: 20),
        Text(
            'Selected file: ${uploadedFile.value?.name ?? 'No file selected'}'),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            if (uploadedFile.value != null) {
              ServerApiMethods.uploadFile(uploadedFile.value!).then((fileId) {
                print("File uploaded with id $fileId");

                final newItem = FileSystemItem.createFromAnotherFileSystemItem(
                    item,
                    name: "New pdf",
                    type: FileSystemItemType.pdf,
                    fsId: fileId,
                    tags: [
                      "pdf",
                    ]);

                print(newItem.toJson());
                ServerApiMethods.createFileSystemItem(newItem);
              });
            }
          },
          child: const Text('uploadFile'),
        ),
      ],
    );
  }
}
