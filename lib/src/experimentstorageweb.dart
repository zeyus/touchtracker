import 'package:touchtracker/src/experimentstorage.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:csv/csv.dart';

class ExperimentStorageWeb extends ExperimentStorage {
  @override
  Future<bool> write(List<List<dynamic>> data,
      {key = '', update = false}) async {
    final blob = Blob(
        [const ListToCsvConverter().convert(data)], 'text/plain', 'native');
    AnchorElement(
      href: Url.createObjectUrlFromBlob(blob).toString(),
    )
      ..setAttribute("download", "data.csv")
      ..click();
    return true;
  }

  @override
  Future<void> flush(List<List<dynamic>> data, {key = ''}) async {
    write(data, key: key, update: true);
  }
}

ExperimentStorage getStorage() => ExperimentStorageWeb();
