import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;
  final String type; // 'expense', 'income', 'both'

  const CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}

class CategoryConstants {
  // Mau sac nhat quan cho tung danh muc theo anh tham chieu
  static const Color colorAnUong = Color(0xFFFF5252); // Do san ho
  static const Color colorMuaSam = Color(0xFF26C6DA); // Xanh ngoc / cyan
  static const Color colorLuong = Color(0xFF2EAD4B);  // Xanh la cay
  static const Color colorDiLai = Color(0xFFAB47BC);  // Tim
  static const Color colorHocTap = Color(0xFF1E88E5); // Xanh duong (theo cham Hoc tap man 6)
  static const Color colorKhac = Color(0xFFFB8C00);   // Vang cam (theo mau phan biet tren bieu do man 6)

  // Danh muc chi tieu theo dung anh tham chieu
  static const List<CategoryItem> expenseCategories = [
    CategoryItem(
      name: 'Ăn uống',
      icon: Icons.restaurant,
      color: colorAnUong,
      type: 'expense',
    ),
    CategoryItem(
      name: 'Mua sắm',
      icon: Icons.shopping_cart,
      color: colorMuaSam,
      type: 'expense',
    ),
    CategoryItem(
      name: 'Đi lại',
      icon: Icons.directions_car,
      color: colorDiLai,
      type: 'expense',
    ),
    CategoryItem(
      name: 'Học tập',
      icon: Icons.menu_book,
      color: colorHocTap,
      type: 'expense',
    ),
    CategoryItem(
      name: 'Khác',
      icon: Icons.more_horiz,
      color: colorKhac,
      type: 'expense',
    ),
  ];

  // Danh muc thu nhap theo anh (Luong) va bo sung Khac theo Quyet dinh mac dinh 2
  static const List<CategoryItem> incomeCategories = [
    CategoryItem(
      name: 'Lương',
      icon: Icons.work,
      color: colorLuong,
      type: 'income',
    ),
    CategoryItem(
      name: 'Khác',
      icon: Icons.more_horiz,
      color: colorKhac,
      type: 'income',
    ),
  ];

  // Tat ca danh muc
  static const List<CategoryItem> allCategories = [
    ...expenseCategories,
    CategoryItem(
      name: 'Lương',
      icon: Icons.work,
      color: colorLuong,
      type: 'income',
    ),
  ];

  // Lay bieu tuong theo ten danh muc, co du phong cho du lieu cu
  static IconData getIcon(String categoryName) {
    final clean = categoryName.trim();
    if (clean == 'Ăn uống') return Icons.restaurant;
    if (clean == 'Mua sắm') return Icons.shopping_cart;
    if (clean == 'Đi lại' || clean == 'Di chuyển') return Icons.directions_car;
    if (clean == 'Học tập' || clean == 'Giáo dục') return Icons.menu_book;
    if (clean == 'Lương' || clean == 'Thu nhập') return Icons.work;
    if (clean == 'Khác') return Icons.more_horiz;
    return Icons.category; // Bieu tuong du phong
  }

  // Lay mau sac theo ten danh muc, co du phong cho du lieu cu
  static Color getColor(String categoryName) {
    final clean = categoryName.trim();
    if (clean == 'Ăn uống') return colorAnUong;
    if (clean == 'Mua sắm') return colorMuaSam;
    if (clean == 'Đi lại' || clean == 'Di chuyển') return colorDiLai;
    if (clean == 'Học tập' || clean == 'Giáo dục') return colorHocTap;
    if (clean == 'Lương' || clean == 'Thu nhập') return colorLuong;
    if (clean == 'Khác') return colorKhac;
    return const Color(0xFF757575); // Mau du phong
  }

  // Chuan hoa ten danh muc neu con sot du lieu cu
  static String normalizeCategory(String categoryName) {
    final clean = categoryName.trim();
    if (clean == 'Di chuyển') return 'Đi lại';
    if (clean == 'Giáo dục') return 'Học tập';
    if (clean == 'Thu nhập') return 'Lương';
    return clean;
  }

  // Format tien te dang 5.000.000 d
  static String formatCurrency(double amount) {
    final rounded = amount.abs().toStringAsFixed(0);
    final formatted = rounded.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return '$formatted đ';
  }

  // Format ngay thang dd/MM/yyyy tu yyyy-MM-dd hoac DateTime
  static String formatDate(String isoDate) {
    final parts = isoDate.split('-');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return isoDate;
  }
}
