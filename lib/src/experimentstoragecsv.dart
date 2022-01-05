import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:touchtracker/src/experimentstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class ExperimentStorageCSV extends ExperimentStorage {
  // internal
  final RegExp rStripSpecial = RegExp(r'[^a-zA-Z0-9-_ ]+');
  String _path = '';

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

  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
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

    debugPrint('writing file: $filename');

    final file = await _localFile(filename);

    FileMode _fileMode = update ? FileMode.append : FileMode.write;
    await file.writeAsString(const ListToCsvConverter().convert(data),
        mode: _fileMode, flush: true);

    return true;
  }

  @override
  Future<void> flush(List<List<dynamic>> data, {key = ''}) async {
    await write(data, key: key, update: true);
  }
}

ExperimentStorage getStorage() => ExperimentStorageCSV();
