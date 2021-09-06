import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:tddcourse/core/error/exceptions.dart';
import 'package:tddcourse/core/error/failures.dart';
import 'package:tddcourse/core/network/network_info.dart';
import 'package:tddcourse/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tddcourse/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tddcourse/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tddcourse/features/number_trivia/domain/repositories/number_trivia_repository.dart';
typedef Future<NumberTrivia> _ConcertOrRandomChooser();

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {@required this.numberTriviaRemoteDataSource,
      @required this.numberTriviaLocalDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcertNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return numberTriviaRemoteDataSource.getConcertNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return numberTriviaRemoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcertOrRandomChooser body) async {
    if (await networkInfo.isConnected) {
      try {
        final results = await body();
        numberTriviaLocalDataSource.cacheNumberTrivia(results);
        return Right(results);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final results = await numberTriviaLocalDataSource.getLastNumberTrivia();
        return Right(results);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
