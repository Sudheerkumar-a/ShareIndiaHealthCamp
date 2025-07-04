// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/domain/entities/base_entity.dart';

class DirectoryEntity extends BaseEntity {
  int? id;
  String? employeeName;
  String? designation;
  String? department;
  String? emailId;
  DirectoryEntity();
  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toJson({bool showActionButtons = false}) => {
    "id": id ?? '',
    "employeeName": employeeName ?? '',
    "designation": designation ?? '',
    "department": department ?? '',
    "emailId": emailId ?? '',
  };
  Map<String, dynamic> toMobileJson({bool showActionButtons = false}) => {
    "id": id ?? '',
    "employeeName": employeeName ?? '',
    "designation": designation ?? '',
    "department": department ?? '',
    "emailId": emailId ?? '',
  };
}
