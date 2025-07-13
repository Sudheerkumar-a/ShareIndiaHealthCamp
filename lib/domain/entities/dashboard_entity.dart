// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/domain/entities/base_entity.dart';

class DashboardEntityOld extends BaseEntity {
  String? totalScreened;
  HivEntity? hiv;
  PartnersEntity? partners;
  StiEntity? sti;
  TbEntity? tb;
  String? iecParticipants;
  String? district;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['district'] = district;
    data['hiv'] = hiv?.reactive ?? '';
    data['cancer'] = iecParticipants;
    data['diabities'] = iecParticipants;
    data['hypertension'] = iecParticipants;
    data['totalScreened'] = totalScreened;
    return data;
  }
}

class HivEntity extends BaseEntity {
  String? screened;
  String? reactive;
}

class PartnersEntity extends BaseEntity {
  String? contacted;
  String? reactive;
}

class StiEntity extends BaseEntity {
  String? syphilis;
  String? hepB;
  String? hepC;
}

class TbEntity extends BaseEntity {
  String? presumptive;
  String? diagnosed;
}

class DashboardEntity extends BaseEntity {
  List<DistrictWiseMonthlyEntity>? districtWiseMonthly;
  List<DistrictWiseTotalEntity>? districtWiseTotal;
  DistrictWiseTotalEntity? overallTotal;
}

class DistrictWiseMonthlyEntity extends BaseEntity {
  String? district;
  String? districtName;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['district'] = districtName;
    data['totalScreened'] = totalScreened;
    data['hiv'] = hivReactive ?? '';
    data['cancer'] = cancerAbnormal;
    data['diabities'] = diabetesAbnormal;
    data['hypertension'] = hypertensionAbnormal;
    return data;
  }
}

class DistrictWiseTotalEntity extends BaseEntity {
  String? district;
  String? totalScreened;
  String? hivReactive;
  String? hypertensionAbnormal;
  String? diabetesAbnormal;
  String? cancerAbnormal;
  String? cancerScreened;
  String? cancerReferred;
  String? iecParticipants;
  String? tbDiagnosed;
  String? syphilisPositive;
  String? hepBPositive;
  String? hepCPositive;
}
