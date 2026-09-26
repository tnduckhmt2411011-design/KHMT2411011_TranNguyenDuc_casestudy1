import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:casestudy1_app/pages/home_page.dart';
import 'package:casestudy1_app/pages/expense_form_screen.dart';
import 'package:casestudy1_app/pages/expense_list_page.dart';
import 'package:casestudy1_app/models/expense.dart';

void main() {
  group('Kiểm tra toàn diện Buổi 3', () {
    testWidgets('ExpenseFormScreen: Hiển thị đầy đủ các trường nhập liệu và toggle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ExpenseFormScreen(
            onSave: (_) {},
          ),
        ),
      );

      // 1. Kiểm tra tiêu đề màn hình thêm
      expect(find.text('Thêm giao dịch'), findsOneWidget);

      // 2. Kiểm tra bộ chuyển Chi tiêu / Thu nhập
      expect(find.text('Chi tiêu'), findsOneWidget);
      expect(find.text('Thu nhập'), findsOneWidget);

      // 3. Kiểm tra các nhãn trường
      expect(find.text('Danh mục'), findsOneWidget);
      expect(find.text('Số tiền'), findsOneWidget);
      expect(find.text('Ngày giao dịch'), findsOneWidget);
      expect(find.text('Ghi chú'), findsOneWidget);

      // 4. Kiểm tra nút Lưu
      expect(find.text('Lưu'), findsOneWidget);
    });

    testWidgets('ExpenseFormScreen: Validation số tiền rỗng hoặc không hợp lệ', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ExpenseFormScreen(
            onSave: (_) {},
          ),
        ),
      );

      // Cuộn tới nút Lưu và nhấn Lưu khi chưa nhập số tiền
      await tester.ensureVisible(find.text('Lưu'));
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();

      expect(find.text('Vui lòng nhập số tiền'), findsOneWidget);

      // Nhập số tiền = 0
      final amountFinder = find.widgetWithText(TextFormField, '');
      await tester.enterText(amountFinder.first, '0');
      await tester.ensureVisible(find.text('Lưu'));
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();

      expect(find.text('Số tiền phải lớn hơn 0'), findsOneWidget);
    });

    testWidgets('ExpenseFormScreen: Chế độ Sửa giao dịch hiển thị đúng dữ liệu ban đầu', (WidgetTester tester) async {
      final sampleExpense = Expense(
        id: 'TEST_01',
        title: 'Ăn trưa',
        amount: 100000,
        category: 'Ăn uống',
        date: DateTime(2025, 4, 12),
        isExpense: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ExpenseFormScreen(
            initialExpense: sampleExpense,
            onSave: (_) {},
          ),
        ),
      );

      // Tiêu đề chuyển sang Sửa giao dịch
      expect(find.text('Sửa giao dịch'), findsOneWidget);
      expect(find.text('100000'), findsOneWidget);
      expect(find.text('Ăn trưa'), findsOneWidget);
    });

    testWidgets('ExpenseListPage: Hiển thị danh sách và CRUD', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExpenseListPage(),
        ),
      );

      expect(find.text('Danh sách khoản chi'), findsOneWidget);
      expect(find.text('Ăn sáng'), findsOneWidget);
      expect(find.text('Xăng xe'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

  group('Kiểm tra toàn diện Buổi 4', () {
    testWidgets('HomePage: Hiển thị đầy đủ các thành phần Dashboard theo tài liệu', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // 1. Header
      expect(find.text('Quản lý thu chi'), findsOneWidget);
      expect(find.text('3'), findsOneWidget); // badge thông báo

      // 2. Thẻ số dư (BalanceCard)
      expect(find.text('SỐ DƯ HIỆN TẠI'), findsOneWidget);
      expect(find.text('7.050.000 đ'), findsOneWidget);

      // 3. Khu vực tổng thu nhập & tổng chi tiêu (SummarySection)
      expect(find.text('TỔNG THU NHẬP'), findsOneWidget);
      expect(find.text('8.000.000 đ'), findsOneWidget);
      expect(find.text('TỔNG CHI TIÊU'), findsOneWidget);
      expect(find.text('950.000 đ'), findsOneWidget);

      // 4. Danh sách giao dịch gần đây (TransactionHeader & TransactionList)
      expect(find.text('Giao dịch gần đây'), findsOneWidget);
      expect(find.text('Xem tất cả'), findsOneWidget);
      expect(find.text('Ăn trưa'), findsOneWidget);
      expect(find.text('Xăng xe'), findsOneWidget);
      expect(find.text('Lương tháng 9'), findsOneWidget);

      // 5. Bottom Navigation Bar
      expect(find.text('Trang chủ'), findsOneWidget);
      expect(find.text('Giao dịch'), findsOneWidget);
      expect(find.text('Thống kê'), findsOneWidget);

      // 6. Floating Action Button
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // 7. Chuyển tab sang Giao dịch
      await tester.tap(find.text('Giao dịch'));
      await tester.pumpAndSettle();
      expect(find.text('Danh sách khoản chi'), findsOneWidget);
    });

    testWidgets('HomePage: Tự động cập nhật số dư, tổng thu và tổng chi khi chuyển đổi giao dịch từ Chi tiêu sang Thu nhập', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Ban đầu: Thu nhập 8.000.000 đ, Chi tiêu 950.000 đ, Số dư 7.050.000 đ
      expect(find.text('8.000.000 đ'), findsOneWidget);
      expect(find.text('950.000 đ'), findsOneWidget);
      expect(find.text('7.050.000 đ'), findsOneWidget);

      // Chuyển sang tab Giao dịch
      await tester.tap(find.text('Giao dịch'));
      await tester.pumpAndSettle();

      // Mở sửa giao dịch đầu tiên 'Ăn trưa' (50.000 đ)
      final editIcons = find.byIcon(Icons.edit_outlined);
      await tester.tap(editIcons.first);
      await tester.pumpAndSettle();

      // Chuyển sang Thu nhập (sử dụng .last để chọn nút toggle trên ExpenseFormScreen)
      await tester.tap(find.text('Thu nhập').last);
      await tester.pumpAndSettle();

      // Cuộn tới nút Lưu và nhấn Lưu
      await tester.ensureVisible(find.text('Lưu'));
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();

      // Quay lại Trang chủ
      await tester.tap(find.text('Trang chủ'));
      await tester.pumpAndSettle();

      // Sau khi chuyển Ăn trưa (50.000 đ) sang Thu nhập:
      // Tổng thu nhập: 8.000.000 + 50.000 = 8.050.000 đ
      // Tổng chi tiêu: 950.000 - 50.000 = 900.000 đ (giảm đi chính xác!)
      // Số dư: 8.050.000 - 900.000 = 7.150.000 đ
      expect(find.text('8.050.000 đ'), findsOneWidget);
      expect(find.text('900.000 đ'), findsOneWidget);
      expect(find.text('7.150.000 đ'), findsOneWidget);
    });
  });
}
