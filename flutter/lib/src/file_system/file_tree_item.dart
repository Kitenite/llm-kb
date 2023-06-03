import 'package:kb_ui/src/file_system/file_system_item.dart';

class FileTreeNode {
  FileSystemItem item;
  Map<String, FileTreeNode> children = {};

  FileTreeNode({required this.item, Map<String, FileTreeNode>? children}) {
    if (children != null) {
      this.children = children;
    }
  }

  // Recursive function to get all children items
  static List<FileSystemItem> getAllChildrenItems(FileTreeNode node) {
    List<FileSystemItem> items = [node.item];
    for (var child in node.children.values) {
      items.addAll(getAllChildrenItems(child));
    }
    return items;
  }

  static FileTreeNode buildTree(List<FileSystemItem> items) {
    // Initialize an empty tree.
    final tree = <String, FileTreeNode>{};

    // Loop over each file system item.
    for (final item in items) {
      // Split the path into parts.
      final parts = item.path.split('/');
      // Start at the top level of the tree.
      Map<String, FileTreeNode> currentLevel = tree;

      // Loop over each part in the path.
      for (int i = 0; i < parts.length; i++) {
        final part = parts[i];
        if (part.isEmpty) {
          continue;
        }

        // If we're at the last part, we're at a file.
        // Add a new FileTreeNode to the current level of the tree.
        if (i == parts.length - 1) {
          currentLevel[part] = FileTreeNode(item: item);
        } else {
          // If the current part isn't in the tree yet, we're at a directory.
          // Add a new directory FileTreeNode to the current level of the tree.
          if (!currentLevel.containsKey(part)) {
            final newDirectory = FileSystemItem(
                id: 'placeholder',
                name: part,
                type: FileSystemItemType.directory,
                // The parent ID is the previous part, or empty if this is the first part.
                parentId: i > 0 ? parts[i - 1] : '',
                // The path is the parts up to and including this one.
                path: parts.sublist(0, i + 1).join('/'),
                // Use the current time as the creation and modification times.
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                // Start with no tags.
                tags: ["placeholder"]);

            currentLevel[part] = FileTreeNode(item: newDirectory);
          }

          // Move to the next level of the tree.
          currentLevel = currentLevel[part]!.children;
        }
      }
    }

    // Create a root FileTreeItem to hold the tree.values.toList()
    return FileTreeNode(
      item: FileSystemItem.getRootItem(),
      children: tree,
    );
  }
}
