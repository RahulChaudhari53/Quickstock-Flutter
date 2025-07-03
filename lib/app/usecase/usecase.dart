import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';

abstract interface class UsecaseWithParams<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
