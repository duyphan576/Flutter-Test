import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form/bloc/transaction_event.dart';
import 'package:form/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<UpdateTransactionEvent>(_onUpdateTransaction);
  }

  void _onUpdateTransaction(
      UpdateTransactionEvent event, Emitter<TransactionState> emit) {
    try {
      // Validate dữ liệu nếu cần
      if (event.transaction.quantity <= 0) {
        throw Exception("Quantity must be greater than 0");
      }
      if (event.transaction.revenue <= 0 || event.transaction.price <= 0) {
        throw Exception("Invalid revenue or price");
      }

      // Thành công
      emit(TransactionSuccess("Transaction updated successfully"));
      // Đưa trạng thái về ban đầu sau khi thành công hoặc lỗi để lần sau có thể tiếp tục hiển thị thông báo
      emit(TransactionInitial());
    } catch (e) {
      emit(TransactionError(e.toString()));
      // Reset lại trạng thái sau khi lỗi
      emit(TransactionInitial());
    }
  }
}
