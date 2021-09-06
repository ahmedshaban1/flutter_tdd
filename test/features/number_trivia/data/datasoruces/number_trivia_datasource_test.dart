import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tddcourse/core/error/exceptions.dart';
import 'package:tddcourse/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tddcourse/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';
import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPref extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;
  MockSharedPref mockSharedPref;
  setUp(() {
    mockSharedPref = MockSharedPref();
    numberTriviaLocalDataSourceImpl =
        NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPref);
  });
  
  group("getlastnumberTivia", () {
    final numberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("tivia_cached.json")));
    test("should return numbertriva from sheredpref where there is one in the cache", ()async{
      //arr
      when(mockSharedPref.getString(any)).thenReturn(fixture("tivia_cached.json"));
      //act
      final results = await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();
      //asset
      verify(mockSharedPref.getString("CACHED_NUMBER_TRIVIA"));
      expect(results, equals(numberTriviaModel));

    });

    test("should  throw exception when cached data null", ()async{
      //arr
      when(mockSharedPref.getString(any)).thenReturn(null);
      //act
      final call =  numberTriviaLocalDataSourceImpl.getLastNumberTrivia;
      //asset
      expect(()=>call(), throwsA(TypeMatcher<CacheException>()));

    });
  });
  
  
  group("cachedNumberTrivia", (){
    test("should call sheredPref to cache the data", (){
      final numberTriviaModel = NumberTriviaModel(number: 1,text: "Test Text");
      //act
      numberTriviaLocalDataSourceImpl.cacheNumberTrivia(numberTriviaModel);
      //asset
      final expectedJson = json.encode(numberTriviaModel.toJson());
      verify(mockSharedPref.setString("CACHED_NUMBER_TRIVIA",expectedJson));
    });
  });
}
