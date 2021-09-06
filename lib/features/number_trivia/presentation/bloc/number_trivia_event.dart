part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const<dynamic>[]]):super(props);
}

class GetTriviaForConcertNumberEvent extends NumberTriviaEvent{
  final String stringNumber;
  GetTriviaForConcertNumberEvent(this.stringNumber) : super([stringNumber]);
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent{}
