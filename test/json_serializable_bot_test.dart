import 'dart:io';

import 'package:json_serializable_bot/json_serializable_bot.dart';
import 'package:test/test.dart';

const typeCastError = """
CheckedFromJsonException
Could not create `PleromaStatus`.
There is a problem with "direct_conversation_id".
type 'int' is not a subtype of type 'String?' in type cast
""";

void main() {
  test('parse error messsage', () {
    expect(
      parseErrorMessage(typeCastError),
      TypeCastError(
        actualType: 'int',
        className: 'PleromaStatus',
        expectedType: 'String?',
        propertyName: 'direct_conversation_id',
      ),
    );
  });

  test('fix file', () async {
    final error = TypeCastError(
      actualType: 'String',
      className: 'MyClass',
      expectedType: 'int',
      propertyName: 'field',
    );
    final input = await File('test/assets/input.dart').readAsString();
    final expected = await File('test/assets/expected.dart').readAsString();
    expect(fixCode(input, error), expected);
  });
}
