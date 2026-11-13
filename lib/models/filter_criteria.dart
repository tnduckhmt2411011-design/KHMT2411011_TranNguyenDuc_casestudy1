import 'package:flutter/material.dart';

class FilterCriteria {
  final bool isAllTypes;
  final bool isIncome;
  final bool isExpense;
  final String category; // 'Tất cả danh mục' hoặc tên danh mục cụ thể
  final String? timeRange; // 'Hôm nay', '7 ngày qua', 'Tháng này', 'Tùy chỉnh', hoặc null nếu bỏ chọn
  final DateTimeRange? customDateRange;

  const FilterCriteria({
    this.isAllTypes = true,
    this.isIncome = false,
    this.isExpense = false,
    this.category = 'Tất cả danh mục',
    this.timeRange = 'Hôm nay',
    this.customDateRange,
  });

  FilterCriteria copyWith({
    bool? isAllTypes,
    bool? isIncome,
    bool? isExpense,
    String? category,
    String? timeRange,
    bool clearTimeRange = false,
    DateTimeRange? customDateRange,
  }) {
    return FilterCriteria(
      isAllTypes: isAllTypes ?? this.isAllTypes,
      isIncome: isIncome ?? this.isIncome,
      isExpense: isExpense ?? this.isExpense,
      category: category ?? this.category,
      timeRange: clearTimeRange ? null : (timeRange ?? this.timeRange),
      customDateRange: customDateRange ?? this.customDateRange,
    );
  }
}
