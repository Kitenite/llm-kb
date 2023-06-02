import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/data_ingestion/data_ingestion_view.dart';

class HomePage extends HookWidget {
  final List<Widget> _children = [
    const DataIngestionPage(),
    Screen2(),
  ];

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
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
              children: _children,
            ),
          ),
        ],
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 100.0,
      itemCount: 50,
      itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
    );
  }
}
