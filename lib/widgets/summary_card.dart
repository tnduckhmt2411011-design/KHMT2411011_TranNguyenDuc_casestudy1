import 'package:flutter/material.dart';

class SummarySection extends StatelessWidget {
  final double income;
  final double expense;

  const SummarySection({
    super.key,
    this.income = 8000000.0,
    this.expense = 3000000.0,
  });

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: 'TỔNG THU NHẬP',
            amount: '${_formatCurrency(income)} đ',
            icon: Icons.arrow_downward,
            iconColor: const Color(0xFF2EAD4B),
            backgroundColor: const Color(0xFFEAF8EB),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SummaryCard(
            title: 'TỔNG CHI TIÊU',
            amount: '${_formatCurrency(expense)} đ',
            icon: Icons.arrow_upward,
            iconColor: const Color(0xFFE53935),
            backgroundColor: const Color(0xFFFFEFF0),
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor.withValues(alpha: 0.18),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4B5563),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
