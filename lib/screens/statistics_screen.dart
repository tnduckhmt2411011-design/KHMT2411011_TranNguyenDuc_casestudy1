import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/category_constants.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';

class StatisticsScreen extends StatefulWidget {
  final TransactionRepository? repository;
  final List<Transaction>? initialTransactions;

  const StatisticsScreen({
    super.key,
    this.repository,
    this.initialTransactions,
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late final TransactionRepository _repository;
  List<Transaction> _allTransactions = [];
  bool _isLoading = true;

  // 3 ky thong ke: 'this_month', 'last_month', 'this_year'
  String _selectedPeriod = 'this_month';

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

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await _repository.getAllTransactions();
      if (mounted) {
        setState(() {
          _allTransactions = list;
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

  // Loc cac giao dich chi tieu trong ky duoc chon
  List<Transaction> get _periodExpenses {
    final now = DateTime.now();

    return _allTransactions.where((t) {
      if (t.type != 'expense') return false;

      final date = DateTime.tryParse(t.date);
      if (date == null) return false;

      switch (_selectedPeriod) {
        case 'this_month':
          return date.year == now.year && date.month == now.month;
        case 'last_month':
          final lastMonthDate = DateTime(now.year, now.month - 1);
          return date.year == lastMonthDate.year &&
              date.month == lastMonthDate.month;
        case 'this_year':
          return date.year == now.year;
        default:
          return true;
      }
    }).toList();
  }

  // Gom nhom chi tieu theo danh muc va tinh ty le phan tram
  List<_CategoryStat> get _categoryStats {
    final expenses = _periodExpenses;
    if (expenses.isEmpty) return [];

    final Map<String, double> categorySums = {};
    double total = 0.0;

    for (final t in expenses) {
      final normalized = CategoryConstants.normalizeCategory(t.category);
      categorySums[normalized] = (categorySums[normalized] ?? 0.0) + t.amount;
      total += t.amount;
    }

    if (total <= 0) return [];

    final stats = categorySums.entries.map((e) {
      final percent = (e.value / total * 100).round();
      return _CategoryStat(
        category: e.key,
        amount: e.value,
        percentage: percent,
        color: CategoryConstants.getColor(e.key),
      );
    }).toList();

    // Sap xep giam dan theo so tien giong anh mau
    stats.sort((a, b) => b.amount.compareTo(a.amount));
    return stats;
  }

  double get _totalExpense {
    return _periodExpenses.fold(0.0, (sum, t) => sum + t.amount);
  }

  @override
  Widget build(BuildContext context) {
    final stats = _categoryStats;
    final total = _totalExpense;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Thống kê',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  children: [
                    // 3 Chips: "Tháng này", "Tháng trước", "Năm nay"
                    Row(
                      children: [
                        Expanded(child: _buildPeriodChip('Tháng này', 'this_month')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildPeriodChip('Tháng trước', 'last_month')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildPeriodChip('Năm nay', 'this_year')),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Bieu do tron rong giua (Donut Chart) ve bang CustomPainter
                    SizedBox(
                      width: 230,
                      height: 230,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(230, 230),
                            painter: _DonutChartPainter(
                              stats: stats,
                              total: total,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                CategoryConstants.formatCurrency(total),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Tổng chi tiêu',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Chu giai tung danh muc (Legend) dung anh man 6
                    if (stats.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'Không có chi tiêu nào trong kỳ này',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: stats.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final stat = stats[index];
                          return Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: stat.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  stat.category,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              Text(
                                CategoryConstants.formatCurrency(stat.amount),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 14),
                              SizedBox(
                                width: 38,
                                child: Text(
                                  '${stat.percentage}%',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPeriodChip(String label, String value) {
    final isSelected = _selectedPeriod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E6BEB) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}

class _CategoryStat {
  final String category;
  final double amount;
  final int percentage;
  final Color color;

  _CategoryStat({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

// CustomPainter ve bieu do tron rong giua (Donut chart)
class _DonutChartPainter extends CustomPainter {
  final List<_CategoryStat> stats;
  final double total;

  _DonutChartPainter({
    required this.stats,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 32) / 2;
    const strokeWidth = 28.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Neu khong co du lieu: ve vong tron rong mau xam nhat
    if (total <= 0 || stats.isEmpty) {
      paint.color = const Color(0xFFE2E8F0);
      canvas.drawCircle(center, radius, paint);
      return;
    }

    // Bat dau tu dinh (-pi / 2)
    double startAngle = -pi / 2;

    for (final stat in stats) {
      final sweepAngle = (stat.amount / total) * 2 * pi;
      paint.color = stat.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.total != total || oldDelegate.stats != stats;
  }
}
