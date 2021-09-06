import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tddcourse/core/error/failures.dart';
import 'package:tddcourse/core/usecases/usercase.dart';
import 'package:tddcourse/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tddcourse/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcertNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcertNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcertNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number}) : super([number]);
}
