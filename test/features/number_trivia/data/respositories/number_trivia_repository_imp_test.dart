import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tddcourse/core/error/exceptions.dart';
import 'package:tddcourse/core/error/failures.dart';
import 'package:tddcourse/core/network/network_info.dart';
import 'package:tddcourse/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tddcourse/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tddcourse/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tddcourse/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tddcourse/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = NumberTriviaRepositoryImpl(
        numberTriviaRemoteDataSource: mockRemoteDataSource,
        numberTriviaLocalDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group("get concert number triva", () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: "Test Text");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test("should check if device online", () async {
      //arr
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getConcertNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test("should return remote data source if successful", () async {
        //arr
        when(mockRemoteDataSource.getConcertNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final results = await repository.getConcertNumberTrivia(tNumber);
        //asset
        verify(mockRemoteDataSource.getConcertNumberTrivia(tNumber));
        expect(results, equals(Right(tNumberTrivia)));
      });

      test("should return cache data source if successful", () async {
        //arr
        when(mockRemoteDataSource.getConcertNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repository.getConcertNumberTrivia(tNumber);
        //asset
        verify(mockRemoteDataSource.getConcertNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          "should return server failure when call remote data source unsuccessful",
          () async {
        //arr
        when(mockRemoteDataSource.getConcertNumberTrivia(any))
            .thenThrow(ServerException());
        //act
        final results = await repository.getConcertNumberTrivia(tNumber);
        //asset
        verify(mockRemoteDataSource.getConcertNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(results, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test("should  return last cashed data when cache data is present ",
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final results = await repository.getConcertNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(results, equals(Right(tNumberTrivia)));
      });

      test(
          "should return Cache failure when call cache data source unsuccessful",
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //act
        final results = await repository.getConcertNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(results, equals(Left(CacheFailure())));
      });
    });
  });

  group("get random number triva", () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: "Test Text");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test("should check if device online", () async {
      //arr
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getRandomNumberTrivia();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test("should return remote data source if successful", () async {
        //arr
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final results = await repository.getRandomNumberTrivia();
        //asset
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(results, equals(Right(tNumberTrivia)));
      });

      test("should return cache data source if successful", () async {
        //arr
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repository.getRandomNumberTrivia();
        //asset
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          "should return server failure when call remote data source unsuccessful",
          () async {
        //arr
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        //act
        final results = await repository.getRandomNumberTrivia();
        //asset
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(results, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test("should  return last cashed data when cache data is present ",
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final results = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(results, equals(Right(tNumberTrivia)));
      });

      test(
          "should return Cache failure when call cache data source unsuccessful",
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //act
        final results = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(results, equals(Left(CacheFailure())));
      });
    });
  });
}
