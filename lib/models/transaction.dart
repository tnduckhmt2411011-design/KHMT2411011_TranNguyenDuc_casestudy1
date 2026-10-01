import 'package:flutter/material.dart';

class Transaction {
  final int? id;
  final String title;
  final double amount;
  final String type; // 'income' hoac 'expense'
  final String date; // TEXT ISO yyyy-MM-dd
  final String category;

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'date': date,
      'category': category,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] as String,
      date: map['date'] as String,
      category: map['category'] as String,
    );
  }

  Transaction copyWith({
    int? id,
    String? title,
    double? amount,
    String? type,
    String? date,
    String? category,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, title: $title, amount: $amount, type: $type, date: $date, category: $category)';
  }
}

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
