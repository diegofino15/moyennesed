import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

/* This class stores the important data locally to reconnect
automatically and have cache data */
class FileHandler {
  // Create an unique instance of the class //
  FileHandler._privateConstructor();
  static final FileHandler instance = FileHandler._privateConstructor();

  // Login info file //
  static File? _connectionInfoFile;
  static const String _connectionInfoFileName = "connection_infos.txt";

  // Function to init the file //
  Future<File> _initFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$fileName');
  }

  // Function to get the file //
  Future<File> getFile(File? file, String fileName) async {
    if (file != null) return file;

    file = await _initFile(fileName);
    return file;
  }

  // Information list that will be dumped into the file //
  static final Set<Map> _infosSet = {};

  // Function to write infos to the file //
  Future<File> writeInfos(Map infos) async {
    final File fl = await getFile(_connectionInfoFile, _connectionInfoFileName);
    _infosSet.clear();
    _infosSet.add(infos);

    final infosSetMap = _infosSet.toList();

    return await fl.writeAsString(jsonEncode(infosSetMap));
  }

  // Function to change only one information at a time //
  Future<void> changeInfos(Map infosToChange) async {
    Map existingInfos = await readInfos();
    for (final info in infosToChange.entries) {
      existingInfos.update(info.key, (value) => info.value, ifAbsent: () => info.value);
    }
    await writeInfos(existingInfos);
  }

  // Function to read the saved infos in the file //
  Future<Map> readInfos() async {
    final File fl = await getFile(_connectionInfoFile, _connectionInfoFileName);

    dynamic content;
    try {
      content = await fl.readAsString();
    } catch (e) {
      // Write to the file if it doesn't exist //
      await writeInfos({});
      content = await fl.readAsString();
    }

    final List<dynamic> jsonData = jsonDecode(content);
    return jsonData[0];
  }
}
