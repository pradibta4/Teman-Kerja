class UserModel {
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? role;
  final double? balance;
  final String? $id;
  final String? $createdAt;
  final String? $updatedAt;

  const UserModel({
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.role,
    this.balance,
    this.$id,
    this.$createdAt,
    this.$updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        avatar: json['avatar'] as String?,
        role: json['role'] as String?,
        balance: (json['balance'] as num?)?.toDouble(),
        $id: json['\$id'] as String?,
        $createdAt: json['\$createdAt'] as String?,
        $updatedAt: json['\$updatedAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
        'role': role,
        'balance': balance,
        '\$id': $id,
        '\$createdAt': $createdAt,
        '\$updatedAt': $updatedAt,
      };

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? role,
    double? balance,
    String? $id,
    String? $createdAt,
    String? $updatedAt,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      balance: balance ?? this.balance,
      $id: $id ?? this.$id,
      $createdAt: $createdAt ?? this.$createdAt,
      $updatedAt: $updatedAt ?? this.$updatedAt,
    );
  }
}
