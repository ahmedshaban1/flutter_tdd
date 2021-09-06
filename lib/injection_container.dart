import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tddcourse/core/network/network_info.dart';
import 'package:tddcourse/core/util/input_convertor.dart';
import 'package:tddcourse/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tddcourse/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tddcourse/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tddcourse/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tddcourse/features/number_trivia/domain/usecases/get_concert_number_trivia.dart';
import 'package:tddcourse/features/number_trivia/domain/usecases/get_random_tivia_number.dart';
import 'package:tddcourse/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:tddcourse/main.dart';

final sl = GetIt.instance;

Future<void> init() {
  //features
  initFeatures();
}

void initFeatures() async {

  sl.registerFactory(() => NumberTriviaBloc(
        converter: sl(),
        random: sl(),
        concert: sl(),
      ));
  sl.registerSingleton<TestClass>(TestClass());
  sl.registerLazySingleton(() => GetConcertNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  //repo
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          numberTriviaRemoteDataSource: sl(),
          numberTriviaLocalDataSource: sl(),
          networkInfo: sl()));
  //core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(dataConnectionChecker: sl()));


  sl.registerLazySingleton(() => DataConnectionChecker());
  //data source singleton
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: null));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: Client()));

  //external

}
