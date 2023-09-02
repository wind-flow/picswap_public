import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<void> writeToLogFile(String fileName, String log) async {
    final file = await _getTempLogFile(fileName);
    await file.writeAsString(log, mode: FileMode.append);
  }

  static Future<String> readLogFile(String fileName) async {
    final file = await _getTempLogFile(fileName);
    return file.readAsString();
  }

  static Future<String> readLogFileReversed(String fileName) async {
    final file = await _getTempLogFile(fileName);
    final content = await file.readAsString();
    return content.split('\n').reversed.join('\n');
  }

  static Future<File> _getTempLogFile(String fileName) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    if (!await file.exists()) {
      await file.writeAsString('');
    }
    return file;
  }

  static Future<void> clearLogFile(String fileName) async {
    final file = await _getTempLogFile(fileName);
    await file.writeAsString('');
  }
}
