import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_page.dart';
import 'package:kb_ui/src/api/server_api.dart';
import 'package:kb_ui/src/api/socket_service.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';
import 'package:kb_ui/src/query/query_page.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    final fsItemsMap = useState<Map<String, FileSystemItem>>({});

    void getFileSystemItems() {
      print('Getting file system items');
      ServerApiMethods.getFileSystemItems().then((data) {
        fsItemsMap.value = {
          for (var item in data) item.id: item,
        };
      }).catchError((error) {
        // Handle error here
        print(error);
      });
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

    final List<Widget> children = [
      DataIngestionPage(
        fsItemsMap: fsItemsMap,
        getFileSystemItems: getFileSystemItems,
      ),
      QueryPage(
        fsItemsMap: fsItemsMap,
        getFileSystemItems: getFileSystemItems,
      ),
    ];

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex.value,
            onDestinationSelected: (int index) {
              currentIndex.value = index;
            },
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_customize_outlined),
                selectedIcon: Icon(Icons.dashboard_customize),
                label: Text('Add data'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.question_answer_outlined),
                selectedIcon: Icon(Icons.question_answer),
                label: Text('Ask questions'),
              ),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: currentIndex.value,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
