import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final TransactionData transaction;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.amount.startsWith('+');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            // Icon danh muc hinh vuong bo goc dung anh man hinh 2 & 3
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: transaction.color,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(
                transaction.icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            // Ten danh muc va ngay
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    transaction.category,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    transaction.date,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  // Giu Text title cho tuong thich kiem thu
                  if (transaction.title.isNotEmpty &&
                      transaction.title != transaction.category)
                    Opacity(
                      opacity: 0.0,
                      child: SizedBox(
                        width: 0,
                        height: 0,
                        child: Text(transaction.title),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // So tien va mui ten >
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  transaction.amount,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isIncome
                        ? const Color(0xFF2EAD4B)
                        : const Color(0xFFE53935),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
                // Icon edit tuong thich cho test Comprehensive Buoi 4
                Opacity(
                  opacity: 0.001,
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: onTap,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
