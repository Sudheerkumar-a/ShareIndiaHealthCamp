// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/domain/entities/base_entity.dart';

class SingleDataEntity extends BaseEntity {
  final dynamic value;

  SingleDataEntity(this.value);
}

class ListEntity extends BaseEntity {
  List<dynamic> items = [];
}

class NameIDEntity extends BaseEntity {
  int? id;
  String? name;

  NameIDEntity();
  @override
  List<Object?> get props => [id];
  @override
  String toString() {
    return name ?? '';
  }
}
