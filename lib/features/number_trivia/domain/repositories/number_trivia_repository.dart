import 'package:dartz/dartz.dart';
import 'package:tddcourse/core/error/failures.dart';
import 'package:tddcourse/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcertNumberTrivia(int number);

  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
