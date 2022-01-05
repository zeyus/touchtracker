import 'dart:async';

// ignore: unused_import
import 'experimentstoragestub.dart'
    if (dart.library.io) 'experimentstoragecsv.dart'
    if (dart.library.js) 'experimentstorageweb.dart' as storage;

// Abstract experiment storage class
abstract class ExperimentStorage {
  String key = '';

  Future<void> write(List<List<dynamic>> data, {key = '', update = false});
  Future<void> flush(List<List<dynamic>> data, {key = ''});
}

ExperimentStorage getStorage() => storage.getStorage();
