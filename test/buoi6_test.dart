import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:casestudy1_app/models/transaction.dart';
import 'package:casestudy1_app/pages/home_page.dart';
import 'package:casestudy1_app/pages/expense_form_screen.dart';
import 'package:casestudy1_app/repositories/transaction_repository.dart';

class FakeTransactionRepository extends TransactionRepository {
  final List<Transaction> storage;

  FakeTransactionRepository([List<Transaction>? initial])
      : storage = initial != null ? List.from(initial) : [];

  @override
  Future<int> insertTransaction(Transaction transaction) async {
    final newId = (storage.isEmpty ? 0 : storage.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b)) + 1;
    final item = transaction.copyWith(id: newId);
    storage.insert(0, item);
    return newId;
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final list = List<Transaction>.from(storage);
    list.sort((a, b) {
      final dateCmp = b.date.compareTo(a.date);
      if (dateCmp != 0) return dateCmp;
      return (b.id ?? 0).compareTo(a.id ?? 0);
    });
    return list;
  }

  @override
  Future<List<Transaction>> getRecentTransactions({int limit = 5}) async {
    final list = await getAllTransactions();
    return list.take(limit).toList();
  }

  @override
  Future<int> updateTransaction(Transaction transaction) async {
    final idx = storage.indexWhere((t) => t.id == transaction.id);
    if (idx != -1) {
      storage[idx] = transaction;
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteTransaction(int id) async {
    final count = storage.where((t) => t.id == id).length;
    storage.removeWhere((t) => t.id == id);
    return count;
  }
}

void main() {
  group('Kiểm tra toàn diện Buổi 6 - SQLite & Repository Integration', () {
    test('TransactionRepository logic CRUD kiểm thử', () async {
      final repo = FakeTransactionRepository();

      // 1. Create
      final id1 = await repo.insertTransaction(Transaction(
        title: 'Ăn trưa',
        amount: 50000.0,
        type: 'expense',
        date: '2026-10-01',
        category: 'Ăn uống',
      ));
      expect(id1, 1);

      final id2 = await repo.insertTransaction(Transaction(
        title: 'Lương tháng 9',
        amount: 8000000.0,
        type: 'income',
        date: '2026-09-01',
        category: 'Thu nhập',
      ));
      expect(id2, 2);

      // 2. Read All
      final all = await repo.getAllTransactions();
      expect(all.length, 2);
      expect(all.first.title, 'Ăn trưa'); // Ngày 2026-10-01 xếp trước 2026-09-01

      // 3. Update
      final toUpdate = all.first.copyWith(amount: 60000.0, title: 'Ăn trưa buffet');
      await repo.updateTransaction(toUpdate);
      final updatedList = await repo.getAllTransactions();
      expect(updatedList.first.amount, 60000.0);
      expect(updatedList.first.title, 'Ăn trưa buffet');

      // 4. Delete
      await repo.deleteTransaction(id1);
      final remaining = await repo.getAllTransactions();
      expect(remaining.length, 1);
      expect(remaining.first.title, 'Lương tháng 9');
    });

    testWidgets('Dashboard hiển thị trạng thái rỗng khi chưa có dữ liệu (0 đ và thông báo rỗng)', (WidgetTester tester) async {
      final repo = FakeTransactionRepository([]);

      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(repository: repo),
        ),
      );
      await tester.pumpAndSettle();

      // Kiểm tra số dư hiển thị 0 đ
      expect(find.text('0 đ'), findsNWidgets(3)); // Thẻ số dư, Tổng thu, Tổng chi đều 0 đ
      // Thông báo rỗng
      expect(find.text('Chưa có giao dịch nào'), findsOneWidget);
    });

    testWidgets('Dashboard tính toán chính xác số dư, tổng thu, tổng chi bằng fold từ Repository', (WidgetTester tester) async {
      final repo = FakeTransactionRepository([
        Transaction(
          id: 1,
          title: 'Lương tháng 9',
          amount: 8000000.0,
          type: 'income',
          date: '2026-09-01',
          category: 'Thu nhập',
        ),
        Transaction(
          id: 2,
          title: 'Ăn trưa',
          amount: 50000.0,
          type: 'expense',
          date: '2026-09-03',
          category: 'Ăn uống',
        ),
        Transaction(
          id: 3,
          title: 'Xăng xe',
          amount: 100000.0,
          type: 'expense',
          date: '2026-09-03',
          category: 'Di chuyển',
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(repository: repo),
        ),
      );
      await tester.pumpAndSettle();

      // Tổng thu = 8.000.000 đ
      expect(find.text('8.000.000 đ'), findsOneWidget);
      // Tổng chi = 150.000 đ
      expect(find.text('150.000 đ'), findsOneWidget);
      // Số dư = 7.850.000 đ
      expect(find.text('7.850.000 đ'), findsOneWidget);

      // Hiển thị các giao dịch
      expect(find.text('Ăn trưa'), findsOneWidget);
      expect(find.text('Xăng xe'), findsOneWidget);
      expect(find.text('Lương tháng 9'), findsOneWidget);
    });

    testWidgets('Màn hình Sửa điền sẵn số tiền dạng số thô (ví dụ 100000)', (WidgetTester tester) async {
      final repo = FakeTransactionRepository();
      final sample = Transaction(
        id: 10,
        title: 'Ăn tối sang',
        amount: 250000.0,
        type: 'expense',
        date: '2026-10-01',
        category: 'Ăn uống',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ExpenseFormScreen(
            initialTransaction: sample,
            repository: repo,
          ),
        ),
      );

      // Kiểm tra tiêu đề Sửa giao dịch
      expect(find.text('Sửa giao dịch'), findsOneWidget);
      // Số tiền thô 250000 (không có dấu chấm)
      expect(find.text('250000'), findsOneWidget);
      expect(find.text('Ăn tối sang'), findsOneWidget);
    });

    testWidgets('Thao tác Thêm giao dịch qua Form lưu vào Repository và trả về true', (WidgetTester tester) async {
      final repo = FakeTransactionRepository([]);

      await tester.pumpWidget(
        MaterialApp(
          home: ExpenseFormScreen(
            repository: repo,
          ),
        ),
      );

      // Nhập số tiền
      final amountFinder = find.widgetWithText(TextFormField, '');
      await tester.enterText(amountFinder.first, '75000');

      // Nhập ghi chú
      await tester.enterText(amountFinder.last, 'Mua cà phê sáng');

      // Nhấn Lưu
      await tester.ensureVisible(find.text('Lưu'));
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();

      expect(repo.storage.length, 1);
      expect(repo.storage.first.amount, 75000.0);
      expect(repo.storage.first.title, 'Mua cà phê sáng');
      expect(repo.storage.first.type, 'expense');
    });
  });
}
