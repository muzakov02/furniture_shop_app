class User {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImage;
  final DateTime? numberSince;
  final bool isActive;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.numberSince,
    this.isActive = true,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    DateTime? numberSince,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      numberSince: numberSince ?? this.numberSince,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'numberSince': numberSince,
      'isActive': isActive,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
      numberSince: json['numberSince'] != null
          ? DateTime.parse(json['numberSince'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
