import 'package:equatable/equatable.dart';

abstract class  Failure extends Equatable{
  Failure([List props = const<dynamic>[]]) : super([props]);
}

class ServerFailure extends Failure{
}
class CacheFailure extends Failure{
}