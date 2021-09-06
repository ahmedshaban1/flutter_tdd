import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tddcourse/core/error/exceptions.dart';
import 'package:tddcourse/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tddcourse/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group("get conecret Number trivia", () {
    final number = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        "should  perform a get request on a url with number being the end point and with application/json header",
        () {
      //arr
      when(mockHttpClient.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      //act
      dataSource.getConcertNumberTrivia(number);
      //assert
      verify(mockHttpClient.get("http://numbersapis.com/$number",
          headers: {"Content-Type": "application/json"}));
    });

    test("should  return number triva number and status code 200 and success",
            () async {
          //arr
          when(mockHttpClient.get(any, headers: anyNamed("headers")))
              .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
          //act
          final results = await dataSource.getConcertNumberTrivia(number);
          //assert
          expect(results, equals(tNumberTriviaModel));
        });

    test("should  throw server exception when  response 404",
            () async {
          //arr
          when(mockHttpClient.get(any, headers: anyNamed("headers")))
              .thenAnswer((_) async => http.Response("Error", 404));
          //act
          final call = await dataSource.getConcertNumberTrivia;
          //assert
          expect(()=> call(number), throwsA(TypeMatcher<ServerException>()));
        });
  });
  group("get random trivia", () {
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        "should  perform a get request on a url with number being the end point and with application/json header",
            () {
          //arr
          when(mockHttpClient.get(any, headers: anyNamed("headers")))
              .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
          //act
          dataSource.getRandomNumberTrivia();
          //assert
          verify(mockHttpClient.get("http://numbersapis.com/random",
              headers: {"Content-Type": "application/json"}));
        });

    test("should  return number triva number and status code 200 and success",
            () async {
          //arr
          when(mockHttpClient.get(any, headers: anyNamed("headers")))
              .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
          //act
          final results = await dataSource.getRandomNumberTrivia();
          //assert
          expect(results, equals(tNumberTriviaModel));
        });

    test("should  throw server exception when  response 404",
            () async {
          //arr
          when(mockHttpClient.get(any, headers: anyNamed("headers")))
              .thenAnswer((_) async => http.Response("Error", 404));
          //act
          final call =  dataSource.getRandomNumberTrivia();
          //assert
          expect(()=> call, throwsA(TypeMatcher<ServerException>()));
        });
  });

}
