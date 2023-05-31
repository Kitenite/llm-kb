import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_view.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';
import 'package:kb_ui/src/file_system/file_tree_item.dart';

class DataIngestionSideBar extends HookWidget {
  final double width;
  final List<FileSystemItem> items;
  final ValueNotifier<String> selectedItem;
  final ValueNotifier<DataIngestionMode> mode;

  const DataIngestionSideBar({
    Key? key,
    required this.width,
    required this.items,
    required this.selectedItem,
    required this.mode,
  }) : super(key: key);

  // Recursive function to build the directory structure
  Widget buildDirectory(BuildContext context, FileTreeNode root,
      ValueNotifier<String> selectedItem,
      [double padding = 16.0]) {
    bool isItemSelected(selectedItem, entry) {
      return selectedItem.value == entry.item.id;
    }

    Icon getIconForFileSystemItem(FileSystemItem item,
        {bool isOutlined = false}) {
      IconData iconData;
      switch (item.type) {
        case FileSystemItemType.directory:
          iconData = isOutlined ? Icons.folder_outlined : Icons.folder;
          break;
        case FileSystemItemType.pdf:
          iconData =
              isOutlined ? Icons.picture_as_pdf_outlined : Icons.picture_as_pdf;
          break;
        case FileSystemItemType.link:
          iconData = isOutlined ? Icons.link : Icons.link;
          break;
        default:
          iconData = isOutlined
              ? Icons.insert_drive_file_outlined
              : Icons.insert_drive_file;
          break;
      }
      return Icon(iconData);
    }

    return ListView(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
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
                      leading: getIconForFileSystemItem(entry.value.item,
                          isOutlined:
                              !isItemSelected(selectedItem, entry.value)),
                      title: Text(entry.value.item.name == ''
                          ? root.item.name
                          : entry.value.item.name),
                      selected: isItemSelected(selectedItem, entry.value),
                      onTap: () {
                        selectedItem.value = entry.value.item.id;
                        mode.value = DataIngestionMode.view;
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
                    leading: getIconForFileSystemItem(entry.value.item,
                        isOutlined: !isItemSelected(selectedItem, entry.value)),
                    title: Text(entry.value.item.name),
                    selected: isItemSelected(selectedItem, entry.value),
                    onTap: () {
                      selectedItem.value = entry.value.item.id;
                      mode.value = DataIngestionMode.view;
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
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                tags: []);

            currentLevel[part] = FileTreeNode(item: newDirectory);
          }

          currentLevel = currentLevel[part]!.children;
        }
      }
    }

    // Create a root FileTreeItem to hold the tree.values.toList()
    return FileTreeNode(
      item: FileSystemItem.getRootItem(),
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
