import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/query_model.dart';

class AlgorithmRepository {
  final String inputUrl =
      'https://test-share.shub.edu.vn/api/intern-test/input';
  final String outputUrl =
      'https://test-share.shub.edu.vn/api/intern-test/output';

  String token = '';
  List<int> data = [];
  List<QueryModel> queries = [];

  // Hàm lấy dữ liệu từ API
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(inputUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      token = jsonData['token'];
      data = List<int>.from(jsonData['data']);
      queries = (jsonData['query'] as List)
          .map((query) => QueryModel.fromJson(query))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Hàm gửi kết quả tới API
  Future<void> sendResults(List<int> results) async {
    final response = await http.post(
      Uri.parse(outputUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(results),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send results');
    }
  }

  // Hàm xử lý truy vấn
  List<int> processQueries() {
    // Lấy độ dài của mảng data
    int n = data.length;

    // Khởi tạo các mảng tích lũy với kích thước n + 1 do cần lưu thêm phần tử tại index 0
    List<int> prefixSum =
        List.filled(n + 1, 0); // Tổng tích lũy của tất cả các phần tử
    List<int> evenSum =
        List.filled(n + 1, 0); // Tổng tích lũy các phần tử ở vị trí chẵn
    List<int> oddSum =
        List.filled(n + 1, 0); // Tổng tích lũy các phần tử ở vị trí lẻ

    // Tạo các mảng tích lũy
    for (int i = 0; i < n; i++) {
      // Cập nhật mảng prefixSum để chứa tổng tích lũy từ đầu đến phần tử thứ i
      prefixSum[i + 1] = prefixSum[i] + data[i];

      // Nếu chỉ số i là chẵn, cập nhật mảng evenSum, còn oddSum giữ nguyên
      if (i % 2 == 0) {
        evenSum[i + 1] = evenSum[i] + data[i];
        oddSum[i + 1] = oddSum[i];
      }
      // Nếu chỉ số i là lẻ, cập nhật mảng oddSum, còn evenSum giữ nguyên
      else {
        oddSum[i + 1] = oddSum[i] + data[i];
        evenSum[i + 1] = evenSum[i];
      }
    }

    // Xử lý từng truy vấn
    List<int> results = [];

    for (var query in queries) {
      int l = query.range[0]; // Chỉ số bắt đầu của khoảng truy vấn
      int r = query.range[1]; // Chỉ số kết thúc của khoảng truy vấn
      int result = 0; // Biến lưu kết quả cho truy vấn hiện tại

      // Nếu truy vấn là loại 1: Tính tổng các phần tử trong khoảng [l, r]
      if (query.type == "1") {
        // Kết quả là tổng các phần tử từ l đến r, được tính bằng hiệu của prefixSum
        result = prefixSum[r + 1] - prefixSum[l];
      }
      // Nếu truy vấn là loại 2: Tính tổng các phần tử chẵn trừ đi tổng các phần tử lẻ trong khoảng [l, r]
      else if (query.type == "2") {
        // Tổng các phần tử ở vị trí chẵn từ l đến r
        int evenPart = evenSum[r + 1] - evenSum[l];
        // Tổng các phần tử ở vị trí lẻ từ l đến r
        int oddPart = oddSum[r + 1] - oddSum[l];
        // Kết quả là hiệu của tổng phần tử chẵn và tổng phần tử lẻ
        result = evenPart - oddPart;
      }

      // Thêm kết quả truy vấn hiện tại vào danh sách kết quả
      results.add(result);
    }

    return results;
  }
}
