import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:edex_365_getx/features/student_panel/controller/transaction_history_controller.dart';

class TransactionHistoryView extends StatefulWidget {
  final String userId;
  const TransactionHistoryView({super.key, required this.userId});

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView> 
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final TransactionHistoryController controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller = Get.find<TransactionHistoryController>();
    controller.fetchBothHistories(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Recharge'),
            Tab(text: 'Spent'),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 16,
              ),
            ),
          );
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildHistoryList(controller.rechargeHistory, isRecharge: true),
            _buildHistoryList(controller.spentHistory, isRecharge: false),
          ],
        );
      }),
    );
  }

  Widget _buildHistoryList(List list, {required bool isRecharge}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              isRecharge 
                  ? 'No recharge history found'
                  : 'No spending history found',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => await controller.fetchBothHistories(widget.userId),
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, index) {
          final item = list[index];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
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
                  color: isRecharge 
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isRecharge ? Icons.add : Icons.remove,
                  color: isRecharge ? AppColors.success : AppColors.error,
                ),
              ),
              title: Text(
                "৳ ${item.amount?.toStringAsFixed(2) ?? '0.00'}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                item.getDateby != null
                    ? DateFormat('dd MMM yyyy, hh:mm a').format(item.getDateby!)
                    : 'No date',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              trailing: Text(
                isRecharge ? 'Recharged' : 'Spent',
                style: TextStyle(
                  color: isRecharge ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
