import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/api/server_api.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';
import 'dart:convert';

class DataIngestionEditView extends HookWidget {
  final FileSystemItem item;

  const DataIngestionEditView({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jsonController = useTextEditingController();
    final isValidJson = useState(true);

    useEffect(() {
      jsonController.text = prettyPrintJson((item.toJson()));
      return null;
    }, [item]);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: jsonController,
            maxLines: null,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: !isValidJson.value ? Colors.red : Colors.blue),
              ),
              border: const OutlineInputBorder(),
              labelText: 'JSON Input',
            ),
            onChanged: (value) => isValidJson.value = validateJson(value),
          ),
          if (!isValidJson.value)
            const Text(
              'Invalid JSON input',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (!isValidJson.value) {
                    return;
                  }
                  // Update the item with the new JSON
                  var jsonData = jsonDecode(jsonController.text);
                  final newItem = FileSystemItem.fromJson(jsonData);
                  // Do something here
                  ServerApiMethods.updateFileSystemItem(newItem);
                },
                child: const Text('Update item'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  ServerApiMethods.deleteFileSystemItem(item.id);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red, // This is the color of the text
                ),
                child: const Text('Delete item'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

String prettyPrintJson(Map<String, dynamic> json) {
  var encoder = const JsonEncoder();
  String jsonString = encoder.convert(json);
  jsonString = jsonString.replaceAll('{', '{\n');
  jsonString = jsonString.replaceAll('}', '\n}');
  jsonString = jsonString.replaceAll(',', ',\n');
  return jsonString;
}

bool validateJson(String value) {
  try {
    var jsonData = jsonDecode(value);
    print(jsonData);
    return true;
  } catch (e) {
    print('The string is not a valid JSON: $e');
    return false;
  }
}
