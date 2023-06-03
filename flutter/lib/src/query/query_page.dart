import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/common/resizable_side_bar.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';
import 'package:kb_ui/src/file_system/file_tree_item.dart';

class QueryPage extends HookWidget {
  final ValueNotifier<Map<String, FileSystemItem>> fsItemsMap;
  final Function getFileSystemItems;

  const QueryPage({
    Key? key,
    required this.fsItemsMap,
    required this.getFileSystemItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedItems = useState<List<FileSystemItem>>([]);

    final List<Widget> sideBarChildren = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                getFileSystemItems();
              },
            ),
          ],
        ),
      ),
      ValueListenableBuilder(
        valueListenable: fsItemsMap,
        builder: (context, map, child) {
          return QuerySideBar(
            items: map.values.toList(),
            selectedItems: selectedItems,
          );
        },
      ),
    ];
    final List<Widget> mainViewChildren = [const QueryChatView()];

    return Scaffold(
      body: ResizableSideBar(
        sideBarChildren: sideBarChildren,
        mainViewChildren: mainViewChildren,
      ),
    );
  }
}

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
                      leading: FileSystemItem.getIconForFileSystemItem(
                        entry.value.item,
                        isOutlined: !isItemSelected(entry.value),
                      ),
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
                    leading: FileSystemItem.getIconForFileSystemItem(
                        entry.value.item,
                        isOutlined: !isItemSelected(entry.value)),
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

// Create place holder for QueryChatView
class QueryChatView extends StatelessWidget {
  const QueryChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
