class PaymentMethod {
  final String id;
  final String cardType;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final bool isDefault;
  final String cardColor;


  PaymentMethod({
    required this.id,
    required this.cardType,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    this.isDefault = false,
    required this.cardColor,
  });

  PaymentMethod copyWith({
    String? id,
    String? cardType,
    String? cardNumber,
    String? expiryDate,
    String? cardHolderName,
    bool? isDefault,
    String? cardColor,
  }) {
    return PaymentMethod(
        id: id ?? this.id,
        cardType: cardType ?? this.cardType,
        cardNumber: cardNumber ?? this.cardNumber,
        expiryDate: expiryDate ?? this.expiryDate,
        cardHolderName: cardHolderName ?? this.cardHolderName,
      isDefault: isDefault ?? this.isDefault,
      cardColor: cardColor ?? this.cardColor,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'cardType': cardType,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardHolderName': cardHolderName,
      'isDefault': isDefault,
      'cardColor': cardColor,
    };
  }
  factory PaymentMethod.fromJson(Map<String, dynamic> json){
    return PaymentMethod(
        id: json['id'],
        cardType: json['cardType'],
        cardNumber: json['cardNumber'],
        expiryDate: json['expiryDate'],
        cardHolderName: json['cardHolderName'],
      isDefault: json['isDefault'] ?? false,
        cardColor: json['cardColor'],
    );
  }

}