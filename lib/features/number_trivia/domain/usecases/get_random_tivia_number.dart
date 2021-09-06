import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tddcourse/core/error/failures.dart';
import 'package:tddcourse/core/usecases/usercase.dart';
import 'package:tddcourse/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tddcourse/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia,NoParams>{
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }

}

