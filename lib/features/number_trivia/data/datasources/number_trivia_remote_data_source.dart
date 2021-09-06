import 'dart:convert';

import 'package:http/http.dart';
import 'package:tddcourse/core/error/exceptions.dart';
import 'package:tddcourse/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcertNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Client client;

  NumberTriviaRemoteDataSourceImpl({this.client});

  @override
  Future<NumberTriviaModel> getConcertNumberTrivia(int number) =>
      _getNumberTriviaUrl("http://numbersapi.com/$number");

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getNumberTriviaUrl("http://numbersapi.com/random");

  Future<NumberTriviaModel> _getNumberTriviaUrl(String url) async {
    final results =
        await client.get(url, headers: {"Content-Type": "application/json"});
    if (results.statusCode == 200)
      return NumberTriviaModel.fromJson(json.decode(results.body));
    else
      throw ServerException();
  }
}
