import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'expense_form_screen.dart';

class ExpenseListPage extends StatefulWidget {
  final List<Expense>? externalExpenses;
  final Function(Expense)? onAdd;
  final Function(int, Expense)? onEdit;
  final Function(int)? onDelete;

  const ExpenseListPage({
    super.key,
    this.externalExpenses,
    this.onAdd,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  late List<Expense> _localExpenses;

  @override
  void initState() {
    super.initState();
    _localExpenses = [
      Expense(
        id: 'E001',
        title: 'Ăn sáng',
        amount: 35000,
        category: 'Ăn uống',
        date: DateTime(2024, 9, 3),
        isExpense: true,
      ),
      Expense(
        id: 'E002',
        title: 'Xăng xe',
        amount: 50000,
        category: 'Di chuyển',
        date: DateTime(2024, 9, 3),
        isExpense: true,
      ),
      Expense(
        id: 'E003',
        title: 'Lương tháng 9',
        amount: 8000000,
        category: 'Khác',
        date: DateTime(2024, 9, 1),
        isExpense: false,
      ),
      Expense(
        id: 'E004',
        title: 'Mua sắm',
        amount: 300000,
        category: 'Mua sắm',
        date: DateTime(2024, 8, 31),
        isExpense: true,
      ),
      Expense(
        id: 'E005',
        title: 'Học phí',
        amount: 500000,
        category: 'Học tập',
        date: DateTime(2024, 8, 30),
        isExpense: true,
      ),
    ];
  }

  List<Expense> get _expenses => widget.externalExpenses ?? _localExpenses;

  void _addExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseFormScreen(
          onSave: (newExpense) {
            if (widget.onAdd != null) {
              widget.onAdd!(newExpense);
            } else {
              setState(() {
                _localExpenses.insert(0, newExpense);
              });
            }
          },
        ),
      ),
    );
  }

  void _editExpense(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseFormScreen(
          initialExpense: _expenses[index],
          onSave: (updatedExpense) {
            if (widget.onEdit != null) {
              widget.onEdit!(index, updatedExpense);
            } else {
              setState(() {
                _localExpenses[index] = updatedExpense;
              });
            }
          },
        ),
      ),
    );
  }

  void _deleteExpense(int index) {
    final deletedItem = _expenses[index];
    if (widget.onDelete != null) {
      widget.onDelete!(index);
    } else {
      setState(() {
        _localExpenses.removeAt(index);
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${deletedItem.title}"'),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            if (widget.onAdd != null) {
              widget.onAdd!(deletedItem);
            } else {
              setState(() {
                _localExpenses.insert(index, deletedItem);
              });
            }
          },
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Di chuyển':
        return Icons.directions_car;
      case 'Mua sắm':
        return Icons.shopping_cart;
      case 'Học tập':
      case 'Giáo dục':
        return Icons.school;
      case 'Thu nhập':
        return Icons.attach_money;
      default:
        return Icons.attach_money;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Ăn uống':
        return const Color(0xFFFF6D00);
      case 'Di chuyển':
        return const Color(0xFF2196F3);
      case 'Mua sắm':
        return const Color(0xFF9C27B0);
      case 'Học tập':
      case 'Giáo dục':
        return const Color(0xFF009688);
      case 'Thu nhập':
        return const Color(0xFF2EAD4B);
      default:
        return const Color(0xFF2EAD4B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Danh sách khoản chi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: _expenses.isEmpty
          ? const Center(
              child: Text(
                'Chưa có khoản chi nào.\nNhấn nút + để thêm mới.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _expenses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFF1F5F9)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: _getCategoryColor(expense.category)
                          .withValues(alpha: 0.15),
                      child: Icon(
                        _getCategoryIcon(expense.category),
                        color: _getCategoryColor(expense.category),
                      ),
                    ),
                    title: Text(
                      expense.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    subtitle: Text(
                      '${expense.category} • ${_formatDate(expense.date)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${expense.isExpense ? '-' : '+'}${_formatCurrency(expense.amount)} đ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: expense.isExpense
                                ? const Color(0xFFE53935)
                                : const Color(0xFF2EAD4B),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: Color(0xFF1769E0),
                          ),
                          onPressed: () => _editExpense(index),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Color(0xFFE53935),
                          ),
                          onPressed: () => _deleteExpense(index),
                        ),
                      ],
                    ),
                    onTap: () => _editExpense(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'list_fab',
        backgroundColor: const Color(0xFF1769E0),
        foregroundColor: Colors.white,
        onPressed: _addExpense,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
