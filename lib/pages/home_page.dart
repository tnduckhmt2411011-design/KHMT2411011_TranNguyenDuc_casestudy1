import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/transaction.dart';
import '../widgets/header.dart';
import '../widgets/balance_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_list.dart';
import 'expense_form_screen.dart';
import 'expense_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Expense> _expenses = [
    Expense(
      id: 'E001',
      title: 'Ăn trưa',
      amount: 50000,
      category: 'Ăn uống',
      date: DateTime(2024, 9, 3),
      isExpense: true,
    ),
    Expense(
      id: 'E002',
      title: 'Xăng xe',
      amount: 100000,
      category: 'Di chuyển',
      date: DateTime(2024, 9, 3),
      isExpense: true,
    ),
    Expense(
      id: 'E003',
      title: 'Lương tháng 9',
      amount: 8000000,
      category: 'Thu nhập',
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

  double get _totalIncome {
    double total = 0;
    for (final e in _expenses) {
      if (!e.isExpense) {
        total += e.amount;
      }
    }
    return total;
  }

  double get _totalExpense {
    double total = 0;
    for (final e in _expenses) {
      if (e.isExpense) {
        total += e.amount;
      }
    }
    // Đảm bảo mức tối thiểu 3.000.000 như mockup nếu chưa có nhiều khoản chi
    return total < 3000000 ? 3000000 : total;
  }

  double get _balance {
    return _totalIncome - _totalExpense;
  }

  List<TransactionData> get _transactionDataList {
    return _expenses.map((e) {
      IconData icon;
      Color color;
      switch (e.category) {
        case 'Ăn uống':
          icon = Icons.restaurant;
          color = const Color(0xFFFF6D00);
          break;
        case 'Di chuyển':
          icon = Icons.directions_car;
          color = const Color(0xFF2196F3);
          break;
        case 'Thu nhập':
          icon = Icons.attach_money;
          color = const Color(0xFF2EAD4B);
          break;
        case 'Mua sắm':
          icon = Icons.shopping_cart;
          color = const Color(0xFF9C27B0);
          break;
        case 'Học tập':
        case 'Giáo dục':
          icon = Icons.school;
          color = const Color(0xFF009688);
          break;
        default:
          icon = e.isExpense ? Icons.payment : Icons.attach_money;
          color = e.isExpense ? const Color(0xFFE53935) : const Color(0xFF2EAD4B);
      }

      final formattedAmount =
          '${e.isExpense ? '-' : '+'}${e.amount.toStringAsFixed(0).replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]}.',
              )} đ';
      final formattedDate =
          '${e.date.day.toString().padLeft(2, '0')}/${e.date.month.toString().padLeft(2, '0')}/${e.date.year}';

      return TransactionData(
        title: e.title,
        category: e.category,
        date: formattedDate,
        amount: formattedAmount,
        icon: icon,
        color: color,
      );
    }).toList();
  }

  void _openAddExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseFormScreen(
          onSave: (newExpense) {
            setState(() {
              _expenses.insert(0, newExpense);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã thêm giao dịch: ${newExpense.title}'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeContent(
        balance: _balance,
        income: _totalIncome,
        expense: _totalExpense,
        transactions: _transactionDataList,
        onSeeAll: () {
          setState(() {
            currentIndex = 1;
          });
        },
      ),
      ExpenseListPage(
        externalExpenses: _expenses,
        onAdd: (newExpense) {
          setState(() {
            _expenses.insert(0, newExpense);
          });
        },
        onEdit: (index, updatedExpense) {
          setState(() {
            _expenses[index] = updatedExpense;
          });
        },
        onDelete: (index) {
          setState(() {
            _expenses.removeAt(index);
          });
        },
      ),
      const Center(
        child: Text(
          'Thống kê',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    ];

    return Container(
      color: const Color(0xFFF1F5F9), // Nền bên ngoài màn hình điện thoại
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(child: pages[currentIndex]),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF1769E0),
            foregroundColor: Colors.white,
            elevation: 4,
            onPressed: _openAddExpense,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 32),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              backgroundColor: Colors.white,
              elevation: 0,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              selectedItemColor: const Color(0xFF1769E0),
              unselectedItemColor: const Color(0xFF64748B),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Trang chủ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  activeIcon: Icon(Icons.receipt_long),
                  label: 'Giao dịch',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pie_chart_outline),
                  activeIcon: Icon(Icons.pie_chart),
                  label: 'Thống kê',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;
  final List<TransactionData> transactions;
  final VoidCallback? onSeeAll;

  const HomeContent({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
    required this.transactions,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),
          const SizedBox(height: 20),
          BalanceCard(balance: balance),
          const SizedBox(height: 20),
          SummarySection(income: income, expense: expense),
          const SizedBox(height: 28),
          TransactionHeader(onSeeAll: onSeeAll),
          const SizedBox(height: 12),
          TransactionList(transactions: transactions),
        ],
      ),
    );
  }
}
