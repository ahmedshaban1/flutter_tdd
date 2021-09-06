import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tddcourse/core/error/failures.dart';
import 'package:tddcourse/core/usecases/usercase.dart';
import 'package:tddcourse/core/util/input_convertor.dart';
import 'package:tddcourse/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tddcourse/features/number_trivia/domain/usecases/get_concert_number_trivia.dart';
import 'package:tddcourse/features/number_trivia/domain/usecases/get_random_tivia_number.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = "Server failure";
const String CACHE_FAILURE_MESSAGE = "Cache failure";
const String INVALID_FAILURE_MESSAGE = "invalid number";


class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcertNumberTrivia getTriviaForConcertNumber;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({@required GetConcertNumberTrivia concert,
    @required GetRandomNumberTrivia random,
    @required InputConverter converter})
      : assert(concert != null),
        assert(random != null),
        assert(converter != null),
        getTriviaForConcertNumber = concert,
        getRandomNumberTrivia = random,
        inputConverter = converter;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event,) async* {
    if (event is GetTriviaForConcertNumberEvent) {
      final inputEither = inputConverter.stringToUnsignedInteger(
          event.stringNumber);
      yield* inputEither.fold((failure) async* {
        yield Error(INVALID_FAILURE_MESSAGE);
      }, (data) async* {
        yield Loading();
        final results = await getTriviaForConcertNumber(Params(number: data));
        yield* eitherNumberOrError(results);
      });
    }else if(event is GetRandomNumberTriviaEvent){
      yield Loading();
      final results = await getRandomNumberTrivia(NoParams());
      yield* eitherNumberOrError(results);
    }

  }

  Stream<NumberTriviaState>  eitherNumberOrError(Either<Failure, NumberTrivia> results) async*{
     yield results.fold((error) =>
        Error(_mapFailureToMessage(error)), (trivia) =>
        Loaded(numberTrivia: trivia));
  }

  String _mapFailureToMessage(Failure failure){
    switch(failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "unexpected error";
    }
  }
}
