class TransactionModel {
  DateTime dateTime;
  double quantity;
  String pump;
  double revenue;
  double price;

  TransactionModel({
    required this.dateTime,
    required this.quantity,
    required this.pump,
    required this.revenue,
    required this.price,
  });
}
