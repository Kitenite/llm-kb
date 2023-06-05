class ServerConstants {
  static const String serverUrl =
      'localhost:8001'; // Replace with localhost:8001 for local development
  static const String subscribeToFileSystemEndpoint = '/file_system_update';
  static const String createFileSystemItemEndpoint = '/create_file';
  static const String updateFileSystemItemEndpoint = '/update_file';
  static const String getFileSystemItemsEndpoint = '/get_files';
  static const String deleteFileSystemItemEndpoint = '/delete_file';
  static const String uploadFileEndpoint = '/upload_file';
  static const String postQueryEndpoint = '/post_query';
}
