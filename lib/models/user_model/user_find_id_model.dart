class FindIdUser {
  final String? name;
  final String? email;

  FindIdUser({
    required this.name,
    required this.email});

  factory FindIdUser.fromJson(Map<String, dynamic>json){
    return FindIdUser(
        name: json['name'],
        email: json['email']
    );}

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
  };}