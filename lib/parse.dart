final _classRegex = RegExp(r'(?:Could not create `([A-Za-z?<>,_]+)`.)');
final _propertyRegex =
    RegExp(r'(?:There is a problem with "([A-Za-z?<>,_]+)".)');
final _typeCastRegex = RegExp(
    r"(?:type '([A-Za-z?<>,_]+)' is not a subtype of type '([A-Za-z?<>,_]+)' in type cast)");

sealed class CreateError {
  final String className;
  final String propertyName;

  const CreateError({required this.className, required this.propertyName});

  @override
  bool operator ==(covariant CreateError other) {
    return className == other.className && propertyName == other.propertyName;
  }

  @override
  int get hashCode => Object.hashAll([className, propertyName]);
}

class TypeCastError extends CreateError {
  final String actualType;
  final String expectedType;

  const TypeCastError({
    required super.className,
    required super.propertyName,
    required this.actualType,
    required this.expectedType,
  });

  @override
  String toString() =>
      "(class: $className, property: $propertyName, expected: $expectedType, actual: $actualType)";

  @override
  bool operator ==(TypeCastError other) {
    return className == other.className &&
        propertyName == other.propertyName &&
        actualType == other.actualType &&
        expectedType == other.expectedType;
  }

  @override
  int get hashCode =>
      super.hashCode ^ Object.hashAll([actualType, expectedType]);
}

CreateError? parseErrorMessage(String message) {
  final typeCastMatch = _typeCastRegex.firstMatch(message);

  if (typeCastMatch == null || typeCastMatch.groupCount == 0) {
    print("Couldn't find type cast error");
    return null;
  }

  return TypeCastError(
    className: _classRegex.firstMatch(message)!.group(1)!,
    propertyName: _propertyRegex.firstMatch(message)!.group(1)!,
    actualType: typeCastMatch.group(1)!,
    expectedType: typeCastMatch.group(2)!,
  );
}
