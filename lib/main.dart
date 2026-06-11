import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';
import 'models.dart';
import 'inventory_sales.dart';
import 'customers_maintenance.dart';
import 'suppliers_wallets.dart';
import 'reports_settings.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const MobileShopApp(),
    ),
  );
}

class AppState extends ChangeNotifier {
  User? currentUser;

  void login(User user) {
    currentUser = user;
    notifyListeners();
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}

class MobileShopApp extends StatelessWidget {
  const MobileShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام إدارة محل الموبايلات',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo', // Assuming Arabic font
      ),
      home: const LoginScreen(),
      textDirection: TextDirection.rtl,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _login() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [_usernameController.text, _passwordController.text],
    );

    if (maps.isNotEmpty) {
      final user = User(
        id: maps[0]['id'],
        username: maps[0]['username'],
        password: maps[0]['password'],
        role: maps[0]['role'],
        permissions: maps[0]['permissions'],
      );
      Provider.of<AppState>(context, listen: false).login(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اسم المستخدم أو كلمة المرور غير صحيحة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'اسم المستخدم'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'كلمة المرور'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('دخول'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القائمة الرئيسية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AppState>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuItem(context, 'المخزون', Icons.inventory, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryScreen()));
          }),
          _buildMenuItem(context, 'المبيعات', Icons.shopping_cart, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesScreen()));
          }),
          _buildMenuItem(context, 'العملاء', Icons.people, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomersScreen()));
          }),
          _buildMenuItem(context, 'الصيانة', Icons.build, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MaintenanceScreen()));
          }),
          _buildMenuItem(context, 'الموردين', Icons.local_shipping, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SuppliersScreen()));
          }),
          _buildMenuItem(context, 'الدرج', Icons.account_balance_wallet, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CashDrawerScreen()));
          }),
          _buildMenuItem(context, 'التقارير', Icons.assessment, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsScreen()));
          }),
          _buildMenuItem(context, 'الإعدادات', Icons.settings, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
