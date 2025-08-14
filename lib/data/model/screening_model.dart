// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/data/model/base_model.dart';
import 'package:shareindia_health_camp/domain/entities/screening_entity.dart';

class ScreeningDetailsModel extends BaseModel {
  String? action;
  String? dateOfCamp;
  String? mandal;
  String? district;
  String? campLocation;
  String? state;
  String? firstName;
  String? lastName;
  String? age;
  String? sex;
  int? pregnancystatus;
  String? dateOfLMP;
  String? contactNumber;
  String? aadherNumber;
  String? clientAddress;
  int? clientMandal;
  String? occupation;
  int? consent;
  MedHistoryEntity? medHistory;
  MedHistoryEntity? onTreatment;
  NcdEntity? ncd;
  HivEntity? hiv;
  String? syndromiccases;
  int? syndromicreferred;
  StiEntity? sti;
  String? remarks;

  ScreeningDetailsModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    dateOfCamp = json['date_of_camp'];
    mandal = json['mandal'];
    district = json['district'];
    campLocation = json['camp_location'];
    state = json['state'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    age = json['age'];
    sex = json['sex'];
    pregnancystatus = json['pregnancystatus'];
    dateOfLMP = json['date_of_LMP'];
    contactNumber = json['contact_number'];
    aadherNumber = json['aadher_number'];
    clientAddress = json['client_address'];
    clientMandal = int.tryParse(json['client_mandal']) ?? 0;
    occupation = json['occupation'];
    consent = int.tryParse(json['consent']) ?? 0;
    medHistory =
        json['medHistory'] != null
            ? MedHistoryModel.fromJson(json['medHistory']).toEntity()
            : null;
    onTreatment =
        json['onTreatment'] != null
            ? MedHistoryModel.fromJson(json['onTreatment']).toEntity()
            : null;
    ncd =
        json['ncd'] != null ? NcdModel.fromJson(json['ncd']).toEntity() : null;
    hiv =
        json['hiv'] != null ? HivModel.fromJson(json['hiv']).toEntity() : null;
    syndromiccases = json['syndromiccases'];
    syndromicreferred = json['syndromicreferred'];
    sti =
        json['sti'] != null ? StiModel.fromJson(json['sti']).toEntity() : null;
    remarks = json['remarks'];
  }

  @override
  ScreeningDetailsEntity toEntity() {
    return ScreeningDetailsEntity()
      ..action = action
      ..dateOfCamp = dateOfCamp
      ..mandal = mandal
      ..district = district
      ..campLocation = campLocation
      ..state = state
      ..firstName = firstName
      ..lastName = lastName
      ..age = age
      ..sex = sex
      ..pregnancystatus = pregnancystatus
      ..dateOfLMP = dateOfLMP
      ..contactNumber = contactNumber
      ..aadherNumber = aadherNumber
      ..clientAddress = clientAddress
      ..clientMandal = clientMandal
      ..occupation = occupation
      ..consent = consent
      ..medHistory = medHistory
      ..onTreatment = onTreatment
      ..ncd = ncd
      ..hiv = hiv
      ..syndromiccases = syndromiccases
      ..syndromicreferred = syndromicreferred
      ..sti = sti
      ..remarks = remarks;
  }
}

class MedHistoryModel extends BaseModel {
  String? diabetes;
  String? hTN;
  String? hepatitis;

  MedHistoryModel.fromJson(Map<String, dynamic> json) {
    diabetes = json['Diabetes'];
    hTN = json['HTN'];
    hepatitis = json['Hepatitis'];
  }

  @override
  MedHistoryEntity toEntity() {
    return MedHistoryEntity()
      ..diabetes = diabetes
      ..hTN = hTN
      ..hepatitis = hepatitis;
  }
}

class NcdModel extends BaseModel {
  HypertensionEntity? hypertension;
  DiabetesEntity? diabetes;

  NcdModel.fromJson(Map<String, dynamic> json) {
    hypertension =
        json['hypertension'] != null
            ? HypertensionModel.fromJson(json['hypertension']).toEntity()
            : null;
    diabetes =
        json['diabetes'] != null
            ? DiabetesModel.fromJson(json['diabetes']).toEntity()
            : null;
  }

  @override
  toEntity() {
    return NcdEntity()
      ..hypertension = hypertension
      ..diabetes = diabetes;
  }
}

class HypertensionModel extends BaseModel {
  String? screened;
  String? systolic;
  String? diastolic;
  String? abnormal;

  HypertensionModel.fromJson(Map<String, dynamic> json) {
    screened = '${json['screened'] ?? '0'}';
    systolic = '${json['systolic'] ?? '0'}';
    diastolic = '${json['diastolic'] ?? ''}';
    abnormal = '${json['abnormal'] ?? ''}';
  }

  @override
  HypertensionEntity toEntity() {
    return HypertensionEntity()
      ..screened = screened
      ..systolic = systolic
      ..diastolic = diastolic
      ..abnormal = abnormal;
  }
}

class DiabetesModel extends BaseModel {
  String? screened;
  String? bloodsugar;
  String? abnormal;

  DiabetesModel.fromJson(Map<String, dynamic> json) {
    screened = '${json['screened'] ?? ''}';
    bloodsugar = '${json['bloodsugar'] ?? '0'}';
    abnormal = '${json['abnormal'] ?? ''}';
  }

  @override
  DiabetesEntity toEntity() {
    return DiabetesEntity()
      ..screened = screened
      ..bloodsugar = bloodsugar
      ..abnormal = abnormal;
  }
}

class HivModel extends BaseModel {
  String? offered;
  String? result;
  String? alreadAtART;
  String? referredICTC;
  String? nameOfICTC;
  String? confirmedICTC;
  String? referredART;

  HivModel.fromJson(Map<String, dynamic> json) {
    offered = '${json['offered'] ?? ''}';
    result = '${json['result'] ?? ''}';
    alreadAtART = '${json['alreadAtART'] ?? ''}';
    referredICTC = '${json['referredICTC'] ?? ''}';
    nameOfICTC = '${json['nameOfICTC'] ?? ''}';
    confirmedICTC = '${json['confirmedICTC'] ?? ''}';
    referredART = '${json['referredART'] ?? ''}';
  }

  @override
  HivEntity toEntity() {
    return HivEntity()
      ..offered = offered
      ..result = result
      ..alreadAtART = alreadAtART
      ..referredICTC = referredICTC
      ..nameOfICTC = nameOfICTC
      ..confirmedICTC = confirmedICTC
      ..referredART = referredART;
  }
}

class StiModel extends BaseModel {
  SyphilisEntity? syphilis;
  SyphilisEntity? hepB;
  SyphilisEntity? hepC;

  StiModel.fromJson(Map<String, dynamic> json) {
    syphilis =
        json['syphilis'] != null
            ? SyphilisModel.fromJson(json['syphilis']).toEntity()
            : null;
    hepB =
        json['hepB'] != null
            ? SyphilisModel.fromJson(json['hepB']).toEntity()
            : null;
    hepC =
        json['hepC'] != null
            ? SyphilisModel.fromJson(json['hepC']).toEntity()
            : null;
  }

  @override
  StiEntity toEntity() {
    return StiEntity()
      ..syphilis = syphilis
      ..hepB = hepB
      ..hepC = hepC;
  }
}

class SyphilisModel extends BaseModel {
  String? done;
  String? result;
  String? referred;

  SyphilisModel.fromJson(Map<String, dynamic> json) {
    done = '${json['done'] ?? ''}';
    result = '${json['result'] ?? ''}';
    referred = '${json['referred'] ?? ''}';
  }

  @override
  SyphilisEntity toEntity() {
    return SyphilisEntity()
      ..done = done
      ..result = result
      ..referred = referred;
  }
}
