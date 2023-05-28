class ServerConstants {
  static const String devServerUrl =
      'localhost:8001'; // Used to develop with local Flutter
  static const String prodServerUrl =
      'server:8001'; // Used for container Flutter
  static const String subscribeToFileSystemEndpoint = '/file_system_update';
  static const String createFileSystemItemEndpoint = '/create_file';
  static const String getFileSystemItemsEndpoint = '/get_files';
  static const String ingestFileEndpoint = '/ingest_file';
}
