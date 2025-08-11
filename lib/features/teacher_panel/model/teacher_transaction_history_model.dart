class TeacherTransactionHistoryResponseModel {
  final String? photo;
  final double? amount;
  final DateTime? getDateby;

  TeacherTransactionHistoryResponseModel({
    this.photo,
    this.amount,
    this.getDateby,
  });

  factory TeacherTransactionHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherTransactionHistoryResponseModel(
      photo: json['photo'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      getDateby: json['getDateby'] != null ? DateTime.tryParse(json['getDateby']) : null,
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
