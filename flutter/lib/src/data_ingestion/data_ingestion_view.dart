import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/api/server_api.dart';
import 'package:kb_ui/src/api/socket_service.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_main_view.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_sidebar.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';

class DataIngestionPage extends HookWidget {
  const DataIngestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedItem = useState<String>('0');
    final sidebarWidth = useState<double>(250);
    final fsItemsMap = useState<Map<String, FileSystemItem>>({});

    void getFileSystemItems() {
      print('Getting file system items');
      ServerApiMethods.getFileSystemItems().then((data) {
        for (var item in data) print(item.toJson());
        fsItemsMap.value = {
          for (var item in data) item.id: item,
        };
      }).catchError((error) {
        // Handle error here
        print(error);
      });
    }

    void createNewFileSystemItem(FileSystemItemType type) {
      print(selectedItem.value);
      final selectedFsItem =
          fsItemsMap.value[selectedItem.value] ?? FileSystemItem.getRootItem();

      final newItem = FileSystemItem.createFromAnotherFileSystemItem(
          selectedFsItem,
          name: type == FileSystemItemType.file ? "new_file" : "new_dir",
          type: type,
          tags: [
            "empty",
          ]);
      print(newItem.toJson());
      ServerApiMethods.uploadFileSystemItem(newItem);
    }

    useEffect(() {
      getFileSystemItems();

      // Listen for file system updates
      SocketService.instance.listen('file_system_update', (data) {
        print('file_system_update received');
        getFileSystemItems();
      });
      return () {};
    }, []); // The empty list causes this effect to run once on init

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Two icon buttons
                      IconButton(
                        icon: const Icon(Icons.note_add_outlined),
                        onPressed: () {
                          createNewFileSystemItem(FileSystemItemType.file);
                        },
                      ),
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
                        width: sidebarWidth.value,
                        items: fsItemsMap.value.values.toList(),
                        selectedItem: selectedItem,
                      );
                    }),
              ],
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) {
                  sidebarWidth.value = sidebarWidth.value + details.delta.dx;
                },
                child: VerticalDivider(
                  width: 20,
                  color: Theme.of(context).dividerColor,
                )),
          ),
          ValueListenableBuilder(
              valueListenable: selectedItem,
              builder: (context, value, child) {
                if (fsItemsMap.value[value] != null) {
                  return DataIngestionMainView(
                    item: fsItemsMap.value[value] ??
                        fsItemsMap.value.values.first,
                  );
                }
                return const Text("No File System Item Selected");
              }),
        ],
      ),
    );
  }
}
