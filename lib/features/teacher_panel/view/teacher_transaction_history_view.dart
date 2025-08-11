import 'package:edex_365_getx/features/teacher_panel/controller/teacher_transaction_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TeacherTransactionHistoryView extends StatefulWidget {
  final String userId;
  const TeacherTransactionHistoryView({super.key, required this.userId});

  @override
  State<TeacherTransactionHistoryView> createState() =>
      _TeacherTransactionHistoryViewState();
}

class _TeacherTransactionHistoryViewState
    extends State<TeacherTransactionHistoryView> {
  late final TeacherTransactionHistoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TeacherTransactionHistoryController>();
    controller.fetchTransactionHistory(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 16,
              ),
            ),
          );
        }

        if (controller.transactionList.isEmpty) {
          return _buildEmptyState(theme);
        }

        return RefreshIndicator(
          onRefresh: () async =>
              await controller.fetchTransactionHistory(widget.userId),
          color: theme.colorScheme.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.transactionList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final item = controller.transactionList[index];
              return Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.attach_money,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    "৳ ${item.amount?.toStringAsFixed(2) ?? '0.00'}",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    item.getDateby != null
                        ? DateFormat('dd MMM yyyy, hh:mm a')
                            .format(item.getDateby!)
                        : 'No date',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: theme.disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No transaction history found',
            style: TextStyle(
              color: theme.disabledColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
