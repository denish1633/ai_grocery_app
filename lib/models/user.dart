class User {
  final int id;
  final String email;
  final String? token; // make nullable

  User({required this.id, required this.email, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      token: json['token'], // may be null
    );
  }
}
