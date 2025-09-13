import 'dart:convert';

RegistrationModel registrationModelFromJson(String str) =>
    RegistrationModel.fromJson(json.decode(str));

String registrationModelToJson(RegistrationModel data) =>
    json.encode(data.toJson());

class RegistrationModel {
  final String docId;
  final int createdAt;
  final String name;
  final int age;
  final String phoneNumber;
  final String email;

  RegistrationModel({
    required this.docId,
    required this.createdAt,
    required this.name,
    required this.age,
    required this.phoneNumber,
    required this.email,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) =>
      RegistrationModel(
        docId: json["docId"],
        createdAt: json["createdAt"],
        name: json["name"],
        age: json["age"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
    "docId": docId,
    "createdAt": createdAt,
    "name": name,
    "age": age,
    "phoneNumber": phoneNumber,
    "email": email,
  };
}
