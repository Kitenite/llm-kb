import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';

class DataIngestionSideBar extends HookWidget {
  final double width;
  final List<FileSystemItem> items;

  const DataIngestionSideBar({
    Key? key,
    required this.width,
    required this.items,
  }) : super(key: key);

  // Recursive function to build the directory structure
  Widget buildDirectory(BuildContext context, Map<String, dynamic> data,
      ValueNotifier<MapEntry<String, int>> selectedItem,
      [double padding = 16.0]) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: data.entries.map((entry) {
        final isFolder = entry.value is Map<String, dynamic>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isFolder
                ? ExpansionTile(
                    textColor: Theme.of(context).textTheme.bodyLarge?.color,
                    iconColor: Theme.of(context).iconTheme.color,
                    title: ListTile(
                      contentPadding: EdgeInsets.only(left: padding),
                      leading: Icon(Icons.folder),
                      title: Text(entry.key),
                      selected: selectedItem.value.key == entry.key &&
                          selectedItem.value.value == padding,
                      onTap: () {
                        selectedItem.value =
                            MapEntry(entry.key, padding.toInt());
                        // Handle folder navigation or action
                      },
                    ),
                    children: [
                      buildDirectory(
                          context, entry.value, selectedItem, padding + 16.0),
                    ],
                  )
                : ListTile(
                    contentPadding: EdgeInsets.only(left: padding + 16),
                    leading: Icon(Icons.insert_drive_file),
                    title: Text(entry.key),
                    selected: selectedItem.value.key == entry.key &&
                        selectedItem.value.value == padding,
                    onTap: () {
                      selectedItem.value = MapEntry(entry.key, padding.toInt());
                      // Handle file action
                    },
                  ),
          ],
        );
      }).toList(),
    );
  }

  Map<String, dynamic> buildTree(List<FileSystemItem> items) {
    final tree = <String, dynamic>{};

    for (final item in items) {
      final parts = item.path.split('/');
      Map<String, dynamic> currentLevel = tree;

      for (int i = 0; i < parts.length; i++) {
        final part = parts[i];

        if (i == parts.length - 1) {
          currentLevel[part] = item.isDirectory ? <String, dynamic>{} : null;
        } else {
          currentLevel =
              currentLevel.putIfAbsent(part, () => <String, dynamic>{});
        }
      }
    }

    return tree;
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem =
        useState<MapEntry<String, int>>(const MapEntry('', -1));
    final directoryStructure = buildTree(items);

    return SizedBox(
      width: width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            buildDirectory(
              context,
              directoryStructure,
              selectedItem,
            ),
          ],
        ),
      ),
    );
  }
}
