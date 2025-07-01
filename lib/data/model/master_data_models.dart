// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/data/model/base_model.dart';
import 'package:shareindia_health_camp/domain/entities/directory_entity.dart';
import 'package:shareindia_health_camp/domain/entities/master_data_entities.dart';

class SubCategoryModel extends BaseModel {
  int? id;
  String? name;
  String? nameAr;
  int? categoryID;
  bool? isActive;

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['nameAr'];
    categoryID = json['categoryID'];
    isActive = json['isActive'];
  }

  @override
  SubCategoryEntity toEntity() {
    final subCategoryEntity = SubCategoryEntity();
    subCategoryEntity.id = id;
    subCategoryEntity.categoryID = categoryID;
    subCategoryEntity.name = name;
    subCategoryEntity.nameAr = nameAr;
    return subCategoryEntity;
  }
}

class ReasonsModel extends BaseModel {
  int? id;
  int? categoryID;
  int? subCategoryID;
  String? reason;
  String? reasonAr;
  bool? isActive;

  ReasonsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryID = json['categoryID'];
    subCategoryID = json['subCategoryID'];
    reason = json['reason'];
    reasonAr = json['reasonAr'];
    isActive = json['isActive'];
  }

  @override
  ReasonsEntity toEntity() {
    final reasonsEntity = ReasonsEntity();
    reasonsEntity.id = id;
    reasonsEntity.categoryID = categoryID;
    reasonsEntity.subCategoryID = subCategoryID;
    reasonsEntity.reason = reason;
    reasonsEntity.reasonAr = reasonAr;
    return reasonsEntity;
  }
}

class EserviceModel extends BaseModel {
  int? id;
  int? servicEID;
  int? servicEDEPARTMENTID;
  String? servicENAMEEN;
  String? servicENAMEAR;
  bool? isActive;

  EserviceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    servicEID = json['servicE_ID'];
    servicEDEPARTMENTID = json['servicE_DEPARTMENT_ID'];
    servicENAMEEN = json['servicE_NAME_EN'];
    servicENAMEAR = json['servicE_NAME_AR'];
    isActive = json['isActive'];
  }

  @override
  EserviceEntity toEntity() {
    final eserviceEntity = EserviceEntity();
    eserviceEntity.id = id;
    eserviceEntity.servicEID = servicEID;
    eserviceEntity.servicENAMEEN = servicENAMEEN;
    eserviceEntity.servicENAMEAR = servicENAMEAR;
    eserviceEntity.servicEDEPARTMENTID = servicEDEPARTMENTID;
    return eserviceEntity;
  }
}

class DepartmentModel extends BaseModel {
  int? id;
  String? name;
  String? shortName;
  String? servicENAMEAR;

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['shortName'];
  }

  @override
  DepartmentEntity toEntity() {
    final departmentEntity = DepartmentEntity();
    departmentEntity.id = id;
    departmentEntity.name = name;
    departmentEntity.shortName = shortName;
    return departmentEntity;
  }
}

class DirectoryModel extends BaseModel {
  int? id;
  String? employeeName;
  String? designation;
  String? department;
  String? emailId;

  DirectoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeName = json['name'];
    department = json['department'];
    designation = json['designation'];
    emailId = json['email'];
  }

  @override
  DirectoryEntity toEntity() {
    final directoryEntity = DirectoryEntity();
    directoryEntity.id = id;
    directoryEntity.employeeName = employeeName;
    directoryEntity.designation = designation;
    directoryEntity.department = department;
    directoryEntity.emailId = emailId;
    return directoryEntity;
  }
}
