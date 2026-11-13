import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:casestudy1_app/models/filter_criteria.dart';
import 'package:casestudy1_app/models/transaction.dart';
import 'package:casestudy1_app/screens/filter_screen.dart';
import 'package:casestudy1_app/screens/profile_screen.dart';
import 'package:casestudy1_app/screens/statistics_screen.dart';
import 'package:casestudy1_app/screens/transaction_list_screen.dart';
import 'package:casestudy1_app/screens/welcome_screen.dart';
import 'package:casestudy1_app/pages/home_page.dart';

void main() {
  group('Kiểm thử chi tiết UI 8 màn hình Buổi 6', () {
    testWidgets('1. Màn hình chào mừng Welcome hiển thị đúng chữ và nút Bắt đầu', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WelcomeScreen()),
      );

      expect(find.text('Expense Manager'), findsOneWidget);
      expect(
        find.text('Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả'),
        findsOneWidget,
      );
      expect(find.text('Bắt đầu'), findsOneWidget);
    });

    testWidgets('2. Màn hình Dashboard hiển thị Header, Thẻ số dư và 2 thẻ Thu chi', (tester) async {
      final sample = [
        Transaction(
          id: 1,
          title: 'Lương',
          amount: 10000000,
          type: 'income',
          date: '2025-04-05',
          category: 'Lương',
        ),
        Transaction(
          id: 2,
          title: 'Ăn uống',
          amount: 100000,
          type: 'expense',
          date: '2025-04-12',
          category: 'Ăn uống',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(home: HomePage(initialTransactions: sample)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Xin chào!'), findsOneWidget);
      expect(find.text('Hôm nay là một ngày tốt lành!'), findsOneWidget);
      expect(find.text('Số dư hiện tại'), findsOneWidget);
      expect(find.text('9.900.000 đ'), findsOneWidget);
      expect(find.text('Thu nhập'), findsOneWidget);
      expect(find.text('+10.000.000 đ'), findsWidgets);
      expect(find.text('Chi tiêu'), findsOneWidget);
      expect(find.text('100.000 đ'), findsWidgets);
      expect(find.text('Chi tiêu gần đây'), findsOneWidget);
      expect(find.text('Xem tất cả'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('3. Màn hình Danh sách Giao dịch hiển thị ô tìm kiếm và 3 chip', (tester) async {
      final sample = [
        Transaction(
          id: 1,
          title: 'Ăn trưa bún bò',
          amount: 50000,
          type: 'expense',
          date: '2025-04-12',
          category: 'Ăn uống',
        ),
        Transaction(
          id: 2,
          title: 'Thưởng quý',
          amount: 2000000,
          type: 'income',
          date: '2025-04-10',
          category: 'Lương',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: TransactionListScreen(initialTransactions: sample),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Giao dịch'), findsOneWidget);
      expect(find.text('Tìm kiếm giao dịch...'), findsOneWidget);
      expect(find.text('Tất cả'), findsOneWidget);
      expect(find.text('Thu nhập'), findsOneWidget);
      expect(find.text('Chi tiêu'), findsOneWidget);
      expect(find.text('Ăn uống'), findsOneWidget);
      expect(find.text('Lương'), findsOneWidget);

      // Thử lọc chip Thu nhập
      await tester.tap(find.text('Thu nhập'));
      await tester.pumpAndSettle();
      expect(find.text('Lương'), findsOneWidget);
      expect(find.text('Ăn uống'), findsNothing);

      // Thử lọc chip Chi tiêu
      await tester.tap(find.text('Chi tiêu'));
      await tester.pumpAndSettle();
      expect(find.text('Ăn uống'), findsOneWidget);
      expect(find.text('Lương'), findsNothing);
    });

    testWidgets('6. Màn hình Thống kê vẽ biểu đồ tròn và danh sách chú giải', (tester) async {
      final now = DateTime.now();
      final monthStr = now.month.toString().padLeft(2, '0');
      final sample = [
        Transaction(
          id: 1,
          title: 'Ăn buffet',
          amount: 2000000,
          type: 'expense',
          date: '${now.year}-$monthStr-10',
          category: 'Ăn uống',
        ),
        Transaction(
          id: 2,
          title: 'Mua áo khoác',
          amount: 1500000,
          type: 'expense',
          date: '${now.year}-$monthStr-12',
          category: 'Mua sắm',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(home: StatisticsScreen(initialTransactions: sample)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Thống kê'), findsOneWidget);
      expect(find.text('Tháng này'), findsOneWidget);
      expect(find.text('Tháng trước'), findsOneWidget);
      expect(find.text('Năm nay'), findsOneWidget);
      expect(find.text('3.500.000 đ'), findsOneWidget);
      expect(find.text('Tổng chi tiêu'), findsOneWidget);

      // Tỷ lệ: 2.000.000 / 3.500.000 = 57%, 1.500.000 / 3.500.000 = 43%
      expect(find.text('Ăn uống'), findsOneWidget);
      expect(find.text('57%'), findsOneWidget);
      expect(find.text('Mua sắm'), findsOneWidget);
      expect(find.text('43%'), findsOneWidget);
    });

    testWidgets('7. Màn hình Cá nhân hiển thị thông tin và danh sách menu', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ProfileScreen()),
      );

      expect(find.text('Cá nhân'), findsOneWidget);
      expect(find.text('Nguyễn Văn A'), findsOneWidget);
      expect(find.text('nguyenvana@example.com'), findsOneWidget);
      expect(find.text('Thông tin cá nhân'), findsOneWidget);
      expect(find.text('Cài đặt ngân sách'), findsOneWidget);
      expect(find.text('Danh mục chi tiêu'), findsOneWidget);
      expect(find.text('Sao lưu dữ liệu'), findsOneWidget);
      expect(find.text('Đổi mật khẩu'), findsOneWidget);
      expect(find.text('Đăng xuất'), findsOneWidget);
    });

    testWidgets('8. Màn hình Bộ lọc cho phép chọn và hủy chọn khoảng thời gian', (tester) async {
      FilterCriteria? applied;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  applied = await Navigator.push<FilterCriteria>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FilterScreen(),
                    ),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Bộ lọc'), findsOneWidget);
      expect(find.text('Loại giao dịch'), findsOneWidget);
      expect(find.text('Danh mục'), findsOneWidget);
      expect(find.text('Khoảng thời gian'), findsOneWidget);
      expect(find.text('Áp dụng'), findsOneWidget);

      // Chạm lại vào Hôm nay để bỏ chọn theo Quyết định mặc định 7
      await tester.tap(find.text('Hôm nay'));
      await tester.pumpAndSettle();

      // Bấm Áp dụng
      await tester.tap(find.text('Áp dụng'));
      await tester.pumpAndSettle();

      expect(applied, isNotNull);
      expect(applied!.timeRange, isNull);
    });
  });
}
