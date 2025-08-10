// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/data/model/base_model.dart';
import 'package:shareindia_health_camp/domain/entities/services_entity.dart';

class ReportDataModel extends BaseModel {
  int? page;
  int? limit;
  int? total;
  int? pages;
  List<ReportEntity> reportList = [];

  ReportDataModel.fromJson(Map<String, dynamic> json) {
    final response = json['data'];
    page = response['page'];
    limit = response['limit'];
    total = int.tryParse(response['total'] ?? '0');
    pages = response['pages'];
    if (response['data'] != null) {
      response['data'].forEach((v) {
        reportList.add(ReportModel.fromJson(v).toEntity());
      });
    }
  }

  @override
  ReportDataEntity toEntity() {
    return ReportDataEntity()
      ..page = page
      ..limit = limit
      ..total = total
      ..pages = pages
      ..reportList = reportList;
  }
}

class ReportModel extends BaseModel {
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

  ReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    dateOfCamp = json['date_of_camp'];
    mandal = json['mandal'];
    district = json['district'];
    state = json['state'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    age = json['age'];
    sex = json['sex'];
    contactNumber = json['contact_number'];
    villageColony = json['village_colony'];
    occupation = json['occupation'];
    profileCategory = json['profile_category'];
    consent = json['consent'];
    tobaccoUser = json['tobacco_user'];
    alcoholUser = json['alcohol_user'];
    otherComorbidity = json['other_comorbidity'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
  }

  @override
  ReportEntity toEntity() {
    return ReportEntity()
      ..id = id
      ..userId = userId
      ..dateOfCamp = dateOfCamp
      ..mandal = mandal
      ..district = district
      ..state = state
      ..firstName = firstName
      ..lastName = lastName
      ..age = age
      ..sex = sex
      ..contactNumber = contactNumber
      ..villageColony = villageColony
      ..occupation = occupation
      ..profileCategory = profileCategory
      ..consent = consent
      ..tobaccoUser = tobaccoUser
      ..alcoholUser = alcoholUser
      ..otherComorbidity = otherComorbidity
      ..remarks = remarks
      ..createdAt = createdAt;
  }
}

class AgentDataModel extends BaseModel {
  int? id;
  int? parentId;
  int? districtId;
  int? mandalId;
  String? name;
  String? mobile;
  String? createdAt;
  List<ReportEntity> reportList = [];

  AgentDataModel.fromJson(Map<String, dynamic> json) {
    final response = json['data'];
    id = response['id'];
    parentId = response['parent_id'];
    districtId = response['district_id'];
    mandalId = response['mandal_id'];
    name = response['name'];
    mobile = response['mobile'];
    createdAt = response['created_at'];
  }

  @override
  AgentDataEntity toEntity() {
   return AgentDataEntity()..id=id
   ..parentId = parentId
   ..districtId = districtId
   ..mandalId = mandalId
   ..name = name
   ..mobile = mobile
   ..createdAt = createdAt;
  }
}

