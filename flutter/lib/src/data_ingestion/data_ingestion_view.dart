import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
        type: 'directory',
        parentId: '0',
        path: '/1',
        size: 0,
        content: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      FileSystemItem(
        id: '2',
        name: 'File A1',
        type: 'file',
        parentId: '1',
        path: '/1/2',
        size: 1024,
        content: 'Lorem ipsum dolor sit amet',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      FileSystemItem(
        id: '3',
        name: 'File A2',
        type: 'file',
        parentId: '1',
        path: '/1/3',
        size: 2048,
        content: 'Consectetur adipiscing elit',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      FileSystemItem(
        id: '4',
        name: 'Folder B',
        type: 'directory',
        parentId: '0',
        path: '/4',
        size: 0,
        content: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      FileSystemItem(
        id: '5',
        name: 'File B1',
        type: 'file',
        parentId: '4',
        path: '/4/5',
        size: 512,
        content: 'Sed do eiusmod tempor incididunt',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      FileSystemItem(
        id: '6',
        name: 'Folder C',
        type: 'directory',
        parentId: '1',
        path: '/1/6',
        size: 0,
        content: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      FileSystemItem(
        id: '7',
        name: 'File C1',
        type: 'file',
        parentId: '6',
        path: '/1/6/7',
        size: 256,
        content: 'Ut enim ad minim veniam',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    Map<String, FileSystemItem> mockMap = {
      for (var item in mockList) item.id: item
    };

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataIngestionSideBar(
            width: sidebarWidth.value,
            items: mockList,
            selectedItem: selectedItem,
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
