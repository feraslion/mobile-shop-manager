class User {
  final int? id;
  final String username;
  final String password;
  final String role;
  final String? permissions;

  User({this.id, required this.username, required this.password, required this.role, this.permissions});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
      'permissions': permissions,
    };
  }
}

class Product {
  final int? id;
  final String? barcode;
  final String name;
  final int? categoryId;
  final double purchasePrice;
  final double wholesalePrice;
  final double retailPrice;
  int quantity;
  final int minStock;
  final String? storageLocation;

  Product({
    this.id,
    this.barcode,
    required this.name,
    this.categoryId,
    required this.purchasePrice,
    required this.wholesalePrice,
    required this.retailPrice,
    required this.quantity,
    required this.minStock,
    this.storageLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'category_id': categoryId,
      'purchase_price': purchasePrice,
      'wholesale_price': wholesalePrice,
      'retail_price': retailPrice,
      'quantity': quantity,
      'min_stock': minStock,
      'storage_location': storageLocation,
    };
  }
}

class Customer {
  final int? id;
  final String name;
  final String? phone;
  double debt;

  Customer({this.id, required this.name, this.phone, this.debt = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'debt': debt,
    };
  }
}

class Sale {
  final int? id;
  final int? customerId;
  final double totalAmount;
  final double paidAmount;
  final String paymentType;
  final String date;
  final int userId;

  Sale({
    this.id,
    this.customerId,
    required this.totalAmount,
    required this.paidAmount,
    required this.paymentType,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'payment_type': paymentType,
      'date': date,
      'user_id': userId,
    };
  }
}
