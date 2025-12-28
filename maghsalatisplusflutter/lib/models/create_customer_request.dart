// lib/models/create_customer_request.dart

class CreateCustomerRequest {
  final String name;
  final String phoneNumber;
  final String shopOwnerId; // send your userId/token-subject

  CreateCustomerRequest({
    required this.name,
    required this.phoneNumber,
    required this.shopOwnerId,
  });

  Map<String, dynamic> toJson() => {
    'Name': name,
    'PhoneNumber': phoneNumber,
    'ShopOwnerId': shopOwnerId,
  };
}
