import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tddcourse/core/usecases/usercase.dart';
import 'package:tddcourse/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tddcourse/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tddcourse/features/number_trivia/domain/usecases/get_random_tivia_number.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia userCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    userCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });
  final tNumber = 1;
  final numberTrivia = NumberTrivia(number: tNumber, text: 'test');
  test("should get random trivia number from  repository", () async {
    //arr
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(numberTrivia));
    //act
    final result = await userCase(NoParams());
    //assert

    expect(result, Right(numberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
