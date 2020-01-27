import 'package:postit/app.dart';

class UserEntity {
  String gender;
  dynamic userName;
  String lastLogin;
  String lastName;
  String photo;
  String createdAt;
  String password;
  String userType;
  String phone;
  int id;
  String photoLink;
  String firstName;
  String email;
  String countryName;
  int countryId;

  UserEntity(
      {this.gender,
      this.userName,
      this.lastLogin,
      this.lastName,
      this.photo,
      this.createdAt,
      this.password,
      this.userType,
      this.phone,
      this.id,
      this.photoLink,
      this.firstName,
      this.email,
      this.countryId});

  UserEntity.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    userName = json['user_name'];
    lastLogin = json['last_login'];
    lastName = json['last_name'];
    photo = json['photo'];
    createdAt = json['created_at'];
    password = json['password'];
    userType = json['user_type'];
    phone = json['phone'];
    id = json['id'];
    photoLink = json['photo_link'];
    firstName = json['first_name'];
    email = json['email'];
    countryId = json['country_id'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['user_name'] = this.userName;
    data['last_login'] = this.lastLogin;
    data['last_name'] = this.lastName;
    data['photo'] = this.photo;
    data['created_at'] = this.createdAt;
    data['password'] = this.password;
    data['user_type'] = this.userType;
    data['phone'] = this.phone;
    data['id'] = this.id;
    data['photo_link'] = this.photoLink;
    data['first_name'] = this.firstName;
    data['email'] = this.email;
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    return data;
  }

  String getFullName() {
    return "$firstName $lastName";
  }

  @override
  String toString() {
    return 'UserEntity{gender: $gender, userName: $userName, lastLogin: $lastLogin, lastName: $lastName, photo: $photo, createdAt: $createdAt, password: $password, userType: $userType, phone: $phone, id: $id, photoLink: $photoLink, firstName: $firstName, email: $email, countryId: $countryId}';
  }

  Gender getGender() {
    Gender gender = Gender.values.where((type) {
      return type.toString().toLowerCase().contains(this.gender);
    }).elementAt(0);
    return gender;
  }

  T getInitial<T>(String label) {
    switch (label) {
      case 'First Name':
        return firstName as T;

      case 'Last Name':
        return lastName as T;

      case 'Email Addrees':
        return email as T;

      case 'Phone Number':
        return phone as T;

      case 'Country':
        return CountryEntity(id: countryId, countryName: countryName) as T;

      case 'Gender':
        return getGender() as T;
    }
  }
}
