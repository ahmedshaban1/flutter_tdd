
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tddcourse/core/util/input_convertor.dart';

void main(){
  InputConverter inputConverter;
  setUp((){
    inputConverter = InputConverter();
  });
  
  group("String to unsigned int", (){
    test("should return an integer when string represent an unsigned integer", (){
      //arr
      final str = "123";
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Right(123));
    });

    test("should return failure when string is not int", (){
      //arr
      final str = "123.4";
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });

    test("should return failure when string is not negative Integer", (){
      //arr
      final str = "-123";
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}