// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/domain/entities/base_entity.dart';

class LoginEntity extends BaseEntity {
  UserEntity? userEntity;
  String? token;

  @override
  List<Object?> get props => [token];
}

class UserEntity extends BaseEntity {
  String? id;
  String? name;
  String? email;
  String? role;
  String? district;
  String? mandal;
  int? isAdmin;

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return name ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['district'] = district;
    data['mandal'] = mandal;
    data['is_admin'] = isAdmin;
    return data;
  }
}
