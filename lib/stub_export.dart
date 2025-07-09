// Stub export implementation for non-web platforms
Future<void> exportJsonWeb(List<int> bytes, String filename) async {
  // No-op or throw if called on non-web platforms
  throw UnsupportedError('Web export is only supported on web.');
}
