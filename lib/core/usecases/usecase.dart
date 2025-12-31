import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

abstract interface class UseCase<ResultType, Params> {
  Future<Either<Failure, ResultType>> call(Params params);
}

class NoParams {}
