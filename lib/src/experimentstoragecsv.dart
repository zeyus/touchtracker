import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:touchtracker/src/experimentstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';

class ExperimentStorageCSV extends ExperimentStorage {
  // internal
  final RegExp rStripSpecial = RegExp(r'[^a-zA-Z0-9-_ ]+');
  String _path = '';
  final List<String> _logFiles = [];

  ExperimentStorageCSV() : super();

  // strip chars which would potentially break filenames and replace with "_"
  String replaceInvalidChars(String text, {String replace = '_'}) {
    return text.replaceAll(rStripSpecial, replace);
  }

  Future<String> get _localPath async {
    if (_path == '') {
      final directory = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getExternalStorageDirectory();
      _path = directory!.path;
    }
    return _path;
  }

  Future<String> _getFullPath(String filename) async {
    final path = await _localPath;
    return '$path/$filename';
  }

  Future<File> _localFile(String filename) async {
    final path = await _getFullPath(filename);
    return File(path);
  }

  String _getFilename(String key) {
    DateTime curDate = DateTime.now();
    String filename =
        '${curDate.year}-${curDate.month.toString().padLeft(2, "0")}-${curDate.day.toString().padLeft(2, "0")}_${replaceInvalidChars(key)}.csv';
    return filename;
  }

  // write subject log to file
  @override
  Future<bool> write(List<List<dynamic>> data,
      {key = '', update = false}) async {
    // ignore: unnecessary_this
    key = key == '' ? this.key : key;
    String filename = _getFilename(key);

    if (!_logFiles.contains(filename)) {
      _logFiles.add(filename);
    }

    debugPrint('writing file: $filename');

    final file = await _localFile(filename);

    FileMode _fileMode = update ? FileMode.append : FileMode.write;
    await file.writeAsString(const ListToCsvConverter().convert(data) + '\n',
        mode: _fileMode, flush: true);

    return true;
  }

  @override
  Future<void> flush(List<List<dynamic>> data, {key = ''}) async {
    await write(data, key: key, update: true);
  }

  @override
  List<String> getLogs() {
    return _logFiles;
  }

  @override
  Future<void> openLog(String log) async {
    final file = await _getFullPath(log);
    Share.shareFiles([file], mimeTypes: ['text/csv']);
  }

  @override
  Future<void> clear() async {
    _logFiles.clear();
  }
}

ExperimentStorage getStorage() => ExperimentStorageCSV();
