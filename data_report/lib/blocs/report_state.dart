import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable {
  const ReportState();
  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportFileUploaded extends ReportState {}

class ReportCalculated extends ReportState {
  final double totalAmount;
  const ReportCalculated({required this.totalAmount});
}

class ReportError extends ReportState {
  final String message;
  const ReportError({required this.message});
}
