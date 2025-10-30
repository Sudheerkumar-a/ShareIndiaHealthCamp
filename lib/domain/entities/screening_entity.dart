// ignore_for_file: must_be_immutable

import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/constants/data_constants.dart';
import 'package:shareindia_health_camp/domain/entities/base_entity.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';

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
    data['id'] = id;
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
  int? campId;
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
  String? maritalStatus;
  String? pregnancystatus;
  String? dateOfLMP;
  String? contactNumber;
  String? aadherNumber;
  String? clientAddress;
  String? clientMandal;
  int? clientMandalID;
  String? clientVillage;
  int? clientVillageID;
  String? occupation;
  int? consent;
  MedHistoryEntity? medHistory;
  MedHistoryEntity? onTreatment;
  NcdEntity? ncd;
  HivEntity? hiv;
  String? syndromiccases;
  String? syndromicreferred;
  String? syndromicTreatmentProvided;
  StiEntity? sti;
  String? remarks;

  String yesNoStatus(
    String? value, {
    String? possitveText,
    String? nagitiveText,
  }) {
    if (value == null || value.isEmpty) return '';
    return value == '0' ? nagitiveText ?? 'No' : possitveText ?? 'Yes';
  }

  Map<String, dynamic> toExcel() {
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
    data['marital_status'] = maritalStatus;
    data['contact_number'] = contactNumber;
    data['aadher_number'] = aadherNumber;
    data['client_address'] = clientAddress;
    data['client_mandal'] = clientMandal;
    data['client_village'] = clientVillage;
    data['occupation'] = occupation;
    data['consent'] = consent;
    if (medHistory != null) {
      data['Diabetes'] = yesNoStatus(medHistory?.diabetes);
      data['On_treatment'] = yesNoStatus(onTreatment?.diabetes);
      data['HTN'] = yesNoStatus(medHistory?.hTN);
      data['On_treatment'] = yesNoStatus(onTreatment?.hTN);
      data['Hepatitis'] = yesNoStatus(medHistory?.hepatitis);
      data['On_treatment'] = yesNoStatus(onTreatment?.hepatitis);
    } else {
      data['Diabetes'] = '';
      data['On_treatment'] = '';
      data['HTN'] = '';
      data['On_treatment'] = '';
      data['Hepatitis'] = '';
      data['On_treatment'] = '';
    }

    if (ncd != null) {
      data['diabetes_screened'] = yesNoStatus(ncd?.diabetes?.screened);
      data['diabetes_Result'] = ncd?.diabetes?.bloodsugar ?? '0';
      data['diabetes_Reffered'] = yesNoStatus(ncd?.diabetes?.abnormal);
      data['hypertension_screened'] = yesNoStatus(ncd?.hypertension?.screened);
      data['hypertension_Systolic'] = ncd?.hypertension?.systolic ?? '0';
      data['hypertension_Diastolic'] = ncd?.hypertension?.diastolic ?? '0';
      data['hypertension_Reffered'] = yesNoStatus(ncd?.hypertension?.abnormal);
    } else {
      data['diabetes_screened'] = '';
      data['diabetes_Result'] = '';
      data['diabetes_Reffered'] = '';
      data['hypertension_screened'] = '';
      data['hypertension_Systolic'] = '';
      data['hypertension_Diastolic'] = '';
      data['hypertension_Reffered'] = '';
    }
    if (hiv != null) {
      data['pregnancystatus'] = pregnancystatus;
      data['date_of_LMP'] = dateOfLMP;
      data['Hiv_Offered'] = hiv?.offered ?? '';
      data['Hiv_Result'] = hiv?.result ?? '';
      data['Alread_At_ART'] = yesNoStatus(hiv?.alreadAtART);
      data['ART_Name'] = hiv?.nameOfART ?? '';
      data['Referred_ICTC'] = yesNoStatus(hiv?.referredICTC);
      data['Confirmed_ICTC'] = yesNoStatus(hiv?.confirmedICTC);
      data['Referred_ART'] = yesNoStatus(hiv?.referredART);
    } else {
      data['pregnancystatus'] = pregnancystatus;
      data['date_of_LMP'] = dateOfLMP;
      data['Hiv_Offered'] = '';
      data['Hiv_Result'] = '';
      data['Alread_At_ART'] = '';
      data['ART_Name'] = '';
      data['Referred_ICTC'] = '';
      data['Confirmed_ICTC'] = '';
      data['Referred_ART'] = '';
    }
    data['syndromiccases'] = syndromiccases;
    data['syndromicreferred'] = syndromicreferred;
    data['treatment_provided'] = syndromicTreatmentProvided;
    if (sti != null) {
      data['syphilis_done'] = yesNoStatus(sti?.syphilis?.done);
      data['syphilis_result'] = sti?.syphilis?.result ?? '';
      data['syphilis_referred'] = yesNoStatus(sti?.syphilis?.referred);
      data['hepB_done'] = yesNoStatus(sti?.hepB?.done);
      data['hepB_result'] = sti?.hepB?.result ?? '';
      data['hepB_referred'] = yesNoStatus(sti?.hepB?.referred);
      data['hepC_done'] = yesNoStatus(sti?.hepC?.done);
      data['hepC_result'] = sti?.hepC?.result ?? '';
      data['hepC_referred'] = yesNoStatus(sti?.hepC?.referred);
    } else {
      data['syphilis_done'] = '';
      data['syphilis_result'] = '';
      data['syphilis_referred'] = '';
      data['hepB_done'] = '';
      data['hepB_result'] = '';
      data['hepB_referred'] = '';
      data['hepC_done'] = '';
      data['hepC_result'] = '';
      data['hepC_referred'] = '';
    }
    data['remarks'] = remarks;
    return data;
  }

  bool get didConset => consent == 1;
  bool get isHypertension =>
      ((int.tryParse(ncd?.hypertension?.systolic ?? '0') ?? 0) >= systolic ||
          (int.tryParse(ncd?.hypertension?.diastolic ?? '0') ?? 0) >=
              diastolic);
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
    data['marital_status'] = maritalStatus;
    data['pregnancystatus'] = pregnancystatus;
    data['date_of_LMP'] = dateOfLMP;
    data['contact_number'] = contactNumber;
    data['aadher_number'] = aadherNumber;
    data['client_address'] = clientAddress;
    data['client_mandal'] = clientMandal;
    data['client_village'] = clientVillage;
    data['occupation'] = occupation;
    data['consent'] = consent;

    if (medHistory != null) {
      data['medHistory/OnTreatment'] =
          'diabetes: ${yesNoStatus(medHistory?.diabetes, possitveText: 'diabetic', nagitiveText: 'Non diabetic')}/${yesNoStatus(onTreatment?.diabetes, nagitiveText: 'Not onTreatment', possitveText: 'onTreatment')}\nHTN: ${yesNoStatus(medHistory?.hTN, nagitiveText: 'Non HTN', possitveText: 'HTN')}/${yesNoStatus(onTreatment?.hTN, nagitiveText: 'Not onTreatment', possitveText: 'onTreatment')}\nHepatitis: ${yesNoStatus(medHistory?.hepatitis, nagitiveText: 'Non Hepatitis', possitveText: 'Hepatitis')}/${yesNoStatus(onTreatment?.hepatitis, nagitiveText: 'Not onTreatment', possitveText: 'onTreatment')}';
    } else {
      data['medHistory/OnTreatment'] = '';
    }
    if (ncd != null) {
      data['diabetes'] =
          '${ncd?.diabetes?.bloodsugar} - ${yesNoStatus(ncd?.diabetes?.abnormal, nagitiveText: 'Normal', possitveText: 'Abnormal')} - ${yesNoStatus(ncd?.diabetes?.screened)}';
      data['hypertension'] =
          '${ncd?.hypertension?.systolic ?? 0}/${ncd?.hypertension?.diastolic ?? 0} - ${yesNoStatus(ncd?.hypertension?.abnormal, nagitiveText: 'Normal', possitveText: 'Abnormal')} - ${yesNoStatus(ncd?.hypertension?.screened)}';
    } else {
      data['diabetes'] = '';
      data['hypertension'] = '';
    }
    if (hiv != null) {
      data['hiv'] =
          hiv?.offered == '1'
              ? 'Offered - ${hiv?.result} - ${hiv?.alreadAtART == "1" ? 'AlreadAtART:${hiv?.nameOfART}' : '\nICTC: ${yesNoStatus(hiv?.referredICTC, possitveText: 'Referred')} ${(hiv?.referredICTC ?? "0") == "0" ? '' : '- ${hiv?.nameOfICTC}'} - ${yesNoStatus(hiv?.confirmedICTC, nagitiveText: 'Not Confirmed', possitveText: 'Confirmed')} - ${yesNoStatus(hiv?.referredART, nagitiveText: 'Not ReferredART', possitveText: 'ReferredART')}'}'
              : 'No';
    } else {
      data['hiv'] = '';
    }
    data['syndromiccases'] = syndromiccases ?? '';
    data['syndromicreferred'] = syndromicreferred ?? '';
    data['treatment_provided'] = syndromicTreatmentProvided ?? '';
    if (sti != null) {
      data['syphilis'] =
          '${yesNoStatus(sti?.syphilis?.done, nagitiveText: 'No', possitveText: 'Done')} - ${sti?.syphilis?.result} - ${yesNoStatus(sti?.syphilis?.referred, nagitiveText: 'Not Referred', possitveText: 'Referred')}';
      data['hepB'] =
          '${yesNoStatus(sti?.hepB?.done, nagitiveText: 'No', possitveText: 'Done')} - ${sti?.hepB?.result} - ${yesNoStatus(sti?.hepB?.referred, nagitiveText: 'Not Referred', possitveText: 'Referred')}';
      data['hepC'] =
          '${yesNoStatus(sti?.hepC?.done, nagitiveText: 'No', possitveText: 'Done')} - ${sti?.hepC?.result} - ${yesNoStatus(sti?.hepC?.referred, nagitiveText: 'Not Referred', possitveText: 'Referred')}';
    } else {
      data['syphilis'] = '';
      data['hepB'] = '';
      data['hepC'] = '';
    }
    data['remarks'] = remarks;
    return data;
  }

  Map<String, dynamic> toFilterJson(int category) {
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
    data['marital_status'] = maritalStatus;
    data['contact_number'] = contactNumber;
    data['aadher_number'] = aadherNumber;
    data['client_address'] = clientAddress;
    data['client_mandal'] = clientMandal;
    data['client_village'] = clientVillage;
    data['occupation'] = occupation;
    data['consent'] = consent;
    switch (category) {
      case 2:
        {}
      case 3:
        {
          if (ncd != null) {
            data['hypertension_screened'] = yesNoStatus(
              ncd?.hypertension?.screened,
            );
            data['hypertension_Systolic'] = ncd?.hypertension?.systolic ?? '0';
            data['hypertension_Diastolic'] =
                ncd?.hypertension?.diastolic ?? '0';
            data['hypertension_Reffered'] = yesNoStatus(
              ncd?.hypertension?.abnormal,
            );
          } else {
            data['hypertension_screened'] = '';
            data['hypertension_Systolic'] = '';
            data['hypertension_Diastolic'] = '';
            data['hypertension_Reffered'] = '';
          }
        }
      case 4:
        {
          if (ncd != null) {
            data['diabetes_screened'] = yesNoStatus(ncd?.diabetes?.screened);
            data['diabetes_Result'] = ncd?.diabetes?.bloodsugar ?? '0';
            data['diabetes_Reffered'] = yesNoStatus(ncd?.diabetes?.abnormal);
          } else {
            data['diabetes_screened'] = '';
            data['diabetes_Result'] = '';
            data['diabetes_Reffered'] = '';
          }
        }
      case 5 || 9 || 10:
        {
          if (sti != null) {
            data['hepB'] =
                '${yesNoStatus(sti?.hepB?.done, possitveText: 'Done')} - ${sti?.hepB?.result} - ${yesNoStatus(sti?.hepB?.referred, nagitiveText: 'Not Referred', possitveText: 'Referred')}';
            data['hepC'] =
                '${yesNoStatus(sti?.hepC?.done, possitveText: 'Done')} - ${sti?.hepC?.result} - ${yesNoStatus(sti?.hepC?.referred, nagitiveText: 'Not Referred', possitveText: 'Referred')}';
          } else {
            data['hepB'] = '';
            data['hepC'] = '';
          }
        }
      case 6:
        {
          if (hiv != null) {
            data['pregnancystatus'] = pregnancystatus;
            data['date_of_LMP'] = dateOfLMP;
            data['Hiv_Offered'] = hiv?.offered ?? '';
            data['Hiv_Result'] = hiv?.result ?? '';
            data['Alread_At_ART'] = yesNoStatus(hiv?.alreadAtART);
            data['ART_Name'] = hiv?.nameOfART ?? '';
            data['Referred_ICTC'] = yesNoStatus(hiv?.referredICTC);
            data['Confirmed_ICTC'] = yesNoStatus(hiv?.confirmedICTC);
            data['Referred_ART'] = yesNoStatus(hiv?.referredART);
          } else {
            data['pregnancystatus'] = pregnancystatus;
            data['date_of_LMP'] = dateOfLMP;
            data['Hiv_Offered'] = '';
            data['Hiv_Result'] = '';
            data['Alread_At_ART'] = '';
            data['ART_Name'] = '';
            data['Referred_ICTC'] = '';
            data['Confirmed_ICTC'] = '';
            data['Referred_ART'] = '';
          }
        }
      case 7:
        {
          if (sti != null) {
            data['syphilis'] =
                '${yesNoStatus(sti?.syphilis?.done, possitveText: 'Done')} - ${sti?.syphilis?.result} - ${yesNoStatus(sti?.syphilis?.referred, nagitiveText: 'Not Referred', possitveText: 'Referred')}';
          } else {
            data['syphilis'] = '';
          }
        }
      case 8:
        {
          data['syndromiccases'] = syndromiccases;
          data['syndromicreferred'] = syndromicreferred;
          data['treatment_provided'] = syndromicTreatmentProvided;
        }
      default:
        {}
    }
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
    data['maritalstatus'] = maritalStatus;
    data['pregnancystatus'] = int.tryParse('${pregnancystatus ?? 0}');
    data['date_of_LMP'] = dateOfLMP;
    data['contact_number'] = contactNumber;
    data['aadher_number'] = aadherNumber;
    data['client_address'] = clientAddress;
    data['client_district'] = '';
    data['client_mandal'] = clientMandalID;
    data['client_mandal_id'] = clientMandalID;
    data['client_village'] = clientVillage;
    data['clientvillage'] = clientVillageID;
    data['occupation'] = occupation;
    data['consent'] = consent;
    data['knowndiabetes'] = int.tryParse(medHistory?.diabetes ?? '0');
    data['knownhtn'] = int.tryParse(medHistory?.hTN ?? '0');
    data['knownhepatitis'] = int.tryParse(medHistory?.hepatitis ?? '0');
    data['ontreatmentknowndiabetes'] = int.tryParse(
      onTreatment?.diabetes ?? '0',
    );
    data['ontreatmentknownhtn'] = int.tryParse(onTreatment?.hTN ?? '0');
    data['ontreatmentknownhepatitis'] = int.tryParse(
      onTreatment?.hepatitis ?? '0',
    );

    data['hypertension'] = {
      'screened': int.tryParse(ncd?.hypertension?.screened ?? ''),
      'systolic': ncd?.hypertension?.systolic?.trim(),
      'diastolic': ncd?.hypertension?.diastolic?.trim(),
      'referred': int.tryParse(ncd?.hypertension?.abnormal ?? ''),
    };
    data['diabetes'] = {
      'screened': int.tryParse(ncd?.diabetes?.screened ?? ''),
      'bloodsugar': ncd?.diabetes?.bloodsugar?.trim(),
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
    data['syndromiccases'] =
        syndromicCases
            .map(
              (e) =>
                  NameIDEntity()
                    ..id = int.tryParse(e['id'] ?? '0')
                    ..name = e['name'],
            )
            .toList()
            .where((e) => (syndromiccases?.contains(e.name ?? '0') == true))
            .toList(); // syndromiccases;
    data['syndromicreferred'] = int.tryParse(syndromicreferred ?? '0');
    data['treatment_provided'] =
        treatmentprovided
            .map(
              (e) =>
                  NameIDEntity()
                    ..id = int.tryParse(e['id'] ?? '0')
                    ..name = e['name'],
            )
            .toList()
            .where(
              (e) =>
                  (syndromicTreatmentProvided?.contains(e.name ?? '0') == true),
            )
            .toList();
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
  String? nameOfART;
  String? referredICTC;
  String? nameOfICTC;
  String? confirmedICTC;
  String? referredART;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offered'] = offered;
    data['result'] = result;
    data['alreadAtART'] = alreadAtART;
    data['nameOfART'] = nameOfART;
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
