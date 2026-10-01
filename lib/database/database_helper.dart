import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;

class DatabaseHelper {
  // 1. Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();
  factory DatabaseHelper() => instance;

  static Database? _database;

  // 2. Lazy initialization
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // 3. Khởi tạo và mở database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expense.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // 4. Tạo bảng transactions khi database được tạo lần đầu
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');
  }

  // 5. Thêm dữ liệu (Create)
  Future<int> insertTransaction(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      'transactions',
      data,
    );
  }

  // 6. Đọc danh sách dữ liệu (Read)
  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return await db.query(
      'transactions',
      orderBy: 'date DESC, id DESC',
    );
  }

  // 7. Cập nhật dữ liệu (Update)
  Future<int> updateTransaction(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'transactions',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 8. Xóa dữ liệu (Delete)
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 9. Đóng kết nối database nếu cần
  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
    }
  }
}
