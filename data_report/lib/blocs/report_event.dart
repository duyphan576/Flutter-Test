import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();
  @override
  List<Object> get props => [];
}

class UploadReportFileEvent extends ReportEvent {
  final File file;
  const UploadReportFileEvent(this.file);
}

class CalculateTotalEvent extends ReportEvent {
  final String startTime;
  final String endTime;
  const CalculateTotalEvent(this.startTime, this.endTime);
}
