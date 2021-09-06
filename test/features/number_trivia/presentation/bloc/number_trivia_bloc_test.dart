import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tddcourse/core/error/failures.dart';
import 'package:tddcourse/core/usecases/usercase.dart';
import 'package:tddcourse/core/util/input_convertor.dart';
import 'package:tddcourse/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tddcourse/features/number_trivia/domain/usecases/get_concert_number_trivia.dart';
import 'package:tddcourse/features/number_trivia/domain/usecases/get_random_tivia_number.dart';
import 'package:tddcourse/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcertNumberTrivia extends Mock
    implements GetConcertNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcertNumberTrivia mockGetConcertNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcertNumberTrivia = MockGetConcertNumberTrivia();
    bloc = NumberTriviaBloc(
      concert: mockGetConcertNumberTrivia,
      random: mockGetRandomNumberTrivia,
      converter: mockInputConverter,
    );
  });

  test("initial state should be empty", () {
    //assert
    expect(bloc.initialState, equals(Empty()));
  });

  group("get trivia for concert number", () {
    final tNumberString = '1';
    final tNumber = 1;
    final tNumberTrivia = NumberTrivia(text: "Test trivia", number: 1);
    test(
        "should call  inputConverter to validate and covert to string to unsigned integer",
        () async {
      //arr
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumber));
      //act
      bloc.dispatch(GetTriviaForConcertNumberEvent(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test("should emit error when input is invalid ", () async {
      //arr
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      //assert later
      expectLater(
          bloc.state, emitsInOrder([Empty(), Error(INVALID_FAILURE_MESSAGE)]));
      //act
      bloc.dispatch(GetTriviaForConcertNumberEvent(tNumberString));

    });
    test("should get data from convert use case", () async {
      //arr
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumber));
      when(mockGetConcertNumberTrivia(any)).thenAnswer((_)  async => Right(tNumberTrivia));
      //act
      bloc.dispatch(GetTriviaForConcertNumberEvent(tNumberString));
      await untilCalled(mockGetConcertNumberTrivia(any));
      //assert later
      /*expectLater(
          bloc.state, emitsInOrder([Empty(), Loading(),Loaded(numberTrivia: tNumberTrivia)]));*/
      verify(mockGetConcertNumberTrivia(Params(number: tNumber)));


    });

    test("should emit loading and loaded when data success ", () async {
      //arr
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumber));
      when(mockGetConcertNumberTrivia(any)).thenAnswer((_)  async => Right(tNumberTrivia));
      //assert later
      expectLater(
          bloc.state, emitsInOrder([Empty(), Loading(),Loaded(numberTrivia: tNumberTrivia)]));
      //act
      bloc.dispatch(GetTriviaForConcertNumberEvent(tNumberString));

    });

    test("should emit loading and error when data failure ", () async {
      //arr
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumber));
      when(mockGetConcertNumberTrivia(any)).thenAnswer((_)  async => Left(ServerFailure()));
      //assert later
      expectLater(
          bloc.state, emitsInOrder([Empty(), Loading(),Error(SERVER_FAILURE_MESSAGE)]));
      //act
      bloc.dispatch(GetTriviaForConcertNumberEvent(tNumberString));

    });

    test("should emit loading and error when data failure  Cache failure", () async {
      //arr
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumber));
      when(mockGetConcertNumberTrivia(any)).thenAnswer((_)  async => Left(CacheFailure()));
      //assert later
      expectLater(
          bloc.state, emitsInOrder([Empty(), Loading(),Error(CACHE_FAILURE_MESSAGE)]));
      //act
      bloc.dispatch(GetTriviaForConcertNumberEvent(tNumberString));

    });


  });

  group("get trivia for concert number", () {
    final tNumberTrivia = NumberTrivia(text: "Test trivia", number: 1);

    test("should get data from  use case", () async {
      //arr
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_)  async => Right(tNumberTrivia));
      //act
      bloc.dispatch(GetRandomNumberTriviaEvent());
      await untilCalled(mockGetRandomNumberTrivia(any));
      //assert later
      /*expectLater(
          bloc.state, emitsInOrder([Empty(), Loading(),Loaded(numberTrivia: tNumberTrivia)]));*/
      verify(mockGetRandomNumberTrivia(NoParams()));


    });

   test("should emit loading and loaded when data success ", () async {
      //arr
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_)  async => Right(tNumberTrivia));
      //assert later
      expectLater(
          bloc.state, emitsInOrder([Empty(), Loading(),Loaded(numberTrivia: tNumberTrivia)]));
      //act
      bloc.dispatch(GetRandomNumberTriviaEvent());

    });

    test("should emit loading and error when data failure ", () async {
      //arr
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_)  async => Left(ServerFailure()));
      //assert later
      expectLater(
          bloc.state, emitsInOrder([Empty(), Loading(),Error(SERVER_FAILURE_MESSAGE)]));
      //act
      bloc.dispatch(GetRandomNumberTriviaEvent());

    });

    test("should emit loading and error when data failure  Cache failure ", () async {
      //arr
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_)  async => Left(CacheFailure()));
      //assert later
      expectLater(
          bloc.state, emitsInOrder([Empty(), Loading(),Error(CACHE_FAILURE_MESSAGE)]));
      //act
      bloc.dispatch(GetRandomNumberTriviaEvent());

    });


  });










}
