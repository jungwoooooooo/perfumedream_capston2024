class FindPasswordUser {
  final String? id;
  final String? name;
  final String? phone;

  FindPasswordUser({
    required this.id,
    required this.name,
    required this.phone});

  factory FindPasswordUser.fromJson(Map<String, dynamic>json){
    return FindPasswordUser(
        id: json['id'],
        name: json['name'],
        phone: json['phone']
    );}

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
  };}