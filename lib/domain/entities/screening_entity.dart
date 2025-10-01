// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/domain/entities/base_entity.dart';

class CampEntity extends BaseEntity {
  int? id;
  String? dateOfCamp;
  String? photoOfCamp;
  String? mandal;
  String? district;
  String? village;
  String? campLocation;
  String? campVillage;
  String? localPocName;
  String? localPocNumber;
  String? latitude;
  String? longitude;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['id'] = id;
    data['date_of_camp'] = dateOfCamp;
    //data['photo_of_camp'] = photoOfCamp;
    data['district'] = district;
    data['mandal'] = mandal;
    data['village'] = village;
    //data['camp_location'] = campLocation;
    //data['camp_village'] = campVillage;
    //data['local_poc_name'] = localPocName;
    //data['local_poc_number'] = localPocNumber;
    // data['latitude'] = latitude;
    //data['longitude'] = longitude;
    return data;
  }
}

class ScreeningDetailsEntity extends BaseEntity {
  int? id;
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
  String? pregnancystatus;
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
  String? syndromicreferred;
  StiEntity? sti;
  String? remarks;

  Map<String, dynamic> toExcel() {
    return toJson();
  }

  bool get didConset => consent == 1;
  bool get isHypertension =>
      ((int.tryParse(ncd?.hypertension?.systolic ?? '0') ?? 0) >= 160 ||
          (int.tryParse(ncd?.hypertension?.diastolic ?? '0') ?? 0) >= 100);
  bool get isDiabitic =>
      ((int.tryParse(ncd?.diabetes?.bloodsugar ?? '0') ?? 0) > 200);
  bool get isSyphilis => sti?.syphilis?.result == "Reactive";
  bool get isHep =>
      sti?.hepB?.result == "Reactive" || sti?.hepC?.result == "Reactive";
  bool get isHiv => hiv?.offered == '1';
  bool get isSTICase => (syndromiccases ?? '').isNotEmpty;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['action'] = action;
    data['date_of_camp'] = dateOfCamp;
    data['district'] = district;
    data['mandal'] = mandal;
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

    if (medHistory != null) {
      data['medHistory/OnTreatment'] =
          'diabetes: ${medHistory?.diabetes == "0" ? 'Non diabetic' : 'diabetic'}/${onTreatment?.diabetes == "0" ? 'Not onTreatment' : 'onTreatment'}\nHTN: ${medHistory?.hTN == "0" ? 'Non HTN' : 'HTN'}/${onTreatment?.hTN == "0" ? 'Not onTreatment' : 'onTreatment'}\nHepatitis: ${medHistory?.hepatitis == "0" ? 'Non Hepatitis' : 'Hepatitis'}/${onTreatment?.hepatitis == "0" ? 'Not onTreatment' : 'onTreatment'}';
    } else {
      data['medHistory/OnTreatment'] = '';
    }
    if (ncd != null) {
      data['diabetes'] =
          '${ncd?.diabetes?.bloodsugar} - ${ncd?.diabetes?.abnormal == "0" ? 'Normal' : 'Abnormal'} - ${ncd?.diabetes?.screened == "0" ? 'No' : 'Yes'}';
      data['hypertension'] =
          '${ncd?.hypertension?.systolic ?? 0}/${ncd?.hypertension?.diastolic ?? 0} - ${ncd?.hypertension?.abnormal == "0" ? 'Normal' : 'Abnormal'} - ${ncd?.hypertension?.screened == "0" ? 'No' : 'Yes'}';
    } else {
      data['diabetes'] = '';
      data['hypertension'] = '';
    }
    if (hiv != null) {
      data['hiv'] =
          hiv?.offered == '1'
              ? 'Offered - ${hiv?.result} - ${hiv?.alreadAtART == "0" ? 'AlreadAtART' : ''}\nICTC: ${hiv?.referredICTC == "0" ? 'No' : 'Referred'} ${hiv?.referredICTC == "0" ? '' : '- ${hiv?.nameOfICTC}'} - ${hiv?.confirmedICTC == "0" ? 'Not Confirmed' : 'Confirmed'} - ${hiv?.referredART == "0" ? 'Not ReferredART' : 'ReferredART'}'
              : 'No';
    } else {
      data['hiv'] = '';
    }
    data['syndromiccases'] = syndromiccases;
    data['syndromicreferred'] = syndromicreferred;
    if (sti != null) {
      data['syphilis'] =
          '${sti?.syphilis?.done == "0" ? 'No' : 'Done'} - ${sti?.syphilis?.result} - ${sti?.syphilis?.referred == "0" ? 'Not Referred' : 'Referred'}';
      data['hepB'] =
          '${sti?.hepB?.done == "0" ? 'No' : 'Done'} - ${sti?.hepB?.result} - ${sti?.hepB?.referred == "0" ? 'Not Referred' : 'Referred'}';
      data['hepC'] =
          '${sti?.hepC?.done == "0" ? 'No' : 'Done'} - ${sti?.hepC?.result} - ${sti?.hepC?.referred == "0" ? 'Not Referred' : 'Referred'}';
    } else {
      data['syphilis'] = '';
      data['hepB'] = '';
      data['hepC'] = '';
    }
    data['remarks'] = remarks;
    return data;
  }

  Map<String, dynamic> toEditJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['action'] = action;
    data['date_of_camp'] = dateOfCamp;
    data['mandal'] = mandal;
    data['district'] = district;
    data['village'] = '';
    data['location_of_the_camp'] = '';
    data['camp_location'] = campLocation;
    data['state'] = state;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['age'] = age;
    data['sex'] = sex;
    data['maritalstatus'] = '';
    data['pregnancystatus'] = pregnancystatus;
    data['date_of_LMP'] = dateOfLMP;
    data['contact_number'] = contactNumber;
    data['aadher_number'] = aadherNumber;
    data['client_address'] = clientAddress;
    data['client_district'] = '';
    data['client_mandal'] = clientMandal;
    data['occupation'] = occupation;
    data['consent'] = consent;
    data['knowndiabetes'] = medHistory?.diabetes;
    data['knownhtn'] = medHistory?.hTN;
    data['knownhepatitis'] = medHistory?.hepatitis;
    data['ontreatmentknowndiabetes'] = onTreatment?.diabetes;
    data['ontreatmentknownhtn'] = onTreatment?.hTN;
    data['ontreatmentknownhepatitis'] = onTreatment?.hepatitis;

    data['hypertension'] = {
      'screened': int.tryParse(ncd?.hypertension?.screened ?? ''),
      'systolic': ncd?.hypertension?.systolic,
      'diastolic': ncd?.hypertension?.diastolic,
      'referred': int.tryParse(ncd?.hypertension?.abnormal ?? ''),
    };
    data['diabetes'] = {
      'screened': int.tryParse(ncd?.diabetes?.screened ?? ''),
      'bloodsugar': ncd?.diabetes?.bloodsugar,
      'referred': int.tryParse(ncd?.diabetes?.abnormal ?? ''),
    };
    data['hiv'] = {
      'offered': int.tryParse(hiv?.offered ?? '0'),
      'result': hiv?.result,
      'alreadAtART': int.tryParse(hiv?.alreadAtART ?? '0'),
      'alreadAtARTName': hiv?.alreadAtART,
      'referredICTC': int.tryParse(hiv?.referredICTC ?? '0'),
      'nameOfICTC': hiv?.nameOfICTC,
      'confirmedICTC': int.tryParse(hiv?.confirmedICTC ?? '0'),
      'referredART': int.tryParse(hiv?.referredART ?? '0'),
    };
    data['syndromiccases'] = syndromiccases;
    data['syndromicreferred'] = syndromicreferred;

    data['sti'] = {
      'syphilis': {
        'done': int.tryParse(sti?.syphilis?.done ?? '0'),
        'result': sti?.syphilis?.result,
        'referred': int.tryParse(sti?.syphilis?.referred ?? '0'),
      },
      'hepB': {
        'done': int.tryParse(sti?.hepB?.done ?? '0'),
        'result': sti?.hepB?.result,
        'referred': int.tryParse(sti?.hepB?.referred ?? '0'),
      },
      'hepC': {
        'done': int.tryParse(sti?.hepC?.done ?? '0'),
        'result': sti?.hepC?.result,
        'referred': int.tryParse(sti?.hepC?.referred ?? '0'),
      },
    };
    data['remarks'] = remarks;
    return data;
  }
}

class MedHistoryEntity extends BaseEntity {
  String? diabetes;
  String? hTN;
  String? hepatitis;
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
  String? screened;
  String? systolic;
  String? diastolic;
  String? abnormal;

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
  String? screened;
  String? bloodsugar;
  String? abnormal;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['screened'] = screened;
    data['bloodsugar'] = bloodsugar;
    data['abnormal'] = abnormal;
    return data;
  }
}

class HivEntity extends BaseEntity {
  String? offered;
  String? result;
  String? alreadAtART;
  String? referredICTC;
  String? nameOfICTC;
  String? confirmedICTC;
  String? referredART;

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
  String? done;
  String? result;
  String? referred;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['done'] = done;
    data['result'] = result;
    data['referred'] = referred;
    return data;
  }
}
