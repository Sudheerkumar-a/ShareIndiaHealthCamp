// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/data/model/base_model.dart';
import 'package:shareindia_health_camp/domain/entities/dashboard_entity.dart';

class DashboardModel extends BaseModel {
  String? totalScreened;
  HivEntity? hiv;
  PartnersEntity? partners;
  StiEntity? sti;
  TbEntity? tb;
  String? iecParticipants;

  DashboardModel();

  DashboardModel.fromJson(Map<String, dynamic> response) {
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
  DashboardEntity toEntity() {
    return DashboardEntity()
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
