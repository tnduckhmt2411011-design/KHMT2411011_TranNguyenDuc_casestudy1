import 'package:flutter_test/flutter_test.dart';
import 'package:casestudy1_app/models/transaction.dart';

void main() {
  group('Kiểm tra Model Transaction cho Buổi 5', () {
    test('Khởi tạo Transaction với đầy đủ thuộc tính', () {
      final t = Transaction(
        id: 1,
        title: 'Ăn trưa',
        amount: 50000.0,
        type: 'expense',
        date: '2026-10-01',
        category: 'Ăn uống',
      );

      expect(t.id, 1);
      expect(t.title, 'Ăn trưa');
      expect(t.amount, 50000.0);
      expect(t.type, 'expense');
      expect(t.date, '2026-10-01');
      expect(t.category, 'Ăn uống');
    });

    test('toMap() chuyển đổi chính xác sang Map<String, dynamic>', () {
      final t = Transaction(
        id: 2,
        title: 'Lương tháng 9',
        amount: 8000000.0,
        type: 'income',
        date: '2026-09-01',
        category: 'Thu nhập',
      );

      final map = t.toMap();
      expect(map['id'], 2);
      expect(map['title'], 'Lương tháng 9');
      expect(map['amount'], 8000000.0);
      expect(map['type'], 'income');
      expect(map['date'], '2026-09-01');
      expect(map['category'], 'Thu nhập');
    });

    test('fromMap() ánh xạ an toàn khi SQLite trả về amount kiểu int hoặc double', () {
      final mapInt = {
        'id': 3,
        'title': 'Mua sách',
        'amount': 150000, // SQLite trả về int khi không có phần thập phân
        'type': 'expense',
        'date': '2026-09-30',
        'category': 'Học tập',
      };

      final tInt = Transaction.fromMap(mapInt);
      expect(tInt.amount, 150000.0);
      expect(tInt.amount, isA<double>());

      final mapDouble = {
        'id': 4,
        'title': 'Cà phê',
        'amount': 35000.5,
        'type': 'expense',
        'date': '2026-10-01',
        'category': 'Ăn uống',
      };

      final tDouble = Transaction.fromMap(mapDouble);
      expect(tDouble.amount, 35000.5);
    });

    test('copyWith() tạo bản sao với các thuộc tính thay đổi', () {
      final t = Transaction(
        id: 5,
        title: 'Ăn trưa',
        amount: 50000.0,
        type: 'expense',
        date: '2026-10-01',
        category: 'Ăn uống',
      );

      final updated = t.copyWith(
        title: 'Ăn trưa cùng bạn',
        amount: 80000.0,
      );

      expect(updated.id, 5);
      expect(updated.title, 'Ăn trưa cùng bạn');
      expect(updated.amount, 80000.0);
      expect(updated.type, 'expense');
      expect(updated.date, '2026-10-01');
      expect(updated.category, 'Ăn uống');
    });
  });
}
