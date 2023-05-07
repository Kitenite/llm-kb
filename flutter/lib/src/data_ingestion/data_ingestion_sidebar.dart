import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';
import 'package:kb_ui/src/file_system/file_tree_item.dart';

class DataIngestionSideBar extends HookWidget {
  final double width;
  final List<FileSystemItem> items;
  final ValueNotifier<String> selectedItem;

  const DataIngestionSideBar({
    Key? key,
    required this.width,
    required this.items,
    required this.selectedItem,
  }) : super(key: key);

  // Recursive function to build the directory structure
  Widget buildDirectory(BuildContext context, FileTreeNode root,
      ValueNotifier<String> selectedItem,
      [double padding = 16.0]) {
    bool isItemSelected(selectedItem, entry) {
      return selectedItem.value == entry.item.id;
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: root.children.entries.map((entry) {
        final isFolder = entry.value.item.isDirectory;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isFolder
                ? ExpansionTile(
                    initiallyExpanded: true,
                    textColor: Theme.of(context).textTheme.bodyLarge?.color,
                    iconColor: Theme.of(context).iconTheme.color,
                    title: ListTile(
                      contentPadding: EdgeInsets.only(left: padding),
                      leading: isItemSelected(selectedItem, entry.value)
                          ? const Icon(Icons.folder)
                          : const Icon(Icons.folder_outlined),
                      title: Text(entry.value.item.name == ''
                          ? root.item.name
                          : entry.value.item.name),
                      selected: isItemSelected(selectedItem, entry.value),
                      onTap: () {
                        selectedItem.value = entry.value.item.id;
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
                    leading: isItemSelected(selectedItem, entry.value)
                        ? const Icon(Icons.insert_drive_file)
                        : const Icon(Icons.insert_drive_file_outlined),
                    title: Text(entry.value.item.name),
                    selected: isItemSelected(selectedItem, entry.value),
                    onTap: () {
                      selectedItem.value = entry.value.item.id;
                      // Handle file action
                    },
                  ),
          ],
        );
      }).toList(),
    );
  }

  FileTreeNode buildTree(List<FileSystemItem> items) {
    final tree = <String, FileTreeNode>{};

    for (final item in items) {
      final parts = item.path.split('/');
      Map<String, FileTreeNode> currentLevel = tree;

      for (int i = 0; i < parts.length; i++) {
        final part = parts[i];

        if (i == parts.length - 1) {
          currentLevel[part] = FileTreeNode(item: item);
        } else {
          if (!currentLevel.containsKey(part)) {
            final newDirectory = FileSystemItem(
              id: '',
              name: part,
              type: FileSystemItemType.directory,
              parentId: i > 0 ? parts[i - 1] : '',
              path: parts.sublist(0, i + 1).join('/'),
              size: 0,
              content: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            currentLevel[part] = FileTreeNode(item: newDirectory);
          }

          currentLevel = currentLevel[part]!.children;
        }
      }
    }

    // Create a root FileTreeItem to hold the tree.values.toList()
    return FileTreeNode(
      item: FileSystemItem(
        id: '-1',
        name: 'Root',
        type: FileSystemItemType.directory,
        parentId: '',
        path: '',
        size: 0,
        content: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      children: tree,
    );
  }

  @override
  Widget build(BuildContext context) {
    final directoryStructure = buildTree(items);
    return SizedBox(
      width: width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
