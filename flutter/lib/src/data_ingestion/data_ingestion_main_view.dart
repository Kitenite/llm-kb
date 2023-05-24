import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';
import 'dart:convert';
import 'package:kb_ui/src/uploader/file_uploader.dart';
import 'package:kb_ui/src/uploader/link_uploader.dart';

enum DataSourceType {
  file,
  link,
}

class DataIngestionMainView extends HookWidget {
  final FileSystemItem item;

  const DataIngestionMainView({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(item);
    final dataSource = useState<DataSourceType>(DataSourceType.file);
    return Expanded(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose a data source',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    dataSource.value = DataSourceType.file;
                  },
                  child: const Text('File upload'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    dataSource.value = DataSourceType.link;
                  },
                  child: const Text('Link upload'),
                ),
              ],
            ),
          ),
          Divider(
            height: 10,
            color: Theme.of(context).dividerColor,
          ),
          Expanded(
            flex: 2,
            child: ValueListenableBuilder(
              valueListenable: dataSource,
              builder: (context, value, _) {
                switch (value) {
                  case DataSourceType.file:
                    return FileUploader(item: item);
                  case DataSourceType.link:
                    // TODO: Handle this case.
                    return LinkUploader(item: item);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
