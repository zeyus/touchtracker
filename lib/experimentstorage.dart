import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class ExperimentStorage {
  // internal
  RegExp rStripSpecial = RegExp(r'[^a-zA-Z0-9-_ ]+');

  // strip chars which would potentially break filenames and replace with "_"
  String replaceInvalidChars(String text, {String replace = '_'}) {
    return text.replaceAll(rStripSpecial, replace);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  // write subject log to file
  Future<bool> writeCSVFromList(List<List<dynamic>> data, String fileNamePrefix,
      {bool append = false}) async {
    String curISODate = DateTime.now().toIso8601String();
    String filename = '${replaceInvalidChars(fileNamePrefix)}_$curISODate.csv';

    final file = await _localFile(filename);

    FileMode _fileMode = append ? FileMode.write : FileMode.append;
    file.writeAsString(const ListToCsvConverter().convert(data),
        mode: _fileMode);

    return true;
  }
}
