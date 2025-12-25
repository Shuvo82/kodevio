import 'failures.dart';

abstract class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;

  T? get data => isSuccess ? (this as Success<T>).data : null;
  Failure? get failure => isFailure ? (this as ResultFailure<T>).failure : null;
}

class Success<T> extends Result<T> {
  @override
  final T data;
  const Success(this.data);
}

class ResultFailure<T> extends Result<T> {
  @override
  final Failure failure;
  const ResultFailure(this.failure);
}
