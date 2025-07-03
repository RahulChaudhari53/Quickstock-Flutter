import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({required super.message});
}

class RemoteDatabaseFailure extends Failure {
  final int? statusCode;

  const RemoteDatabaseFailure({this.statusCode, required super.message});
}

class SharedPreferenceFailure extends Failure {
  const SharedPreferenceFailure({required super.message});
}
