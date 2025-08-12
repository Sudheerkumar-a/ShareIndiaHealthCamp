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
  String? aadherNumber;
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
    data['date_of_camp'] = dateOfCamp;
    data['district'] = district;
    data['mandal'] = mandal;
    data['state'] = state;
    data['name'] = '$firstName $lastName';
    data['age'] = age;
    data['sex'] = sex;
    data['contactNumber'] = contactNumber;
    data['aadharNumber'] = aadherNumber;
    data['village_colony'] = villageColony;
    data['occupation'] = occupation;
    data['consent'] = consent;
    data['remarks'] = remarks;
    data['createdAt'] = createdAt;
    return data;
  }
}

class AgentDataEntity extends BaseEntity {
  int? page;
  int? limit;
  int? total;
  int? pages;
  List<AgentEntity> agentsList = [];
}

class AgentEntity extends BaseEntity {
  String? id;
  String? parentId;
  String? districtId;
  String? mandalId;
  String? name;
  String? mobile;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['mobile'] = mobile;
    data['action'] = 'Delete';
    return data;
  }
}
