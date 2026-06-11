import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mobile_shop.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        permissions TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        section TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT,
        name TEXT NOT NULL,
        category_id INTEGER,
        purchase_price REAL,
        wholesale_price REAL,
        retail_price REAL,
        quantity INTEGER,
        min_stock INTEGER,
        storage_location TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        debt REAL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER,
        total_amount REAL,
        paid_amount REAL,
        payment_type TEXT,
        date TEXT,
        user_id INTEGER,
        FOREIGN KEY (customer_id) REFERENCES customers (id),
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE sale_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_id INTEGER,
        product_id INTEGER,
        quantity INTEGER,
        price REAL,
        FOREIGN KEY (sale_id) REFERENCES sales (id),
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE maintenance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_name TEXT,
        phone TEXT,
        product TEXT,
        problem TEXT,
        solution TEXT,
        price REAL,
        delivery_date TEXT,
        status TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE spare_parts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        purchase_price REAL,
        quantity INTEGER,
        min_stock INTEGER,
        location TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE suppliers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT,
        phone TEXT,
        address TEXT,
        debt REAL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE wallets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        number TEXT,
        company TEXT,
        balance REAL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE cash_drawer (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_type TEXT,
        category TEXT,
        amount REAL,
        source TEXT,
        date TEXT,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        details TEXT,
        date TEXT,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Insert default admin
    await db.insert('users', {
      'username': 'admin',
      'password': 'admin123',
      'role': 'admin',
      'permissions': 'all'
    });
  }
}
