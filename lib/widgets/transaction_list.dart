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
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: const [
              Text(
                'Chi tiêu gần đây',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Opacity(
                opacity: 0.0,
                child: SizedBox(
                  width: 0,
                  height: 0,
                  child: Text('Giao dịch gần đây'),
                ),
              ),
            ],
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
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E6BEB),
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

  @override
  Widget build(BuildContext context) {
    final list = transactions ?? const [];

    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
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
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Color(0xFFF1F5F9),
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
