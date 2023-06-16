import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';
import 'package:kb_ui/src/uploader/file_uploader.dart';
import 'package:kb_ui/src/uploader/github_uploader.dart';
import 'package:kb_ui/src/uploader/link_uploader.dart';

enum DataSourceType { file, link, github }

class DataIngestionCreateView extends HookWidget {
  final FileSystemItem item;

  DataIngestionCreateView({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataSource = useState<DataSourceType>(DataSourceType.link);
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
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    dataSource.value = DataSourceType.link;
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: const [
                      Icon(Icons.link), // replace with your desired icon
                      SizedBox(
                          width:
                              10), // provide some horizontal space between icon and text
                      Text('Link'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    dataSource.value = DataSourceType.file;
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: const [
                      Icon(Icons.upload_file), // replace with your desired icon
                      SizedBox(
                          width:
                              10), // provide some horizontal space between icon and text
                      Text('File'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    dataSource.value = DataSourceType.github;
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: const [
                      Icon(Icons.code), // replace with your desired icon
                      SizedBox(
                          width:
                              10), // provide some horizontal space between icon and text
                      Text('Github'),
                    ],
                  ),
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
                    return LinkUploader(item: item);
                  case DataSourceType.github:
                    return GithubUploader(item: item);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
