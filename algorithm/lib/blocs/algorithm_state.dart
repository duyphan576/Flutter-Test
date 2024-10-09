import 'package:equatable/equatable.dart';

abstract class AlgorithmState extends Equatable {
  const AlgorithmState();

  @override
  List<Object> get props => [];
}

class AlgorithmInitial extends AlgorithmState {}

class AlgorithmLoading extends AlgorithmState {}

class AlgorithmLoaded extends AlgorithmState {
  final List<int> results;
  const AlgorithmLoaded(this.results);

  @override
  List<Object> get props => [results];
}

class AlgorithmError extends AlgorithmState {
  final String error;
  const AlgorithmError(this.error);

  @override
  List<Object> get props => [error];
}
