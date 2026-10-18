import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/category_constants.dart';
import '../models/filter_criteria.dart';
import '../models/transaction.dart';
import '../pages/expense_form_screen.dart';
import '../repositories/transaction_repository.dart';
import '../widgets/transaction_item.dart';
import 'filter_screen.dart';

class TransactionListScreen extends StatefulWidget {
  final TransactionRepository? repository;
  final List<Transaction>? initialTransactions;
  final Function(Transaction)? onTransactionUpdated;
  final VoidCallback? onDataChanged;

  const TransactionListScreen({
    super.key,
    this.repository,
    this.initialTransactions,
    this.onTransactionUpdated,
    this.onDataChanged,
  });

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  late final TransactionRepository _repository;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  List<Transaction> _allTransactions = [];
  List<Transaction> _filteredTransactions = [];
  bool _isLoading = true;

  // Chip dang chon: 'all', 'income', 'expense'
  String _selectedTypeChip = 'all';

  // Bo loc nang cao tu man hinh 8 (chi ap dung sau khi nguoi dung bam Ap dung theo quyet dinh mac dinh 7)
  FilterCriteria? _filterCriteria;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? TransactionRepository();
    if (widget.initialTransactions != null) {
      _allTransactions = List.from(widget.initialTransactions!);
      _applyFilter();
      _isLoading = false;
    } else {
      _loadTransactions();
    }
  }

  @override
  void didUpdateWidget(covariant TransactionListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTransactions != null) {
      _allTransactions = List.from(widget.initialTransactions!);
      _applyFilter();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await _repository.getAllTransactions();
      if (mounted) {
        setState(() {
          _allTransactions = list;
          _applyFilter();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Xu ly debounce khi go tim kiem (khoang 400ms theo tai lieu buoi 6)
  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _applyFilter();
        });
      }
    });
  }

  // Ap dung dong thoi tim kiem, chip loai giao dich va tieu chi bo loc man 8
  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();

    _filteredTransactions = _allTransactions.where((t) {
      // 1. Loc theo tu khoa tim kiem (khop voi tieu de/ghi chu hoac danh muc)
      if (query.isNotEmpty) {
        final titleMatch = t.title.toLowerCase().contains(query);
        final categoryMatch = t.category.toLowerCase().contains(query);
        if (!titleMatch && !categoryMatch) return false;
      }

      // 2. Loc theo 3 chip: Tat ca / Thu nhap / Chi tieu
      if (_selectedTypeChip == 'income' && t.type != 'income') return false;
      if (_selectedTypeChip == 'expense' && t.type != 'expense') return false;

      // 3. Loc theo FilterCriteria (man hinh 8 - chi loc khi nguoi dung da bam Ap dung)
      if (_filterCriteria != null) {
        final fc = _filterCriteria!;
        // a) Loai giao dich
        if (!fc.isAllTypes) {
          if (fc.isIncome && !fc.isExpense) {
            if (t.type != 'income') return false;
          } else if (fc.isExpense && !fc.isIncome) {
            if (t.type != 'expense') return false;
          }
        }

        // b) Danh muc
        if (fc.category != 'Tất cả danh mục') {
          final normalizedItem = CategoryConstants.normalizeCategory(t.category);
          final normalizedFilter = CategoryConstants.normalizeCategory(fc.category);
          if (normalizedItem != normalizedFilter) return false;
        }

        // c) Khoang thoi gian
        if (fc.timeRange != null) {
          final itemDate = DateTime.tryParse(t.date);
          if (itemDate != null) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final itemDay = DateTime(itemDate.year, itemDate.month, itemDate.day);

            switch (fc.timeRange) {
              case 'Hôm nay':
                if (itemDay != today) return false;
                break;
              case '7 ngày qua':
                final sevenDaysAgo = today.subtract(const Duration(days: 7));
                if (itemDay.isBefore(sevenDaysAgo) || itemDay.isAfter(today)) {
                  return false;
                }
                break;
              case 'Tháng này':
                if (itemDate.year != now.year || itemDate.month != now.month) {
                  return false;
                }
                break;
              case 'Tùy chỉnh':
                if (fc.customDateRange != null) {
                  final start = DateTime(
                    fc.customDateRange!.start.year,
                    fc.customDateRange!.start.month,
                    fc.customDateRange!.start.day,
                  );
                  final end = DateTime(
                    fc.customDateRange!.end.year,
                    fc.customDateRange!.end.month,
                    fc.customDateRange!.end.day,
                  );
                  if (itemDay.isBefore(start) || itemDay.isAfter(end)) {
                    return false;
                  }
                }
                break;
            }
          }
        }
      }

      return true;
    }).toList();
  }

  // Mo man hinh Bo loc (Screen 8)
  Future<void> _openFilterScreen() async {
    final result = await Navigator.push<FilterCriteria>(
      context,
      MaterialPageRoute(
        builder: (context) => FilterScreen(
          initialCriteria: _filterCriteria ?? const FilterCriteria(),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _filterCriteria = result;
        _applyFilter();
      });
    }
  }

  // Mo man hinh Sua giao dich
  Future<void> _openEditScreen(Transaction t) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseFormScreen(
          initialTransaction: t,
          repository: _repository,
          onSave: (savedExpense) {
            final updated = t.copyWith(
              title: savedExpense.title,
              amount: savedExpense.amount,
              type: savedExpense.isExpense ? 'expense' : 'income',
              category: savedExpense.category,
            );
            if (widget.onTransactionUpdated != null) {
              widget.onTransactionUpdated!(updated);
            }
          },
        ),
      ),
    );

    if (result == true) {
      await _loadTransactions();
      if (widget.onDataChanged != null) {
        widget.onDataChanged!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: const [
            Text(
              'Giao dịch',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Opacity(
              opacity: 0.001,
              child: SizedBox(
                width: 1,
                height: 1,
                child: Text('Danh sách khoản chi'),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Thanh tim kiem va nut bo loc dung anh man hinh 3
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm giao dịch...',
                          hintStyle: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF94A3B8),
                            size: 22,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _openFilterScreen,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Color(0xFF64748B),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3 Filter Chips: "Tất cả", "Thu nhập", "Chi tiêu" - Expanded de khong overflow tren man hinh hep
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: _buildTypeChip('Tất cả', 'all')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTypeChip('Thu nhập', 'income')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTypeChip('Chi tiêu', 'expense')),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Danh sach giao dich
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredTransactions.isEmpty
                      ? const Center(
                          child: Text(
                            'Chưa có giao dịch nào',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          itemCount: _filteredTransactions.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 1,
                            color: Color(0xFFF1F5F9),
                          ),
                          itemBuilder: (context, index) {
                            final t = _filteredTransactions[index];
                            final sign = t.type == 'expense' ? '-' : '+';
                            final formattedAmount =
                                '$sign${CategoryConstants.formatCurrency(t.amount)}';
                            final formattedDate =
                                CategoryConstants.formatDate(t.date);

                            final data = TransactionData(
                              id: t.id,
                              title: t.title,
                              category: CategoryConstants.normalizeCategory(
                                  t.category),
                              date: formattedDate,
                              amount: formattedAmount,
                              icon: CategoryConstants.getIcon(t.category),
                              color: CategoryConstants.getColor(t.category),
                              rawTransaction: t,
                            );

                            return TransactionItem(
                              transaction: data,
                              onTap: () => _openEditScreen(t),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, String value) {
    final isSelected = _selectedTypeChip == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTypeChip = value;
          _applyFilter();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E6BEB) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
