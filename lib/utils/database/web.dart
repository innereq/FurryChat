import 'dart:html';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:moor/moor_web.dart';

Future<Database> constructDb(
    {bool logStatements = false,
    String filename = 'database.sqlite',
    String password = ''}) async {
  Logs().v('[Moor] Using moor web');
  return Database(WebDatabase.withStorage(
      MoorWebStorage.indexedDbIfSupported(filename),
      logStatements: logStatements));
}

Future<String> getLocalstorage(String key) async {
  return await window.localStorage[key];
}
