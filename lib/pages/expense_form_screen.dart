import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseFormScreen extends StatefulWidget {
  final Expense? initialExpense;
  final Function(Expense) onSave;

  const ExpenseFormScreen({
    super.key,
    this.initialExpense,
    required this.onSave,
  });

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  bool _isExpense = true;
  String _selectedCategory = 'Ăn uống';
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _categories = const [
    {
      'name': 'Ăn uống',
      'icon': Icons.restaurant,
      'color': Color(0xFFFF5C5C),
    },
    {
      'name': 'Di chuyển',
      'icon': Icons.directions_car,
      'color': Color(0xFF2196F3),
    },
    {
      'name': 'Mua sắm',
      'icon': Icons.shopping_cart,
      'color': Color(0xFF9C27B0),
    },
    {
      'name': 'Học tập',
      'icon': Icons.school,
      'color': Color(0xFF009688),
    },
    {
      'name': 'Khác',
      'icon': Icons.more_horiz,
      'color': Color(0xFF757575),
    },
  ];

  @override
  void initState() {
    super.initState();
    final expense = widget.initialExpense;
    if (expense != null) {
      _amountController = TextEditingController(
        text: expense.amount.toStringAsFixed(0),
      );
      _noteController = TextEditingController(text: expense.title);
      _selectedCategory = expense.category;
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

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cleanAmount =
        _amountController.text.replaceAll('.', '').replaceAll(',', '').trim();
    final amount = double.tryParse(cleanAmount) ?? 0.0;
    final title = _noteController.text.trim().isNotEmpty
        ? _noteController.text.trim()
        : _selectedCategory;

    final expense = Expense(
      id: widget.initialExpense?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      category: _selectedCategory,
      date: _selectedDate,
      isExpense: _isExpense,
    );

    widget.onSave(expense);
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialExpense != null;
    final screenTitle = isEditing ? 'Sửa giao dịch' : 'Thêm giao dịch';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          screenTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
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
                // Toggle Chi tiêu / Thu nhập
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
                          onTap: () {
                            setState(() {
                              _isExpense = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isExpense
                                  ? const Color(0xFFFF5C5C)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Chi tiêu',
                              style: TextStyle(
                                fontSize: 16,
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
                          onTap: () {
                            setState(() {
                              _isExpense = false;
                            });
                          },
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
                                fontSize: 16,
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
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
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
                  items: _categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat['name'] as String,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: (cat['color'] as Color).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              cat['icon'] as IconData,
                              size: 18,
                              color: cat['color'] as Color,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            cat['name'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1E293B),
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
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Nhập số tiền',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    suffixText: 'đ',
                    suffixStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
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
                    color: Color(0xFF1E293B),
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
                            color: Color(0xFF1E293B),
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
                    color: Color(0xFF1E293B),
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

                // Nút Lưu
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _saveExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1769E0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
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
