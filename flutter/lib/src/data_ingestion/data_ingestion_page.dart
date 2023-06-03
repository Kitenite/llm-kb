import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/api/server_api.dart';
import 'package:kb_ui/src/common/resizable_side_bar.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_create_view.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_edit_view.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_sidebar.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';

enum DataIngestionMode {
  view,
  create,
}

class DataIngestionPage extends HookWidget {
  final ValueNotifier<Map<String, FileSystemItem>> fsItemsMap;
  final Function getFileSystemItems;

  const DataIngestionPage({
    Key? key,
    required this.fsItemsMap,
    required this.getFileSystemItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedItem = useState<String>('0');
    final mode = useState<DataIngestionMode>(DataIngestionMode.view);
    void createNewFileSystemItem(FileSystemItemType type) {
      final selectedFsItem =
          fsItemsMap.value[selectedItem.value] ?? FileSystemItem.getRootItem();

      final newItem = FileSystemItem.createFromAnotherFileSystemItem(
          selectedFsItem,
          name:
              type == FileSystemItemType.directory ? "New folder" : "New file",
          type: type,
          tags: [
            "empty",
          ]);
      print(newItem.toJson());
      ServerApiMethods.createFileSystemItem(newItem);
    }

    List<Widget> sideBarChildren = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Two icon buttons
            ElevatedButton(
              onPressed: () {
                mode.value = DataIngestionMode.create;
              },
              child: const Text('Add data'),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.create_new_folder_outlined),
              onPressed: () {
                createNewFileSystemItem(FileSystemItemType.directory);
              },
            ),
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
          builder: (context, value, child) {
            return DataIngestionSideBar(
                items: fsItemsMap.value.values.toList(),
                selectedItem: selectedItem,
                mode: mode);
          }),
    ];
    List<Widget> mainViewChildren = [
      ValueListenableBuilder(
          valueListenable: selectedItem,
          builder: (context, value, child) {
            final item =
                fsItemsMap.value[value] ?? FileSystemItem.getRootItem();
            switch (mode.value) {
              case DataIngestionMode.create:
                return DataIngestionCreateView(
                  item: item,
                );
              case DataIngestionMode.view:
                return DataIngestionEditView(
                  item: item,
                );
            }
          }),
    ];
    return Scaffold(
      body: ResizableSideBar(
        sideBarChildren: sideBarChildren,
        mainViewChildren: mainViewChildren,
      ),
    );
  }
}
