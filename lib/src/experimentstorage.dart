import 'dart:async';
// import 'dart:ffi';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

// Abstract experiment storage class
abstract class ExperimentStorage {
  Future<void> write(List<List<dynamic>> data, {key = '', update = false});
}

class ExperimentStorageCSV extends ExperimentStorage {
  // internal
  final RegExp rStripSpecial = RegExp(r'[^a-zA-Z0-9-_ ]+');

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
  @override
  Future<bool> write(List<List<dynamic>> data,
      {key = '', update = false}) async {
    String curISODate = DateTime.now().toIso8601String();
    String filename = '${replaceInvalidChars(key)}_$curISODate.csv';

    final file = await _localFile(filename);

    FileMode _fileMode = update ? FileMode.write : FileMode.append;
    file.writeAsString(const ListToCsvConverter().convert(data),
        mode: _fileMode);

    return true;
  }
}
