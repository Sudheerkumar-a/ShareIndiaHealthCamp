// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/domain/entities/base_entity.dart';

class DashboardEntity extends BaseEntity {
  String? totalScreened;
  HivEntity? hiv;
  PartnersEntity? partners;
  StiEntity? sti;
  TbEntity? tb;
  String? iecParticipants;
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
