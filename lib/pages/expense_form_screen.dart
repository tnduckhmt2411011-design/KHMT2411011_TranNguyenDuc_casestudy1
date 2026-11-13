import 'package:flutter/material.dart';
import '../constants/category_constants.dart';
import '../models/expense.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';

class ExpenseFormScreen extends StatefulWidget {
  final Transaction? initialTransaction;
  final Expense? initialExpense;
  final Function(Expense)? onSave;
  final TransactionRepository? repository;

  const ExpenseFormScreen({
    super.key,
    this.initialTransaction,
    this.initialExpense,
    this.onSave,
    this.repository,
  });

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  bool _isExpense = true;
  bool _isSaving = false;
  String _selectedCategory = 'Ăn uống';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialTransaction != null) {
      final t = widget.initialTransaction!;
      // Màn Sửa điền sẵn số tiền ở dạng số thô (ví dụ 100000), không điền chuỗi có dấu chấm
      _amountController = TextEditingController(
        text: t.amount.toStringAsFixed(0),
      );
      final mappedCategory = CategoryConstants.normalizeCategory(t.category);
      // Quyết định mặc định 3: Nếu title trùng tên danh mục thì ô Ghi chú để trống
      final initialNote = (t.title == t.category ||
              t.title == mappedCategory ||
              CategoryConstants.normalizeCategory(t.title) == mappedCategory)
          ? ''
          : t.title;
      _noteController = TextEditingController(text: initialNote);

      _selectedCategory = mappedCategory;
      _selectedDate = DateTime.tryParse(t.date) ?? DateTime.now();
      _isExpense = t.type == 'expense';
    } else if (widget.initialExpense != null) {
      final expense = widget.initialExpense!;
      _amountController = TextEditingController(
        text: expense.amount.toStringAsFixed(0),
      );
      final mappedCategory = CategoryConstants.normalizeCategory(expense.category);
      final initialNote = (expense.title == expense.category ||
              expense.title == mappedCategory ||
              CategoryConstants.normalizeCategory(expense.title) == mappedCategory)
          ? ''
          : expense.title;
      _noteController = TextEditingController(text: initialNote);

      _selectedCategory = mappedCategory;
      _selectedDate = expense.date;
      _isExpense = expense.isExpense;
    } else {
      _amountController = TextEditingController();
      _noteController = TextEditingController();
      _selectedCategory = 'Ăn uống';
      _selectedDate = DateTime.now();
      _isExpense = true;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Danh sach danh muc hien tai phu hop voi loai giao dich
  List<CategoryItem> get _availableCategories {
    final baseList = _isExpense
        ? CategoryConstants.expenseCategories
        : CategoryConstants.incomeCategories;

    // Dam bao danh muc dang chon luon ton tai trong dropdown de tranh loi assertion
    if (!baseList.any((c) => c.name == _selectedCategory)) {
      return [
        ...baseList,
        CategoryItem(
          name: _selectedCategory,
          icon: CategoryConstants.getIcon(_selectedCategory),
          color: CategoryConstants.getColor(_selectedCategory),
          type: _isExpense ? 'expense' : 'income',
        ),
      ];
    }
    return baseList;
  }

  void _switchType(bool isExpense) {
    if (_isExpense == isExpense) return;
    setState(() {
      _isExpense = isExpense;
      final targetList = _isExpense
          ? CategoryConstants.expenseCategories
          : CategoryConstants.incomeCategories;
      if (!targetList.any((c) => c.name == _selectedCategory)) {
        _selectedCategory = _isExpense ? 'Ăn uống' : 'Lương';
      }
    });
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E6BEB),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cleanAmount =
        _amountController.text.replaceAll('.', '').replaceAll(',', '').trim();
    final amount = double.tryParse(cleanAmount);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số tiền hợp lệ (> 0)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Quyet dinh mac dinh 3: title trong DB van la Ghi chu, rong thi dung ten danh muc
    final note = _noteController.text.trim();
    final title = note.isNotEmpty ? note : _selectedCategory;
    final type = _isExpense ? 'expense' : 'income';
    final isoDate =
        '${_selectedDate.year.toString().padLeft(4, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

    setState(() {
      _isSaving = true;
    });

    try {
      // 1. Tuong thich nguoc voi callback onSave (cho unit test Buoi 3/4)
      if (widget.onSave != null) {
        final expense = Expense(
          id: widget.initialExpense?.id ??
              widget.initialTransaction?.id?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          amount: amount,
          category: _selectedCategory,
          date: _selectedDate,
          isExpense: _isExpense,
        );
        widget.onSave!(expense);
      }

      // 2. Thao tac voi SQLite qua TransactionRepository (Buoi 6)
      try {
        final repo = widget.repository ?? TransactionRepository();
        if (widget.initialTransaction != null) {
          final updated = widget.initialTransaction!.copyWith(
            title: title,
            amount: amount,
            type: type,
            date: isoDate,
            category: _selectedCategory,
          );
          await repo.updateTransaction(updated);
        } else if (widget.onSave == null || widget.repository != null) {
          final newTransaction = Transaction(
            title: title,
            amount: amount,
            type: type,
            date: isoDate,
            category: _selectedCategory,
          );
          await repo.insertTransaction(newTransaction);
        }
      } catch (e) {
        debugPrint('Thông báo SQLite: $e');
      }

      if (mounted) {
        // Tra ve ket qua true de man hinh truoc nap lai du lieu
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing =
        widget.initialExpense != null || widget.initialTransaction != null;
    final screenTitle = isEditing ? 'Sửa giao dịch' : 'Thêm giao dịch';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          screenTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle Chi tiêu / Thu nhập theo đúng ảnh màn 4 & 5
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _switchType(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isExpense
                                  ? const Color(0xFFFF5252)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Chi tiêu',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _isExpense
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _switchType(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isExpense
                                  ? const Color(0xFF2EAD4B)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Thu nhập',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: !_isExpense
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Danh mục
                const Text(
                  'Danh mục',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  items: _availableCategories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat.name,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: cat.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              cat.icon,
                              size: 18,
                              color: cat.color,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            cat.name,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn danh mục';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Số tiền
                const Text(
                  'Số tiền',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Nhập số tiền',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Center(
                        widthFactor: 1.0,
                        child: Text(
                          'đ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập số tiền';
                    }
                    final cleanValue = value
                        .replaceAll('.', '')
                        .replaceAll(',', '')
                        .trim();
                    final amount = double.tryParse(cleanValue);
                    if (amount == null) {
                      return 'Số tiền phải là số hợp lệ';
                    }
                    if (amount <= 0) {
                      return 'Số tiền phải lớn hơn 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Ngày giao dịch
                const Text(
                  'Ngày giao dịch',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(_selectedDate),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Ghi chú
                const Text(
                  'Ghi chú',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Nhập ghi chú (tùy chọn)',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Nút Lưu xanh dương
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E6BEB),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF93C5FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Lưu',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
