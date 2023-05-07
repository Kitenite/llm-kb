import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/api/server_api.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_main_view.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_sidebar.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';

class DataIngestionPage extends HookWidget {
  const DataIngestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedItem = useState<String>('');
    final sidebarWidth = useState<double>(250);

    List<FileSystemItem> mockList = [
      FileSystemItem(
        id: '1',
        name: 'Folder A',
        type: FileSystemItemType.directory,
        parentId: '0',
        path: '/1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: [],
      ),
      FileSystemItem(
        id: '2',
        name: 'File A1',
        type: FileSystemItemType.file,
        parentId: '1',
        path: '/1/2',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: [],
      ),
      FileSystemItem(
        id: '3',
        name: 'File A2',
        type: FileSystemItemType.file,
        parentId: '1',
        path: '/1/3',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: [],
      ),
      FileSystemItem(
        id: '4',
        name: 'Folder B',
        type: FileSystemItemType.directory,
        parentId: '0',
        path: '/4',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: [],
      ),
      FileSystemItem(
        id: '5',
        name: 'File B1',
        type: FileSystemItemType.file,
        parentId: '4',
        path: '/4/5',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: [],
      ),
      FileSystemItem(
        id: '6',
        name: 'Folder C',
        type: FileSystemItemType.directory,
        parentId: '1',
        path: '/1/6',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: [],
      ),
      FileSystemItem(
        id: '7',
        name: 'File C1',
        type: FileSystemItemType.file,
        parentId: '6',
        path: '/1/6/7',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: [],
      ),
    ];

    Map<String, FileSystemItem> mockMap = {
      for (var item in mockList) item.id: item
    };

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Two icon buttons
                    IconButton(
                      icon: const Icon(Icons.note_add_outlined),
                      onPressed: () {
                        ServerApiMethods.uploadFileSystemItem(
                          mockMap[selectedItem.value]!,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.create_new_folder_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              DataIngestionSideBar(
                width: sidebarWidth.value,
                items: mockList,
                selectedItem: selectedItem,
              ),
            ],
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
                if (mockMap[value] != null) {
                  return DataIngestionMainView(
                    item: mockMap[value] ?? mockList.first,
                  );
                }
                return const Text("No File System Item Selected");
              }),
        ],
      ),
    );
  }
}
