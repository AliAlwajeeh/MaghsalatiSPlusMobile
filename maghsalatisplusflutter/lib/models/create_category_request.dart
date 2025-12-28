// lib/models/create_category_request.dart

class CreateCategoryRequest {
  final String name;
  final String shopOwnerId;

  CreateCategoryRequest({required this.name, required this.shopOwnerId});

  Map<String, dynamic> toJson() => {'Name': name, 'ShopOwnerId': shopOwnerId};
}
