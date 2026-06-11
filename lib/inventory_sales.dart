import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    setState(() {
      _products = List.generate(maps.length, (i) {
        return Product(
          id: maps[i]['id'],
          barcode: maps[i]['barcode'],
          name: maps[i]['name'],
          categoryId: maps[i]['category_id'],
          purchasePrice: maps[i]['purchase_price'],
          wholesalePrice: maps[i]['wholesale_price'],
          retailPrice: maps[i]['retail_price'],
          quantity: maps[i]['quantity'],
          minStock: maps[i]['min_stock'],
          storageLocation: maps[i]['storage_location'],
        );
      });
    });
  }

  void _addProduct() {
    // Show dialog to add product
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المخزون')),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('الكمية: ${product.quantity} - السعر: ${product.retailPrice}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final List<Product> _cart = [];
  double _total = 0;

  void _addToCart(Product product) {
    setState(() {
      _cart.add(product);
      _total += product.retailPrice;
    });
  }

  void _checkout() {
    // Process checkout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المبيعات')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_cart[index].name),
                  trailing: Text(_cart[index].retailPrice.toString()),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الإجمالي: $_total', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: _checkout,
                  child: const Text('إتمام البيع'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
