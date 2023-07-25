import 'package:recase/recase.dart';

import 'parse.dart';

RegExp _classRegex(String className) =>
    RegExp(r"class\s+" + className + r"\s*{.*}", dotAll: true);

RegExp _fieldRegex(String typeName, String fieldName) =>
    RegExp('($typeName).+$fieldName;', dotAll: true);

String fixCode(String input, CreateError error) {
  switch (error) {
    case TypeCastError():
      return input.replaceFirstMapped(
        _classRegex(error.className),
        (classMatch) {
          final fieldName = error.propertyName.camelCase;
          final pattern = _fieldRegex(error.expectedType, fieldName);

          final group = classMatch.group(0)!;

          String updatedField = switch (error.actualType) {
            'Null' => "${error.expectedType}? $fieldName;",
            _ => "Object $fieldName;"
          };

          return group.replaceFirst(pattern, updatedField);
        },
      );

    default:
      throw UnimplementedError();
  }
}
