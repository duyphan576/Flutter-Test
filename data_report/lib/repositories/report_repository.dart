import 'dart:io';
import 'package:data_report/models/transaction_report.dart';
import 'package:excel/excel.dart';

class ReportRepository {
  // Đọc dữ liệu từ file Excel và trả về danh sách TransactionReport
  Future<List<TransactionReport>> loadReport(File file) async {
    final bytes = await file.readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    final List<TransactionReport> transactions = [];

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]!;

      // Bỏ qua 8 hàng đầu tiên (từ 0 đến 7), bắt đầu từ hàng 8 (index 8)
      for (var rowIndex = 8; rowIndex < sheet.rows.length; rowIndex++) {
        var row = sheet.rows[rowIndex];

        // Kiểm tra nếu các cột cần thiết không phải là null
        if (row[1] != null &&
            row[2] != null &&
            row[6] != null &&
            row[8] != null) {
          try {
            final transaction = TransactionReport.fromRow(row);
            transactions.add(transaction);
          } catch (e) {
            print("Error parsing row ${rowIndex + 1}: $e");
          }
        }
      }
    }

    return transactions;
  }
}
