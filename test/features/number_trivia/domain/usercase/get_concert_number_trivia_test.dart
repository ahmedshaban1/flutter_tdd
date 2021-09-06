import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:tddcourse/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tddcourse/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tddcourse/features/number_trivia/domain/usecases/get_concert_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository{}

void main(){
  GetConcertNumberTrivia userCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    userCase = GetConcertNumberTrivia(mockNumberTriviaRepository);
  });
  final tNumber = 1;
  final numberTrivia = NumberTrivia(number: tNumber, text: 'test');
  test("should get rivia from umber repository", () async{
    //arr
      when(mockNumberTriviaRepository.getConcertNumberTrivia(any)).thenAnswer((_) async => Right(numberTrivia));
    //act
    final result = await userCase(Params(number: tNumber));
    //assert

    expect(result,Right(numberTrivia));
    verify(mockNumberTriviaRepository.getConcertNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);

  });
}