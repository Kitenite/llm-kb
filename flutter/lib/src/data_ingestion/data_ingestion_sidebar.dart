import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_page.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';
import 'package:kb_ui/src/file_system/file_tree_item.dart';

class DataIngestionSideBar extends HookWidget {
  final List<FileSystemItem> items;
  final ValueNotifier<String> selectedItem;
  final ValueNotifier<DataIngestionMode> mode;

  const DataIngestionSideBar({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.mode,
  }) : super(key: key);

  // Recursive function to build the directory structure
  Widget buildDirectory(BuildContext context, FileTreeNode root,
      [double padding = 16.0]) {
    bool isItemSelected(entry) {
      return selectedItem.value == entry.item.id;
    }

    Widget? getProcessingStatusIcon(bool processed) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: processed
            ? null
            : const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
      );
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
                      leading: FileSystemItem.getIconForFileSystemItem(
                        entry.value.item,
                        isOutlined: !isItemSelected(entry.value),
                      ),
                      trailing:
                          getProcessingStatusIcon(entry.value.item.processed),
                      title: Text(entry.value.item.name),
                      selected: isItemSelected(entry.value),
                      onTap: () {
                        selectedItem.value = entry.value.item.id;
                        mode.value = DataIngestionMode.view;
                        // Handle folder navigation or action
                      },
                    ),
                    children: [
                      buildDirectory(context, entry.value, padding + 16.0),
                    ],
                  )
                : ListTile(
                    contentPadding: EdgeInsets.only(left: padding + 16),
                    leading: FileSystemItem.getIconForFileSystemItem(
                        entry.value.item,
                        isOutlined: !isItemSelected(entry.value)),
                    trailing:
                        getProcessingStatusIcon(entry.value.item.processed),
                    title: Text(entry.value.item.name),
                    selected: isItemSelected(entry.value),
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

  @override
  Widget build(BuildContext context) {
    final directoryStructureRoot = FileTreeNode.buildTree(items);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            textColor: Theme.of(context).textTheme.bodyLarge?.color,
            iconColor: Theme.of(context).iconTheme.color,
            title: const ListTile(
              title: Text("Your Files"),
            ),
            children: [
              buildDirectory(
                context,
                directoryStructureRoot,
              ),
            ],
          )
        ],
      ),
    );
  }
}
