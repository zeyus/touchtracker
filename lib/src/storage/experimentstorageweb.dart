import 'package:touchtracker/src/storage/experimentstorage.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:csv/csv.dart';

class ExperimentStorageWeb extends ExperimentStorage {
  final Map<String, String> _output = {};

  final RegExp rStripSpecial = RegExp(r'[^a-zA-Z0-9-_ ]+');
  String _replaceInvalidChars(String text, {String replace = '_'}) {
    return text.replaceAll(rStripSpecial, replace);
  }

  @override
  Future<bool> write(List<List<dynamic>> data,
      {key = '', update = false}) async {
    key = key == '' ? this.key : key;
    String csvData = const ListToCsvConverter().convert(data) + '\n';
    if (_output[key] == null || !update) {
      _output[key] = csvData;
    } else if (update) {
      _output[key] = _output[key]! + csvData;
    }

    return true;
  }

  @override
  Future<void> flush(List<List<dynamic>> data, {key = ''}) async {
    write(data, key: key, update: true);
  }

  @override
  Future<void> openLog(String log) async {
    Blob blob = Blob([_output[log]], 'text/csv', 'native');
    AnchorElement(
      href: Url.createObjectUrlFromBlob(blob).toString(),
    )
      ..setAttribute("download", "${_replaceInvalidChars(log)}.csv")
      ..click();
  }

  @override
  List<String> getLogs() {
    return _output.keys.toList();
  }

  @override
  Future<void> clear() async {
    _output.clear();
  }
}

ExperimentStorage getStorage() => ExperimentStorageWeb();
