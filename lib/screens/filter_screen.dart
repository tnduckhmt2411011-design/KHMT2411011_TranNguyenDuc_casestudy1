import 'package:flutter/material.dart';
import '../models/filter_criteria.dart';

class FilterScreen extends StatefulWidget {
  final FilterCriteria? initialCriteria;

  const FilterScreen({
    super.key,
    this.initialCriteria,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late bool _isAllTypes;
  late bool _isIncome;
  late bool _isExpense;

  late String _selectedCategory;
  String? _selectedTimeRange;
  DateTimeRange? _customDateRange;

  final List<String> _categories = const [
    'Tất cả danh mục',
    'Ăn uống',
    'Mua sắm',
    'Đi lại',
    'Học tập',
    'Lương',
    'Khác',
  ];

  final List<String> _timeRanges = const [
    'Hôm nay',
    '7 ngày qua',
    'Tháng này',
    'Tùy chỉnh',
  ];

  @override
  void initState() {
    super.initState();
    final criteria = widget.initialCriteria ?? const FilterCriteria();
    _isAllTypes = criteria.isAllTypes;
    _isIncome = criteria.isIncome;
    _isExpense = criteria.isExpense;
    _selectedCategory = criteria.category;
    _selectedTimeRange = criteria.timeRange;
    _customDateRange = criteria.customDateRange;
  }

  Future<void> _pickCustomDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: _customDateRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          ),
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

    if (picked != null) {
      setState(() {
        _customDateRange = picked;
        _selectedTimeRange = 'Tùy chỉnh';
      });
    }
  }

  void _onApply() {
    final result = FilterCriteria(
      isAllTypes: _isAllTypes,
      isIncome: _isIncome,
      isExpense: _isExpense,
      category: _selectedCategory,
      timeRange: _selectedTimeRange,
      customDateRange: _customDateRange,
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: const Text(
          'Bộ lọc',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Loại giao dịch
                    const Text(
                      'Loại giao dịch',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCheckboxTile(
                      title: 'Tất cả',
                      value: _isAllTypes,
                      onChanged: (val) {
                        setState(() {
                          _isAllTypes = true;
                          _isIncome = false;
                          _isExpense = false;
                        });
                      },
                    ),
                    _buildCheckboxTile(
                      title: 'Thu nhập',
                      value: _isIncome,
                      onChanged: (val) {
                        setState(() {
                          _isIncome = val ?? false;
                          if (_isIncome && _isExpense) {
                            _isAllTypes = true;
                            _isIncome = false;
                            _isExpense = false;
                          } else if (!_isIncome && !_isExpense) {
                            _isAllTypes = true;
                          } else {
                            _isAllTypes = false;
                          }
                        });
                      },
                    ),
                    _buildCheckboxTile(
                      title: 'Chi tiêu',
                      value: _isExpense,
                      onChanged: (val) {
                        setState(() {
                          _isExpense = val ?? false;
                          if (_isIncome && _isExpense) {
                            _isAllTypes = true;
                            _isIncome = false;
                            _isExpense = false;
                          } else if (!_isIncome && !_isExpense) {
                            _isAllTypes = true;
                          } else {
                            _isAllTypes = false;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // 2. Danh mục
                    const Text(
                      'Danh mục',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: _categories.contains(_selectedCategory)
                          ? _selectedCategory
                          : 'Tất cả danh mục',
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
                      items: _categories.map((c) {
                        return DropdownMenuItem<String>(
                          value: c,
                          child: Text(
                            c,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedCategory = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 28),

                    // 3. Khoảng thời gian
                    const Text(
                      'Khoảng thời gian',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._timeRanges.map((range) {
                      final isSelected = _selectedTimeRange == range;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            // Theo Quyet dinh mac dinh 7: cho phep cham lai de bo chon
                            if (isSelected) {
                              _selectedTimeRange = null;
                            } else {
                              _selectedTimeRange = range;
                              if (range == 'Tùy chỉnh') {
                                _pickCustomDateRange();
                              }
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF1E6BEB)
                                        : const Color(0xFFCBD5E1),
                                    width: isSelected ? 6 : 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                range == 'Tùy chỉnh' && _customDateRange != null
                                    ? 'Tùy chỉnh (${_customDateRange!.start.day}/${_customDateRange!.start.month} - ${_customDateRange!.end.day}/${_customDateRange!.end.month})'
                                    : range,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Nút Áp dụng ở đáy màn hình
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6BEB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Áp dụng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value ? const Color(0xFF1E6BEB) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value ? const Color(0xFF1E6BEB) : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
