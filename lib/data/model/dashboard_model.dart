// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/core/constants/data_constants.dart';
import 'package:shareindia_health_camp/data/model/base_model.dart';
import 'package:shareindia_health_camp/domain/entities/dashboard_entity.dart';

class DashboardModel2 extends BaseModel {
  String? totalScreened;
  HivEntity? hiv;
  PartnersEntity? partners;
  StiEntity? sti;
  TbEntity? tb;
  String? iecParticipants;

  DashboardModel2();

  DashboardModel2.fromJson(Map<String, dynamic> response) {
    final json = response['data'];
    totalScreened = json['total_screened'];
    hiv =
        json['hiv'] != null ? HivModel.fromJson(json['hiv']).toEntity() : null;
    partners =
        json['partners'] != null
            ? PartnersModel.fromJson(json['partners']).toEntity()
            : null;
    sti =
        json['sti'] != null ? StiModel.fromJson(json['sti']).toEntity() : null;
    tb = json['tb'] != null ? TbModel.fromJson(json['tb']).toEntity() : null;
    iecParticipants = json['iec_participants'];
  }

  @override
  DashboardEntityOld toEntity() {
    return DashboardEntityOld()
      ..totalScreened = totalScreened
      ..hiv = hiv
      ..partners = partners
      ..sti = sti
      ..tb = tb
      ..iecParticipants = iecParticipants;
  }
}

class HivModel extends BaseModel {
  String? screened;
  String? reactive;

  HivModel({this.screened, this.reactive});

  HivModel.fromJson(Map<String, dynamic> json) {
    screened = json['screened'];
    reactive = json['reactive'];
  }

  @override
  HivEntity toEntity() {
    return HivEntity()
      ..reactive = reactive
      ..screened = screened;
  }
}

class PartnersModel extends BaseModel {
  String? contacted;
  String? reactive;

  PartnersModel({this.contacted, this.reactive});

  PartnersModel.fromJson(Map<String, dynamic> json) {
    contacted = json['contacted'];
    reactive = json['reactive'];
  }

  @override
  PartnersEntity toEntity() {
    return PartnersEntity()
      ..contacted = contacted
      ..reactive = reactive;
  }
}

class StiModel extends BaseModel {
  String? syphilis;
  String? hepB;
  String? hepC;

  StiModel({this.syphilis, this.hepB, this.hepC});

  StiModel.fromJson(Map<String, dynamic> json) {
    syphilis = json['syphilis'];
    hepB = json['hep_b'];
    hepC = json['hep_c'];
  }

  @override
  StiEntity toEntity() {
    return StiEntity()
      ..syphilis = syphilis
      ..hepB = hepB
      ..hepC = hepC;
  }
}

class TbModel extends BaseModel {
  String? presumptive;
  String? diagnosed;

  TbModel({this.presumptive, this.diagnosed});

  TbModel.fromJson(Map<String, dynamic> json) {
    presumptive = json['presumptive'];
    diagnosed = json['diagnosed'];
  }

  @override
  TbEntity toEntity() {
    return TbEntity()
      ..diagnosed = diagnosed
      ..presumptive = presumptive;
  }
}

class DashboardModel extends BaseModel {
  List<DistrictWiseMonthlyEntity>? districtWiseMonthly;
  List<DistrictWiseTotalEntity>? districtWiseTotal;
  DistrictWiseTotalEntity? overallTotal;

  DashboardModel.fromJson(Map<String, dynamic> response) {
    final json = response['data'];
    if (json == null) {
      return;
    }
    if (json['district_wise_monthly'] != null) {
      districtWiseMonthly = <DistrictWiseMonthlyEntity>[];
      json['district_wise_monthly'].forEach((v) {
        districtWiseMonthly!.add(
          DistrictWiseMonthlyModel.fromJson(v).toEntity(),
        );
      });
    }
    if (json['district_wise_total'] != null) {
      districtWiseTotal = <DistrictWiseTotalEntity>[];
      json['district_wise_total'].forEach((v) {
        districtWiseTotal!.add(DistrictWiseTotalModel.fromJson(v).toEntity());
      });
    }
    overallTotal =
        json['overall_total'] != null
            ? DistrictWiseTotalModel.fromJson(json['overall_total']).toEntity()
            : null;
  }

  @override
  toEntity() {
    return DashboardEntity()
      ..districtWiseMonthly = districtWiseMonthly
      ..districtWiseTotal = districtWiseTotal
      ..overallTotal = overallTotal;
  }
}

class DistrictWiseMonthlyModel extends BaseModel {
  String? district;
  String? yearMonth;
  String? totalScreened;
  String? hivReactive;
  String? hypertensionAbnormal;
  String? diabetesAbnormal;
  String? cancerAbnormal;
  String? iecParticipants;
  String? tbDiagnosed;
  String? syphilisPositive;
  String? hepBPositive;
  String? hepCPositive;

  DistrictWiseMonthlyModel();

  DistrictWiseMonthlyModel.fromJson(Map<String, dynamic> json) {
    district = json['district'];
    yearMonth = json['year_month'];
    totalScreened = json['total_screened'];
    hivReactive = json['hiv_reactive'];
    hypertensionAbnormal = json['hypertension_abnormal'];
    diabetesAbnormal = json['diabetes_abnormal'];
    cancerAbnormal = json['cancer_abnormal'];
    iecParticipants = json['iec_participants'];
    tbDiagnosed = json['tb_diagnosed'];
    syphilisPositive = json['syphilis_positive'];
    hepBPositive = json['hep_b_positive'];
    hepCPositive = json['hep_c_positive'];
  }

  @override
  DistrictWiseMonthlyEntity toEntity() {
    return DistrictWiseMonthlyEntity()
      ..district = district
      ..districtName =
          districts.where((e) => e['id'] == district).firstOrNull?['name'] ?? ''
      ..yearMonth = yearMonth
      ..totalScreened = totalScreened
      ..hivReactive = hivReactive
      ..hypertensionAbnormal = hypertensionAbnormal
      ..diabetesAbnormal = diabetesAbnormal
      ..cancerAbnormal = cancerAbnormal
      ..iecParticipants = iecParticipants
      ..tbDiagnosed = tbDiagnosed
      ..syphilisPositive = syphilisPositive
      ..hepBPositive = hepBPositive
      ..hepCPositive = hepCPositive;
  }
}

class DistrictWiseTotalModel extends BaseModel {
  String? districtId;
  String? districtName;
  String? mandalId;
  String? mandalName;
  String? totalClient;
  String? totalScreened;
  String? hivReactive;
  String? hypertension;
  String? diabetes;
  String? syphilis;
  String? hepatitisA;
  String? hepatitisB;
  String? hepatitisC;
  String? stiCases;

  DistrictWiseTotalModel();

  DistrictWiseTotalModel.fromJson(Map<String, dynamic> json) {
    districtId = json['district_id'];
    districtName = json['district_name'];
    mandalId = json['mandal_id'];
    mandalName = json['mandal_name'];
    totalClient = json['total_client'];
    totalScreened = json['total_screened'];
    hivReactive = json['hiv_reactive'];
    hypertension = json['hypertension'];
    diabetes = json['diabetes'];
    syphilis = json['syphilis'];
    hepatitisA = json['hepatitis_a'];
    hepatitisB = json['hepatitis_b'];
    hepatitisC = json['hepatitis_c'];
    stiCases = json['sti_cases'];
  }

  @override
  DistrictWiseTotalEntity toEntity() {
    return DistrictWiseTotalEntity()
      ..districtId = districtId
      ..districtName = districtName
      ..mandalId = mandalId
      ..mandalName = mandalName
      ..totalClient = totalClient
      ..totalScreened = totalScreened
      ..hivReactive = hivReactive
      ..hypertension = hypertension
      ..diabetes = diabetes
      ..syphilis = syphilis
      ..hepatitisA = hepatitisA
      ..hepatitisB = hepatitisB
      ..hepatitisC = hepatitisC
      ..stiCases = stiCases;
  }
}
