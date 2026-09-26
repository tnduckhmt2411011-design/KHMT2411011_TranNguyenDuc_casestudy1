import 'package:flutter/material.dart';

class TransactionData {
  final String title;
  final String category;
  final String date;
  final String amount;
  final IconData icon;
  final Color color;

  const TransactionData({
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.icon,
    required this.color,
  });
}
