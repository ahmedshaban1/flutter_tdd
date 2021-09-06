import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tddcourse/core/error/exceptions.dart';
import 'package:tddcourse/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(
        "CACHED_NUMBER_TRIVIA",
        json.encode(
          triviaModel.toJson(),
        ));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = sharedPreferences.getString("CACHED_NUMBER_TRIVIA");
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
