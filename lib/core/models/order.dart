class MockOrder {
  const MockOrder({
    required this.id,
    required this.productId,
    required this.productName,
    required this.status,
    required this.total,
    required this.createdAtIso,
  });

  final String id;
  final String productId;
  final String productName;
  final String status;
  final double total;
  final String createdAtIso;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'productName': productName,
      'status': status,
      'total': total,
      'createdAtIso': createdAtIso,
    };
  }

  factory MockOrder.fromJson(Map<dynamic, dynamic> json) {
    return MockOrder(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      status: json['status'] as String,
      total: (json['total'] as num).toDouble(),
      createdAtIso: json['createdAtIso'] as String,
    );
  }
}
