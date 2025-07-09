// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
// Web-specific export implementation using dart:html
import 'dart:html' as html;

Future<void> exportJsonWeb(List<int> bytes, String filename) async {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}
