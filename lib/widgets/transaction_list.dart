import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionHeader extends StatelessWidget {
  final VoidCallback? onSeeAll;

  const TransactionHeader({
    super.key,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Text(
            'Giao dịch gần đây',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Xem tất cả',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1769E0),
            ),
          ),
        ),
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  final List<TransactionData>? transactions;
  final Function(TransactionData)? onTapItem;
  final Function(TransactionData)? onDismissItem;

  const TransactionList({
    super.key,
    this.transactions,
    this.onTapItem,
    this.onDismissItem,
  });

  static const List<TransactionData> defaultTransactions = [
    TransactionData(
      title: 'Ăn trưa',
      category: 'Ăn uống',
      date: '03/09/2024',
      amount: '-50.000 đ',
      icon: Icons.restaurant,
      color: Color(0xFFFF6D00),
    ),
    TransactionData(
      title: 'Xăng xe',
      category: 'Di chuyển',
      date: '03/09/2024',
      amount: '-100.000 đ',
      icon: Icons.directions_car,
      color: Color(0xFF2196F3),
    ),
    TransactionData(
      title: 'Lương tháng 9',
      category: 'Thu nhập',
      date: '01/09/2024',
      amount: '+8.000.000 đ',
      icon: Icons.attach_money,
      color: Color(0xFF2EAD4B),
    ),
    TransactionData(
      title: 'Mua sắm',
      category: 'Mua sắm',
      date: '31/08/2024',
      amount: '-300.000 đ',
      icon: Icons.shopping_cart,
      color: Color(0xFF9C27B0),
    ),
    TransactionData(
      title: 'Học phí',
      category: 'Giáo dục',
      date: '30/08/2024',
      amount: '-500.000 đ',
      icon: Icons.school,
      color: Color(0xFF009688),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final list = transactions ?? defaultTransactions;

    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Chưa có giao dịch nào',
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 15,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
            color: Color(0xFFE5E7EB),
          );
        },
        itemBuilder: (context, index) {
          final item = list[index];
          final itemWidget = TransactionItem(
            transaction: item,
            onTap: onTapItem != null ? () => onTapItem!(item) : null,
          );

          if (onDismissItem != null && item.id != null) {
            return Dismissible(
              key: Key('trans_${item.id}_$index'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              onDismissed: (direction) => onDismissItem!(item),
              child: itemWidget,
            );
          }

          return itemWidget;
        },
      ),
    );
  }
}
