import 'package:excel/excel.dart';

class TransactionReport {
  final DateTime date;
  final DateTime time;
  final String fuelType;
  final double quantity;
  final double unitPrice;
  final double totalPrice;

  TransactionReport({
    required this.date,
    required this.time,
    required this.fuelType,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  // Phương thức này sẽ trả về một DateTime đầy đủ cho giao dịch
  DateTime get transactionDateTime =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  factory TransactionReport.fromRow(List<Data?> row) {
    // Ngày và giờ giao dịch
    final dateString = row[1]?.value?.toString().trim(); // Loại bỏ khoảng trắng
    final timeString = row[2]?.value?.toString().trim(); // Loại bỏ khoảng trắng
    if (dateString != null && timeString != null) {
      try {
        // Xử lý ngày (giả sử định dạng dd/MM/yyyy)
        if (dateString.contains('/')) {
          final dateParts = dateString.split('/');
          if (dateParts.length == 3) {
            final day = int.tryParse(dateParts[0]) ?? 1;
            final month = int.tryParse(dateParts[1]) ?? 1;
            final year = int.tryParse(dateParts[2]) ?? 1970;
            final date = DateTime(year, month, day);

            // Xử lý giờ (giả sử định dạng HH:mm:ss)
            if (timeString.contains(':')) {
              final timeParts = timeString.split(':');
              if (timeParts.length == 3) {
                final hour = int.tryParse(timeParts[0]) ?? 0;
                final minute = int.tryParse(timeParts[1]) ?? 0;
                final second = int.tryParse(timeParts[2]) ?? 0;
                final time = DateTime(0, 1, 1, hour, minute, second);

                // Số lượng, đơn giá và thành tiền (loại bỏ dấu phẩy)
                final quantityString =
                    row[6]?.value.toString().replaceAll(',', '') ?? '0';
                final unitPriceString =
                    row[7]?.value.toString().replaceAll(',', '') ?? '0';
                final totalPriceString =
                    row[8]?.value.toString().replaceAll(',', '') ?? '0';

                final quantity = double.tryParse(quantityString) ?? 0.0;
                final unitPrice = double.tryParse(unitPriceString) ?? 0.0;
                final totalPrice = double.tryParse(totalPriceString) ?? 0.0;

                // Mặt hàng (loại nhiên liệu)
                final fuelType = row[5]?.value.toString() ?? '';

                return TransactionReport(
                  date: date,
                  time: time,
                  fuelType: fuelType,
                  quantity: quantity,
                  unitPrice: unitPrice,
                  totalPrice: totalPrice,
                );
              } else {
                print("Invalid time format: $timeString");
              }
            }
          } else {
            print("Invalid date format: $dateString");
          }
        }
      } catch (e) {
        print("Error parsing date or time: $e");
      }
    }

    throw FormatException("Invalid date or time format");
  }
}
