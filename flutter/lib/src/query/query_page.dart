import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/common/resizable_side_bar.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';
import 'package:kb_ui/src/query/query_chat.dart';
import 'package:kb_ui/src/query/query_side_bar.dart';

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

    useEffect(() {
      selectedItems.value = fsItemsMap.value.values.toList();
      return () {};
    }, [
      fsItemsMap.value
    ]); // The empty list causes this effect to run once on init

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
    final List<Widget> mainViewChildren = [
      QueryChatView(
        selectedItems: selectedItems,
      )
    ];

    return Scaffold(
      body: ResizableSideBar(
        sideBarChildren: sideBarChildren,
        mainViewChildren: mainViewChildren,
      ),
    );
  }
}
