import 'package:equatable/equatable.dart';

abstract class AlgorithmEvent extends Equatable {
  const AlgorithmEvent();

  @override
  List<Object> get props => [];
}

class FetchDataEvent extends AlgorithmEvent {}
