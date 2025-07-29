class BkashCreatePaymentResponseModel {
  final String userId;
  final int statusCode;
  final String statusMessage;
  final String paymentID;
  final String bkashURL;
  final String callbackURL;
  final String successCallbackURL;
  final String failureCallbackURL;
  final double amount;
  final String currency;
  final String paymentCreateTime;
  final String merchantInvoiceNumber;

  BkashCreatePaymentResponseModel({
    required this.userId,
    required this.statusCode,
    required this.statusMessage,
    required this.paymentID,
    required this.bkashURL,
    required this.callbackURL,
    required this.successCallbackURL,
    required this.failureCallbackURL,
    required this.amount,
    required this.currency,
    required this.paymentCreateTime,
    required this.merchantInvoiceNumber,
  });

  factory BkashCreatePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return BkashCreatePaymentResponseModel(
      userId: json['userId'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      statusMessage: json['statusMessage'] ?? '',
      paymentID: json['paymentID'] ?? '',
      bkashURL: json['bkashURL'] ?? '',
      callbackURL: json['callbackURL'] ?? '',
      successCallbackURL: json['successCallbackURL'] ?? '',
      failureCallbackURL: json['failureCallbackURL'] ?? '',
      amount: (json['amount'] is int) ? (json['amount'] as int).toDouble() : (json['amount'] ?? 0.0),
      currency: json['currency'] ?? '',
      paymentCreateTime: json['paymentCreateTime'] ?? '',
      merchantInvoiceNumber: json['merchantInvoiceNumber'] ?? '',
    );
  }
}
