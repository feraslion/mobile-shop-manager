import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    setState(() {
      _customers = List.generate(maps.length, (i) {
        return Customer(
          id: maps[i]['id'],
          name: maps[i]['name'],
          phone: maps[i]['phone'],
          debt: maps[i]['debt'],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العملاء')),
      body: ListView.builder(
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          final customer = _customers[index];
          return ListTile(
            title: Text(customer.name),
            subtitle: Text('الهاتف: ${customer.phone ?? "N/A"}'),
            trailing: Text('الديون: ${customer.debt}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصيانة')),
      body: const Center(child: Text('شاشة إدارة الصيانة')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_build),
      ),
    );
  }
}
