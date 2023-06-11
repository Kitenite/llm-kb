import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';
import 'package:kb_ui/src/file_system/file_tree_item.dart';

class QuerySideBar extends HookWidget {
  final List<FileSystemItem> items;
  final ValueNotifier<List<FileSystemItem>> selectedItems;

  const QuerySideBar({
    Key? key,
    required this.items,
    required this.selectedItems,
  }) : super(key: key);

  void toggleSelectItemAndChildren(FileTreeNode node) {
    List<FileSystemItem> allItems = FileTreeNode.getAllChildrenItems(node);

    if (selectedItems.value.contains(node.item)) {
      selectedItems.value = selectedItems.value.where((element) {
        return !allItems.contains(element);
      }).toList();
      return;
    }
    selectedItems.value = [...selectedItems.value, ...allItems];
  }

  Icon getCheckedIcon(bool selected) {
    return Icon(
      selected ? Icons.check_box : Icons.check_box_outline_blank,
      color: selected ? Colors.blue : null,
    );
  }

  // Recursive function to build the directory structure
  Widget buildDirectory(BuildContext context, FileTreeNode root,
      [double padding = 16.0]) {
    bool isItemSelected(FileTreeNode node) {
      return selectedItems.value.contains(node.item);
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
                      leading: getCheckedIcon(isItemSelected(entry.value)),
                      title: Text(entry.value.item.name),
                      selected: isItemSelected(entry.value),
                      onTap: () {
                        toggleSelectItemAndChildren(entry.value);
                      },
                    ),
                    children: [
                      buildDirectory(context, entry.value, padding + 16.0),
                    ],
                  )
                : ListTile(
                    contentPadding: EdgeInsets.only(left: padding + 16),
                    leading: getCheckedIcon(isItemSelected(entry.value)),
                    title: Text(entry.value.item.name),
                    selected: isItemSelected(entry.value),
                    onTap: () {
                      toggleSelectItemAndChildren(entry.value);
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
