import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/report_repository.dart';
import '../models/transaction_report.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;
  List<TransactionReport>? _transactions;

  ReportBloc({required this.reportRepository}) : super(ReportInitial()) {
    on<UploadReportFileEvent>(_onUploadReportFile);
    on<CalculateTotalEvent>(_onCalculateTotal);
  }

  void _onUploadReportFile(
      UploadReportFileEvent event, Emitter<ReportState> emit) async {
    try {
      emit(ReportLoading());
      _transactions = await reportRepository.loadReport(event.file);
      emit(ReportFileUploaded());
    } catch (e) {
      emit(ReportError(message: e.toString()));
    }
  }

  void _onCalculateTotal(
      CalculateTotalEvent event, Emitter<ReportState> emit) async {
    if (_transactions == null) {
      emit(const ReportError(message: "Chưa upload file báo cáo"));
      return;
    }

    try {
      emit(ReportLoading());
      final startTime = _parseTime(event.startTime);
      final endTime = _parseTime(event.endTime);
      double totalAmount = 0;

      for (var transaction in _transactions!) {
        // Tạo đối tượng DateTime cho giao dịch
        final transactionDateTime = DateTime(
          transaction.date.year,
          transaction.date.month,
          transaction.date.day,
          transaction.time.hour,
          transaction.time.minute,
          transaction.time.second,
        );

        // Kiểm tra nếu transactionDateTime nằm trong khoảng thời gian
        if ((transactionDateTime.isAfter(startTime) ||
                transactionDateTime.isAtSameMomentAs(startTime)) &&
            (transactionDateTime.isBefore(endTime) ||
                transactionDateTime.isAtSameMomentAs(endTime))) {
          totalAmount += transaction.totalPrice;
        }
      }

      emit(ReportCalculated(totalAmount: totalAmount));
    } catch (e) {
      emit(ReportError(message: e.toString()));
    }
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    if (parts.length < 2) {
      throw const FormatException("Invalid time format");
    }

    // Gán ngày cố định là 2024-03-21
    final fixedDate = DateTime(2024, 3, 21);

    // Gán giây mặc định là 00
    final second = (parts.length == 3) ? int.parse(parts[2]) : 00;

    // Tạo DateTime với ngày cố định và giờ, phút, giây từ input
    return DateTime(
        fixedDate.year, fixedDate.month, fixedDate.day, hour, minute, second);
  }
}
