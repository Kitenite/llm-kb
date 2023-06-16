import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/api/server_api.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';

class GithubUploader extends HookWidget {
  final FileSystemItem item;

  const GithubUploader({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController linkController = useTextEditingController();
    final ValueNotifier<bool> isLinkValid = useState(true);

    bool isValidLink(String link) {
      if (link.isEmpty) {
        return false;
      }

      // Check if the link is valid
      Uri? uri;
      try {
        uri = Uri.parse(link);
      } catch (e) {
        return false;
      }

      // Check if the URL has a scheme (like https) and a host (like google.com)
      if (!(uri.isAbsolute && uri.hasScheme && uri.hasAuthority)) {
        return false;
      }

      return true;
    }

    Future<void> uploadLink() async {
      String link = linkController.text;

      if (link.isEmpty) {
        print('No link to upload');
        return;
      }

      // Check if the link is valid
      Uri? uri;
      try {
        uri = Uri.parse(link);
      } catch (e) {
        print('Invalid link: $e');
        isLinkValid.value = false;
        return;
      }

      // Check if the URL has a scheme (like https) and a host (like google.com)
      if (!(uri.isAbsolute && uri.hasScheme && uri.hasAuthority)) {
        print('Invalid link: Missing scheme or host');
        isLinkValid.value = false;
        return;
      }

      // Reset the validation status
      isLinkValid.value = true;

      final newItem = FileSystemItem.createFromAnotherFileSystemItem(item,
          name: "New repo",
          type: FileSystemItemType.github,
          url: linkController.text,
          tags: [
            "github",
          ]);

      print(newItem.toJson());
      ServerApiMethods.createFileSystemItem(newItem);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Upload a Github repo link',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: linkController,
            onChanged: (value) => isLinkValid.value = isValidLink(value),
            decoration: InputDecoration(
              labelText: 'Enter the link',
              errorText: isLinkValid.value ? null : 'Invalid link',
              hintText: 'https://github.com/Kitenite/llm-kb/',
            ),
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
          child: const Text('Upload Repo'),
        ),
      ],
    );
  }
}
