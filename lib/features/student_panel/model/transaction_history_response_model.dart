class TransactionHistoryResponseModel {
  final String? photo;
  final double? amount;
  final DateTime? getDateby;

  TransactionHistoryResponseModel({
    this.photo,
    this.amount,
    this.getDateby,
  });

  factory TransactionHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponseModel(
      photo: json['photo'] as String?,
      amount: (json['amount'] != null) ? double.tryParse(json['amount'].toString()) : null,
      getDateby: json['getDateby'] != null
          ? DateTime.tryParse(json['getDateby'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
      'amount': amount,
      'getDateby': getDateby?.toIso8601String(),
    };
  }
}
