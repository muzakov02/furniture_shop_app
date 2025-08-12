class PromoCode {
  final String code;
  final String discount;
  final String description;
  final DateTime validUntil;
  final bool isPercentage;
  final bool isUsed;

  PromoCode({
    required this.code,
    required this.discount,
    required this.description,
    required this.validUntil,
    required this.isPercentage,
    this.isUsed = false,
  });

  bool get isExpired => DateTime.now().isAfter(validUntil);

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount': discount,
      'description': description,
      'validUntil': validUntil,
      'isPercentage': isPercentage,
      'isUsed': isUsed,
    };
  }

  factory PromoCode.fromJson(Map<String, dynamic> json){
    return PromoCode(
      code: json['code'],
      discount: json['discount'],
      description: json['description'],
      validUntil: json['validUntil'],
      isPercentage: json['isPercentage'],
      isUsed: json['isUsed'] ?? false,
    );
  }

}