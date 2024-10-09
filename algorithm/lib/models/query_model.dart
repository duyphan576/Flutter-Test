class QueryModel {
  final String type;
  final List<int> range;

  QueryModel({required this.type, required this.range});

  factory QueryModel.fromJson(Map<String, dynamic> json) {
    return QueryModel(
      type: json['type'],
      range: List<int>.from(json['range']),
    );
  }
}
