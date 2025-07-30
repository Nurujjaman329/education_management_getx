import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/features/student_panel/transaction_history/controller/transaction_history_controller.dart';
import 'package:edex_365_getx/features/student_panel/transaction_history/model/transaction_history_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionHistoryView extends StatelessWidget {
  TransactionHistoryView({super.key});
  final TransactionHistoryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w500),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Recharge History"),
              _buildTransactionList(controller.rechargeHistory),

              const SizedBox(height: 20),
              _buildSectionTitle("Spent History"),
              _buildTransactionList(controller.spentHistory),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionHistoryResponseModel> list) {
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text("No transactions available", style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    return Column(
      children: list.map((tx) => _buildTransactionCard(tx)).toList(),
    );
  }

  Widget _buildTransactionCard(TransactionHistoryResponseModel tx) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: ListTile(
        leading: tx.photo != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(tx.photo!),
                radius: 24,
              )
            : const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.secondary,
                child: Icon(Icons.receipt_long, color: Colors.white),
              ),
        title: Text(
          tx.amount != null ? "৳ ${tx.amount!.toStringAsFixed(2)}" : "No amount",
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          tx.getDateby != null ? _formatDate(tx.getDateby!) : "No date",
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}

