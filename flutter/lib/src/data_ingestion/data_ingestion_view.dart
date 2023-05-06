import 'package:flutter/material.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_main_view.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_sidebar.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';

class DataIngestionPage extends StatefulWidget {
  const DataIngestionPage({Key? key}) : super(key: key);

  @override
  _DataIngestionPageState createState() => _DataIngestionPageState();
}

class _DataIngestionPageState extends State<DataIngestionPage> {
  double _sidebarWidth = 250;

  void _updateSidebarWidth(double newWidth) {
    setState(() {
      _sidebarWidth = newWidth;
    });
  }

  List<FileSystemItem> fakeFileSystemItemsList = [
    FileSystemItem(
      id: '1',
      name: 'Folder A',
      type: 'directory',
      parentId: '0',
      path: '/Folder A',
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
      path: '/Folder A/File A1',
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
      path: '/Folder A/File A2',
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
      path: '/Folder B',
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
      path: '/Folder B/File B1',
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
      path: '/Folder A/Folder C',
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
      path: '/Folder A/Folder C/File C1',
      size: 256,
      content: 'Ut enim ad minim veniam',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataIngestionSideBar(
            width: _sidebarWidth,
            items: fakeFileSystemItemsList,
          ),
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) {
                  _updateSidebarWidth(_sidebarWidth + details.delta.dx);
                },
                child: VerticalDivider(
                  width: 20,
                  color: Theme.of(context).dividerColor,
                )),
          ),
          DataIngestionMainView(),
        ],
      ),
    );
  }
}
