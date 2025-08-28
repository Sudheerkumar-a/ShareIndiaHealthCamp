// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/data/model/base_model.dart';

import '../../domain/entities/user_entity.dart';

class LoginModel extends BaseModel {
  UserEntity? userEntity;
  String? token;
  LoginModel();

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    var loginModel = LoginModel();
    loginModel.token = json['data']?['token'];
    loginModel.userEntity =
        json['data']?['user'] != null
            ? UserModel.fromJson(json['data']?['user']).toEntity()
            : null;
    return loginModel;
  }

  @override
  LoginEntity toEntity() {
    return LoginEntity()
      ..token = token
      ..userEntity = userEntity;
  }
}

class UserModel extends BaseModel {
  String? id;
  String? name;
  String? email;
  String? role;
  String? district;
  String? mandal;
  int? isAdmin;
  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['data'] ?? json;
    id = userJson['id'];
    name = userJson['name'];
    email = userJson['email'];
    role = userJson['role'];
    district = userJson['district'];
    mandal = '${userJson['mandal']}';
    isAdmin = int.tryParse('${userJson['is_admin']}');
  }

  @override
  List<Object?> get props => [id];

  @override
  UserEntity toEntity() {
    UserEntity userEntity = UserEntity();
    userEntity.id = id;
    userEntity.name = name;
    userEntity.email = email;
    userEntity.role = role;
    userEntity.district = district;
    userEntity.mandalId = int.tryParse(mandal ?? '');
    userEntity.isAdmin = isAdmin;
    return userEntity;
  }
}
