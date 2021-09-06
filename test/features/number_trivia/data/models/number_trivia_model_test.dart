import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tddcourse/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tddcourse/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test("should be as subclass of number trivia entity", () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  
  
  group('fromJson', (){
    test("should return a valid model when the json number is integer", (){
      //arr
      final Map<String,dynamic> jsonMap = json.decode(fixture('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result,tNumberTriviaModel);
    });

    test("should return a valid model when the json number is regarded as double", (){
      //arr
      final Map<String,dynamic> jsonMap = json.decode(fixture('double_fixture.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result,tNumberTriviaModel);
    });
  });
  group("toJson", (){
    test("should return json map contain the proper data",() async{
      //act
      final result = tNumberTriviaModel.toJson();
      //assert
      expect(result, {"text":"Test Text","number":1});

    });
  });
}
