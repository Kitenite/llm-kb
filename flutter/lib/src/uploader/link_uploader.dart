import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/api/server_api.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';

class LinkUploader extends HookWidget {
  final FileSystemItem item;

  const LinkUploader({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController linkController = useTextEditingController();

    Future<void> uploadLink() async {
      String link = linkController.text;

      if (link.isEmpty) {
        print('No link to upload');
      } else {
        final newItem = FileSystemItem.createFromAnotherFileSystemItem(item,
            name: "New link",
            type: FileSystemItemType.link,
            url: linkController.text,
            tags: [
              "link",
            ]);

        print(newItem.toJson());
        ServerApiMethods.createFileSystemItem(newItem);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Upload a link',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: linkController,
          decoration: const InputDecoration(
            labelText: 'Enter a link',
          ),
        ),
        const SizedBox(height: 20),
        Text(
            'Selected link: ${linkController.text.isEmpty ? 'No link selected' : linkController.text}'),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: uploadLink,
          child: const Text('Upload Link'),
        ),
      ],
    );
  }
}
