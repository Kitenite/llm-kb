import 'package:flutter/material.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_sidebar.dart';

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

  List<Item> fakeItemsList = [
    Item(
        name: 'Folder A',
        type: ItemType.FOLDER,
        uuid: 'uniqueId_folder_a',
        path: 'Folder A'),
    Item(
        name: 'File 1',
        type: ItemType.FILE,
        uuid: 'uniqueId_file_1',
        path: 'Folder A/File 1'),
    Item(
        name: 'File 2',
        type: ItemType.FILE,
        uuid: 'uniqueId_file_2',
        path: 'Folder A/File 2'),
    Item(
        name: 'Folder B',
        type: ItemType.FOLDER,
        uuid: 'uniqueId_folder_b',
        path: 'Folder A/Folder B'),
    Item(
        name: 'File 3',
        type: ItemType.FILE,
        uuid: 'uniqueId_file_3',
        path: 'Folder A/Folder B/File 3'),
    Item(
        name: 'Folder C',
        type: ItemType.FOLDER,
        uuid: 'uniqueId_folder_c',
        path: 'Folder A/Folder B/Folder C'),
    Item(
        name: 'File 4',
        type: ItemType.FILE,
        uuid: 'uniqueId_file_4',
        path: 'Folder A/Folder B/Folder C/File 4'),
    Item(
        name: 'Folder D',
        type: ItemType.FOLDER,
        uuid: 'uniqueId_folder_d',
        path: 'Folder D'),
    Item(
        name: 'File 5',
        type: ItemType.FILE,
        uuid: 'uniqueId_file_5',
        path: 'Folder D/File 5'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataIngestionSideBar(
            width: _sidebarWidth,
            items: fakeItemsList,
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

class DataIngestionMainView extends StatelessWidget {
  const DataIngestionMainView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is the main view',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
