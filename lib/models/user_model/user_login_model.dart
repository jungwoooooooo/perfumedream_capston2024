class User {
  final String? id;
  final String? password;

  User({
    required this.id,
    required this.password});

  factory User.fromJson(Map<String, dynamic>json){
    return User(
        id: json['memberId'],
        password: json['password']
    );}

  Map<String, dynamic> toJson() => {
    'id': id,
    'password': password,
  };}