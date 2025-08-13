// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/domain/entities/base_entity.dart';

class ScreeningDetailsEntity extends BaseEntity {
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

  Map<String, dynamic> toExcel() {
    return toJson();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['action'] = action;
    data['date_of_camp'] = dateOfCamp;
    data['mandal'] = mandal;
    data['district'] = district;
    data['camp_location'] = campLocation;
    data['state'] = state;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['age'] = age;
    data['sex'] = sex;
    data['pregnancystatus'] = pregnancystatus;
    data['date_of_LMP'] = dateOfLMP;
    data['contact_number'] = contactNumber;
    data['aadher_number'] = aadherNumber;
    data['client_address'] = clientAddress;
    data['client_mandal'] = clientMandal;
    data['occupation'] = occupation;
    data['consent'] = consent;

    //if (medHistory != null) {
    data['medHistory/OnTreatment'] =
        'diabetes: 20/Yes\nHTN: 12/No\nHepatitis: 5/Yes';
    //}
    // if (onTreatment != null) {

    // data['onTreatment'] = 'diabetes: 20\nHTN: 12\nHepatitis: 5';
    //   data['onTreatment'] = onTreatment!.toJson();
    // }
    if (ncd != null) {
      data['ncd'] = ncd!.toJson();
    }
    if (hiv != null) {
      data['hiv'] = hiv!.toJson();
    }
    data['syndromiccases'] = syndromiccases;
    data['syndromicreferred'] = syndromicreferred;
    if (sti != null) {
      data['sti'] = sti!.toJson();
    }
    data['remarks'] = remarks;
    return data;
  }
}

class MedHistoryEntity extends BaseEntity {
  int? diabetes;
  int? hTN;
  int? hepatitis;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Diabetes'] = diabetes;
    data['HTN'] = hTN;
    data['Hepatitis'] = hepatitis;
    return data;
  }
}

class NcdEntity extends BaseEntity {
  HypertensionEntity? hypertension;
  DiabetesEntity? diabetes;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hypertension != null) {
      data['hypertension'] = hypertension!.toJson();
    }
    if (diabetes != null) {
      data['diabetes'] = diabetes!.toJson();
    }
    return data;
  }
}

class HypertensionEntity extends BaseEntity {
  int? screened;
  String? systolic;
  String? diastolic;
  int? abnormal;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['screened'] = screened;
    data['systolic'] = systolic;
    data['diastolic'] = diastolic;
    data['abnormal'] = abnormal;
    return data;
  }
}

class DiabetesEntity extends BaseEntity {
  int? screened;
  String? bloodsugar;
  int? abnormal;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['screened'] = screened;
    data['bloodsugar'] = bloodsugar;
    data['abnormal'] = abnormal;
    return data;
  }
}

class HivEntity extends BaseEntity {
  int? offered;
  String? result;
  int? alreadAtART;
  int? referredICTC;
  String? nameOfICTC;
  int? confirmedICTC;
  int? referredART;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offered'] = offered;
    data['result'] = result;
    data['alreadAtART'] = alreadAtART;
    data['referredICTC'] = referredICTC;
    data['nameOfICTC'] = nameOfICTC;
    data['confirmedICTC'] = confirmedICTC;
    data['referredART'] = referredART;
    return data;
  }
}

class StiEntity extends BaseEntity {
  SyphilisEntity? syphilis;
  SyphilisEntity? hepB;
  SyphilisEntity? hepC;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (syphilis != null) {
      data['syphilis'] = syphilis!.toJson();
    }
    if (hepB != null) {
      data['hepB'] = hepB!.toJson();
    }
    if (hepC != null) {
      data['hepC'] = hepC!.toJson();
    }
    return data;
  }
}

class SyphilisEntity extends BaseEntity {
  int? done;
  String? result;
  int? referred;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['done'] = done;
    data['result'] = result;
    data['referred'] = referred;
    return data;
  }
}
