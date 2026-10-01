import 'package:sqflite/sqflite.dart' hide Transaction;
import '../database/database_helper.dart';
import '../models/transaction.dart';

class TransactionRepository {
  final DatabaseHelper _dbHelper;

  TransactionRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  // 1. CREATE: Thêm giao dịch mới
  Future<int> insertTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  // 2. READ: Lấy toàn bộ danh sách giao dịch
  Future<List<Transaction>> getAllTransactions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC, id DESC',
    );
    return maps.map((map) => Transaction.fromMap(map)).toList();
  }

  // 3. READ: Lấy danh sách giao dịch gần đây (mặc định 5 mục cho Dashboard)
  Future<List<Transaction>> getRecentTransactions({int limit = 5}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC, id DESC',
      limit: limit,
    );
    return maps.map((map) => Transaction.fromMap(map)).toList();
  }

  // 4. READ: Lấy chi tiết một giao dịch theo id
  Future<Transaction?> getTransactionById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Transaction.fromMap(maps.first);
    }
    return null;
  }

  // 5. UPDATE: Cập nhật thông tin giao dịch
  Future<int> updateTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // 6. DELETE: Xóa giao dịch theo id
  Future<int> deleteTransaction(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 7. READ: Tìm kiếm giao dịch theo từ khóa tiêu đề (LIKE)
  Future<List<Transaction>> searchTransactions(String keyword) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'title LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'date DESC, id DESC',
    );
    return maps.map((map) => Transaction.fromMap(map)).toList();
  }

  // 8. READ: Lọc danh sách giao dịch theo loại ('income' hoặc 'expense')
  Future<List<Transaction>> getTransactionsByType(String type) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'date DESC, id DESC',
    );
    return maps.map((map) => Transaction.fromMap(map)).toList();
  }
}
