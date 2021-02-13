import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_number_trivia/core/utils/input_converter.dart';

void main() {
  InputConverter converter;

  setUp(() {
    converter = InputConverter();
  });

  group('InputConverter', () {
    test('should return int when string represent unsigned int', () {
      // arrange
      final str = '123';
      // act
      final result = converter.stringToUnsignedInteger(str);
      // assert
      expect(result, Right(123));
    });
  });

  test('should return a failure when string can not represent an integer', () {
    // arrange
    final str = '12ab';
    // act
    final result = converter.stringToUnsignedInteger(str);
    // assert
    expect(result, Left(InvalidInputFailure()));
  });

  test(
      'should return a failure when string can not represent an positive integer',
      () {
    // arrange
    final str = '-123';
    // act
    final result = converter.stringToUnsignedInteger(str);
    // assert
    expect(result, Left(InvalidInputFailure()));
  });
}
