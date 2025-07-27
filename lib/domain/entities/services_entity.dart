// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/domain/entities/base_entity.dart';

class ReportDataEntity extends BaseEntity {
  int? page;
  int? limit;
  int? total;
  int? pages;
  List<ReportEntity> reportList = [];
}

class ReportEntity extends BaseEntity {
  String? id;
  String? userId;
  String? dateOfCamp;
  String? mandal;
  String? district;
  String? state;
  String? firstName;
  String? lastName;
  String? age;
  String? sex;
  String? contactNumber;
  String? villageColony;
  String? occupation;
  String? profileCategory;
  String? consent;
  String? tobaccoUser;
  String? alcoholUser;
  String? otherComorbidity;
  String? remarks;
  String? createdAt;

  ReportEntity();

  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['district'] = district;
    data['mandal'] = mandal;
    data['name'] = '$firstName $lastName';
    data['action'] = 'Edit/Delete';
    return data;
  }

  Map<String, dynamic> toExcel() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['district'] = district;
    data['mandal'] = mandal;
    data['name'] = '$firstName $lastName';
    data['age'] = age;
    data['sex'] = sex;
    data['contactNumber'] = contactNumber;
    data['remarks'] = remarks;
    return data;
  }
}
