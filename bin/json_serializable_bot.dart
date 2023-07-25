import 'dart:io';

import 'package:json_serializable_bot/json_serializable_bot.dart' as jsb;

Future<void> main(List<String> arguments) async {
  print('JSON serializable bot, ready to unfuck code');

  final error = jsb.parseErrorMessage(arguments[1]);

  if (error == null) {
    print("Couldn't find parse error message");
    exit(1);
  }

  print('Parsed error: $error');

  final directory = Directory.current;
  print('Searching ${directory.path}');

  final classFile = await searchFile(directory, error.className);
  if (classFile == null) {
    print("Couldn't find class ${error.className}");
    exit(1);
  }

  final code = await classFile.readAsString();
  final fixed = jsb.fixCode(code, error);
  await classFile.writeAsString(fixed, mode: FileMode.writeOnly, flush: true);
  exit(0);
}

Future<File?> searchFile(Directory directory, String className) async {
  List<Directory> directories = [directory];

  while (directories.isNotEmpty) {
    final directory = directories.first;

    await for (final item in directory.list(recursive: true)) {
      switch (item) {
        case File():
          final contents = await item.readAsString();
          if (contents.contains("class $className")) return item;
          break;

        case Directory():
          directories.add(item);
          break;
      }
    }

    directories.removeAt(0);
  }

  return null;
}
