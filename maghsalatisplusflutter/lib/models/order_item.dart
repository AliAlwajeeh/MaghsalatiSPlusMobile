// يمثل صنفاً داخل الطلب
class OrderItem {
  final int id;
  final String itemName;
  final int quantity;
  final double price;
  final String service; // Wash, Iron, WashAndIron
  final String categoryName; // اسم القسم
  final String? imageUrl; // إذا كان الـ API يعيد رابط صورة

  OrderItem({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.service,
    required this.categoryName,
    this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      itemName: json['itemName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      service: json['serviceType'] as String,
      categoryName: json['category']['name'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
