

class UserModel{
  String? phoneNumber,password;

  UserModel({required this.phoneNumber,required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['phoneNumber'] = phoneNumber;
    json['password'] = password;
    return json;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'] ?? '';
    password = json['password'] ?? '';
  }
}