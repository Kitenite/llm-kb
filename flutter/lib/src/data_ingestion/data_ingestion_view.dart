import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DataIngestionView extends HookWidget {
  DataIngestionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 250,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              width: (MediaQuery.of(context).size.width * 0.25),
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
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
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
          ),
        ],
      ),
    );
  }
}
