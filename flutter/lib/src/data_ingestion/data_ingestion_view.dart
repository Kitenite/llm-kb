import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataIngestionSideBar(width: _sidebarWidth),
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

class DataIngestionSideBar extends StatelessWidget {
  final double width;

  const DataIngestionSideBar({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Handle navigation to Home
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Handle navigation to Settings
            },
          ),
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
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
