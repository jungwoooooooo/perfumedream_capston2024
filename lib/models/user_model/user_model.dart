class Member {
  final String? id;
  final String? password;
  final String? verifyPassword;
  final String? name;
  final String? email;
  final String? phone;

  final String? age;
  final String? detailAddr;
  final String? jibunAddr;
  final String? roadAddr;
  final String? zipcode;


  Member({
    required this.id,
    required this.password,
    required this.verifyPassword,
    required this.name,
    required this.email,
    required this.phone,

    required this.age,
    required this.detailAddr,
    required this.jibunAddr,
    required this.roadAddr,
    required this.zipcode
  });

  factory Member.fromJson(Map<String, dynamic>json){
    return Member(
        id: json['memberId'],
        password: json['password'],
        verifyPassword: json['verifyPassword'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],

        age : json['age'],
        detailAddr: json['detailAddr'],
        jibunAddr : json['jibunAddr'],
        roadAddr: json['roadAddr'],
        zipcode : json['zipcode'],


    );}

  Map<String, dynamic> toJson() => {
    'id': id,
    'password': password,
    //'age': age,
    'verifyPassword': verifyPassword,
    'name': name,
    'email': email,
    'phone': phone,

    'age':age,
    'detailAddr':detailAddr,
    'jibunAddr':jibunAddr,
    'roadAddr':roadAddr,
    'zipcode':zipcode,
  };}