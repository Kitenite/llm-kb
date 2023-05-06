import 'package:kb_ui/src/file_system/file_system_item.dart';

class FileTreeNode {
  FileSystemItem item;
  Map<String, FileTreeNode> children = {};

  FileTreeNode({required this.item, Map<String, FileTreeNode>? children}) {
    if (children != null) {
      this.children = children;
    }
  }
}
