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
  final theme = Theme.of(context);
  return Scaffold(
    backgroundColor: theme.scaffoldBackgroundColor,
    appBar: AppBar(
      toolbarHeight: 0,  // hides the toolbar (title area)
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: theme.colorScheme.primary,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
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

      return TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryList(controller.rechargeHistory, isRecharge: true, theme: theme),
          _buildHistoryList(controller.spentHistory, isRecharge: false, theme: theme),
        ],
      );
    }),
  );
}

Widget _buildHistoryList(List list, {required bool isRecharge, required ThemeData theme}) {
  if (list.isEmpty) {
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
            isRecharge 
                ? 'No recharge history found'
                : 'No spending history found',
            style: TextStyle(
              color: theme.disabledColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  return RefreshIndicator(
    onRefresh: () async => await controller.fetchBothHistories(widget.userId),
    color: theme.colorScheme.primary,
    child: ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        final item = list[index];
        final successColor = theme.colorScheme.secondary;
        final errorColor = theme.colorScheme.error;
        
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
                color: isRecharge 
                    ? successColor.withOpacity(0.1)
                    : errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRecharge ? Icons.add : Icons.remove,
                color: isRecharge ? successColor : errorColor,
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
                  ? DateFormat('dd MMM yyyy, hh:mm a').format(item.getDateby!)
                  : 'No date',
              style: theme.textTheme.bodySmall,
            ),
            trailing: Text(
              isRecharge ? 'Recharged' : 'Spent',
              style: TextStyle(
                color: isRecharge ? successColor : errorColor,
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
