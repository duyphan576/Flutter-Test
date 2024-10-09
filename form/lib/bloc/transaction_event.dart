import 'package:equatable/equatable.dart';
import 'package:form/models/transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class UpdateTransactionEvent extends TransactionEvent {
  final TransactionModel transaction;

  const UpdateTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}
