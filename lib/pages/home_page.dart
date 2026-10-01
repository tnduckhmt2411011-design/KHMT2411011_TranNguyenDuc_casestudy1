import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../widgets/header.dart';
import '../widgets/balance_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_list.dart';
import 'expense_form_screen.dart';
import 'expense_list_page.dart';

class HomePage extends StatefulWidget {
  final TransactionRepository? repository;
  final List<Transaction>? initialTransactions;

  const HomePage({
    super.key,
    this.repository,
    this.initialTransactions,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  late final TransactionRepository _repository;
  List<Transaction> _allTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? TransactionRepository();
    if (widget.initialTransactions != null) {
      _allTransactions = List.from(widget.initialTransactions!);
      _isLoading = false;
    } else {
      _loadTransactions();
    }
  }

  // Nạp toàn bộ danh sách giao dịch từ SQLite qua Repository
  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _repository.getAllTransactions();
      if (mounted) {
        setState(() {
          _allTransactions = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Tính tổng thu bằng fold trên toàn bộ giao dịch type == 'income'
  double get _totalIncome {
    return _allTransactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Tính tổng chi bằng fold trên toàn bộ giao dịch type == 'expense'
  double get _totalExpense {
    return _allTransactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Số dư = Tổng thu - Tổng chi
  double get _balance {
    return _totalIncome - _totalExpense;
  }

  // 5 giao dịch gần đây nhất để hiển thị trên Dashboard
  List<TransactionData> get _recentTransactionDataList {
    final recentList = _allTransactions.take(5).toList();

    return recentList.map((t) {
      IconData icon;
      Color color;

      switch (t.category) {
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
          icon = t.type == 'expense' ? Icons.payment : Icons.attach_money;
          color = t.type == 'expense'
              ? const Color(0xFFE53935)
              : const Color(0xFF2EAD4B);
      }

      final sign = t.type == 'expense' ? '-' : '+';
      final formattedAmount =
          '$sign${t.amount.toStringAsFixed(0).replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]}.',
              )} đ';

      // Chuyển ngày từ ISO yyyy-MM-dd sang dd/MM/yyyy
      String formattedDate = t.date;
      final parts = t.date.split('-');
      if (parts.length == 3) {
        formattedDate = '${parts[2]}/${parts[1]}/${parts[0]}';
      }

      return TransactionData(
        id: t.id,
        title: t.title,
        category: t.category,
        date: formattedDate,
        amount: formattedAmount,
        icon: icon,
        color: color,
        rawTransaction: t,
      );
    }).toList();
  }

  // Mở màn hình Thêm giao dịch và nạp lại khi nhận true
  Future<void> _openAddExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseFormScreen(
          repository: _repository,
        ),
      ),
    );

    if (result == true) {
      await _loadTransactions();
    }
  }

  // Mở màn hình Sửa giao dịch khi chạm vào một giao dịch
  Future<void> _openEditTransaction(TransactionData data) async {
    if (data.rawTransaction == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseFormScreen(
          initialTransaction: data.rawTransaction,
          repository: _repository,
        ),
      ),
    );

    if (result == true) {
      await _loadTransactions();
    }
  }

  // Xóa giao dịch bằng vuốt (Dismissible P2)
  Future<void> _deleteRecentTransaction(TransactionData data) async {
    if (data.id == null) return;

    await _repository.deleteTransaction(data.id!);
    await _loadTransactions();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa giao dịch: ${data.title}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeContent(
        balance: _balance,
        income: _totalIncome,
        expense: _totalExpense,
        transactions: _recentTransactionDataList,
        isLoading: _isLoading,
        onTapItem: _openEditTransaction,
        onDismissItem: _deleteRecentTransaction,
        onSeeAll: () {
          setState(() {
            currentIndex = 1;
          });
        },
      ),
      ExpenseListPage(
        externalExpenses: _allTransactions.map((t) {
          return Expense(
            id: t.id?.toString() ?? '',
            title: t.title,
            amount: t.amount,
            category: t.category,
            date: DateTime.tryParse(t.date) ?? DateTime.now(),
            isExpense: t.type == 'expense',
          );
        }).toList(),
        onAdd: (newExpense) async {
          final t = Transaction(
            id: DateTime.now().millisecondsSinceEpoch,
            title: newExpense.title,
            amount: newExpense.amount,
            type: newExpense.isExpense ? 'expense' : 'income',
            date:
                '${newExpense.date.year}-${newExpense.date.month.toString().padLeft(2, '0')}-${newExpense.date.day.toString().padLeft(2, '0')}',
            category: newExpense.category,
          );
          setState(() {
            _allTransactions.insert(0, t);
          });
          try {
            await _repository.insertTransaction(t);
          } catch (_) {}
          await _loadTransactions();
        },
        onEdit: (index, updatedExpense) async {
          if (index < _allTransactions.length) {
            final old = _allTransactions[index];
            final t = old.copyWith(
              title: updatedExpense.title,
              amount: updatedExpense.amount,
              type: updatedExpense.isExpense ? 'expense' : 'income',
              date:
                  '${updatedExpense.date.year}-${updatedExpense.date.month.toString().padLeft(2, '0')}-${updatedExpense.date.day.toString().padLeft(2, '0')}',
              category: updatedExpense.category,
            );
            setState(() {
              _allTransactions[index] = t;
            });
            try {
              await _repository.updateTransaction(t);
            } catch (_) {}
            await _loadTransactions();
          }
        },
        onDelete: (index) async {
          if (index < _allTransactions.length) {
            final old = _allTransactions[index];
            setState(() {
              _allTransactions.removeAt(index);
            });
            try {
              if (old.id != null) {
                await _repository.deleteTransaction(old.id!);
              }
            } catch (_) {}
            await _loadTransactions();
          }
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
            heroTag: 'home_fab',
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
  final bool isLoading;
  final Function(TransactionData)? onTapItem;
  final Function(TransactionData)? onDismissItem;
  final VoidCallback? onSeeAll;

  const HomeContent({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
    required this.transactions,
    this.isLoading = false,
    this.onTapItem,
    this.onDismissItem,
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
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            TransactionList(
              transactions: transactions,
              onTapItem: onTapItem,
              onDismissItem: onDismissItem,
            ),
        ],
      ),
    );
  }
}
