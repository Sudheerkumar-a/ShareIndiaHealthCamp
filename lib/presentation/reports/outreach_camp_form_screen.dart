import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/constants/data_constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/field_entity_extension.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/data/remote/api_urls.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
import 'package:shareindia_health_camp/injection_container.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/discard_changes_dialog_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/step_meter_widget.dart';
import 'package:shareindia_health_camp/presentation/utils/dialogs.dart';
import 'package:shareindia_health_camp/res/drawables/drawable_assets.dart';

class OutreachCampFormScreen extends BaseScreenWidget {
  static start(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: OutreachCampFormScreen(),
      ),
    );
  }

  OutreachCampFormScreen({super.key});

  final ValueNotifier<int> _stepNotifier = ValueNotifier(1);
  final ValueNotifier<bool> _doFormRefresh = ValueNotifier(false);
  final ValueNotifier<bool> _doDatavalidation = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();
  final Map fieldsData = {};
  final step1formFields = List<FormEntity>.empty(growable: true);
  final step2formFields = List<FormEntity>.empty(growable: true);
  final step3formFields = List<FormEntity>.empty(growable: true);
  final step4formFields = List<FormEntity>.empty(growable: true);
  final step5formFields = List<FormEntity>.empty(growable: true);
  final step6formFields = List<FormEntity>.empty(growable: true);
  final referralFormFields = List<FormEntity>.empty(growable: true);
  final consentFormFields = List<FormEntity>.empty(growable: true);
  final indexTestingFormFields = List<FormEntity>.empty(growable: true);
  final stepCount = 9;
  _onDataChanged(bool doRefresh) {
    Future.delayed(Duration(milliseconds: 500), () {
      _formKey.currentState?.validate();
    });
    _doDatavalidation.value = !_doDatavalidation.value;
    if (doRefresh) {
      _doFormRefresh.value = !_doFormRefresh.value;
    }
  }

  List<List<FormEntity>> _getFormFields(BuildContext context) {
    final resources = context.resources;
    if (step1formFields.isEmpty) {
      step1formFields.addAll([
        FormEntity()
          ..name = 'integratedoutreachcampform'
          ..labelEn = 'Camp Details'
          ..labelTe = 'Camp Details'
          ..type = 'labelheader',
        FormEntity()
          ..name = 'date_of_camp'
          ..labelEn = 'Date Of Camp'
          ..labelTe = 'Date Of Camp'
          ..type = 'date'
          ..placeholderEn = 'dd/mm/yyyy'
          ..validation = (FormValidationEntity()..required = true)
          ..messages =
              (FormMessageEntity()..requiredEn = 'Please Enter DateOfCamp')
          ..suffixIcon = DrawableAssets.icCalendar
          ..onDatachnage = (value) {
            fieldsData['date_of_camp'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'district'
          ..labelEn = 'District'
          ..labelTe = 'District'
          ..type = 'collection'
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Select District'
          ..inputFieldData = {
            'items':
                districts
                    .map(
                      (item) =>
                          NameIDModel.fromDistrictsJson(
                            item as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
          }
          ..onDatachnage = (value) {
            final child =
                step1formFields
                    .where((item) => item.name == 'mandal')
                    .firstOrNull;
            if (child != null) {
              child.url = mandalListApiUrl;
              child.urlInputData = {'dist_id': value.id};
              child.inputFieldData = null;
              child.fieldValue = null;
            }
            fieldsData['district'] = value.id;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'mandal'
          ..labelEn = 'Mandal'
          ..labelTe = 'Mandal'
          ..type = 'collection'
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Select Mandal'
          ..onDatachnage = (value) {
            fieldsData['mandal'] = value.id;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'camp_location'
          ..label = resources.string.locationoftheCamp
          ..type = 'collection'
          ..validation =
              (FormValidationEntity()
                ..required = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Camp Village / Location'
                ..requiredTe = 'Please Enter Camp Village / Location'
                ..regexEn = 'Please Enter Valid Camp Village / Location'
                ..regexTe = 'Please Enter Valid Camp Village / Location')
          ..placeholderEn = 'Camp Village / Location'
          ..placeholderTe = 'Camp Village / Location'
          ..inputFieldData = {
            'items':
                [
                      {'id': '1', 'name': 'CHC'},
                      {'id': '1', 'name': 'PHC'},
                      {'id': '2', 'name': 'CHC'},
                      {'id': '3', 'name': 'Sub centre'},
                      {'id': '4', 'name': 'Anganwadi'},
                      {'id': '5', 'name': 'UPHC'},
                      {'id': '6', 'name': 'Other (specify)'},
                    ]
                    .map(
                      (item) =>
                          NameIDModel.fromDistrictsJson(
                            item as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
            'doSort': false,
          }
          ..onDatachnage = (value) {
            final child =
                step1formFields
                    .where((item) => item.name == 'camp_location_other')
                    .firstOrNull;
            if (value.id == 6) {
              if (child != null) {
                child.isHidden = false;
              }
            } else {
              if (child != null) {
                child.isHidden = true;
                child.fieldValue = null;
              }
            }
            fieldsData['camp_location'] = value.name;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'camp_location_other'
          ..type = 'text'
          ..isHidden = true
          ..validation =
              (FormValidationEntity()
                ..required = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Camp Village / Location'
                ..requiredTe = 'Please Enter Camp Village / Location'
                ..regexEn = 'Please Enter Valid Camp Village / Location'
                ..regexTe = 'Please Enter Valid Camp Village / Location')
          ..placeholderEn = 'Camp Village / Location'
          ..placeholderTe = 'Camp Village / Location'
          ..onDatachnage = (value) {
            fieldsData['camp_location'] = value;
            _onDataChanged(false);
          },
      ]);
    }
    if (referralFormFields.isEmpty) {
      referralFormFields.addAll([
        FormEntity()
          ..name = 'referralFormHeader'
          ..label = resources.string.referralDetails
          ..type = 'labelheader',
        FormEntity()
          ..name = 'visit_type'
          ..label = 'Visit Type'
          ..type = 'radio'
          ..validation =
              (FormValidationEntity()
                ..required = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Name'
                ..requiredTe = 'Please Enter Name'
                ..regexEn = 'Please Enter Valid Name'
                ..regexTe = 'Please Enter Valid Name')
          ..placeholderEn = 'Name'
          ..placeholderTe = 'Name'
          ..inputFieldData =
              [
                    {"id": "1", "name": "Walk in (Self referral)"},
                    {"id": "2", "name": "Referred"},
                  ]
                  .map(
                    (item) =>
                        NameIDModel.fromDistrictsJson(
                          item as Map<String, dynamic>,
                        ).toEntity(),
                  )
                  .toList()
          ..onDatachnage = (value) {
            final childs = referralFormFields.where(
              (item) => [
                'refferedby',
                'referred_person_name',
                'referred_contact_number',
              ].contains(item.name),
            );
            for (var child in childs) {
              child.isHidden = value.id == 1;
              child.fieldValue = null;
            }
            final radio =
                referralFormFields
                    .where((item) => item.name == 'visit_type')
                    .firstOrNull;
            radio?.fieldValue = value;
            fieldsData['visit_type'] = value.name;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'refferedby'
          ..label = 'Reffered By'
          ..type = 'collection'
          ..isHidden = true
          ..validation =
              (FormValidationEntity()
                ..required = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Select Reffered By'
                ..requiredTe = 'Please Select Reffered By')
          ..placeholder = 'Reffered By'
          ..inputFieldData = {
            'items':
                [
                      {"id": "1", "name": "Spouse"},
                      {"id": "2", "name": "Partner"},
                      {"id": "3", "name": "Friend"},
                      {"id": "4", "name": "Neighbour"},
                      {"id": "5", "name": "Healthcare Provider"},
                      {"id": "6", "name": "NGO Worker"},
                      {"id": "7", "name": "Other (please specify)"},
                    ]
                    .map(
                      (item) =>
                          NameIDModel.fromDistrictsJson(
                            item as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
            'doSort': false,
          }
          ..onDatachnage = (value) {
            final child =
                referralFormFields
                    .where((item) => item.name == 'referredby_other')
                    .firstOrNull;
            if (value.id == 7) {
              if (child != null) {
                child.isHidden = false;
              }
            } else {
              if (child != null) {
                child.isHidden = true;
                child.fieldValue = null;
              }
            }
            fieldsData['refferedby'] = value.name;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'referredby_other'
          ..type = 'text'
          ..isHidden = true
          ..validation =
              (FormValidationEntity()
                ..required = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..regexEn = 'Please Enter Valid referred by'
                ..regexTe = 'Please Enter Valid referred by')
          ..placeholder = 'referred by'
          ..onDatachnage = (value) {
            fieldsData['refferedby'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'referred_person_name'
          ..label = 'Referred Person Name'
          ..type = 'text'
          ..isHidden = true
          ..validation = (FormValidationEntity()..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..regexEn = 'Please Enter Valid Referred Person Name'
                ..regexTe = 'Please Enter Valid Referred Person Name')
          ..placeholder = 'Referred Person Name'
          ..onDatachnage = (value) {
            fieldsData['referred_person_name'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'referred_contact_number'
          ..label = 'Referred Contact Number'
          ..type = 'number'
          ..isHidden = true
          ..messages =
              (FormMessageEntity()
                ..regexEn = 'Please Enter Valid Mobile Number'
                ..regexTe = 'Please Enter Valid Mobile Number')
          ..validation =
              (FormValidationEntity()
                ..maxLength = 10
                ..regex = numberRegExp)
          ..placeholder = 'Referred Contact Number'
          ..onDatachnage = (value) {
            fieldsData['referred_contact_number'] = value;
            _onDataChanged(false);
          },
      ]);
    }
    if (step2formFields.isEmpty) {
      step2formFields.addAll([
        FormEntity()
          ..name = 'step2Header'
          ..labelEn = 'Demographic Details'
          ..labelTe = 'Personal Details'
          ..type = 'labelheader',
        FormEntity()
          ..name = 'first_name'
          ..labelEn = 'Name'
          ..labelTe = 'Name'
          ..type = 'text'
          ..validation =
              (FormValidationEntity()
                ..required = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Name'
                ..requiredTe = 'Please Enter Name'
                ..regexEn = 'Please Enter Valid Name'
                ..regexTe = 'Please Enter Valid Name')
          ..placeholderEn = 'Name'
          ..placeholderTe = 'Name'
          ..onDatachnage = (value) {
            fieldsData['first_name'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'last_name'
          ..labelEn = 'Surname'
          ..labelTe = 'Surname'
          ..type = 'text'
          ..validation =
              (FormValidationEntity()
                ..required = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Surname'
                ..requiredTe = 'Please Enter Surname'
                ..regexEn = 'Please Enter Valid Surname'
                ..regexTe = 'Please Enter Valid Surname')
          ..placeholderEn = 'Surname'
          ..placeholderTe = 'Surname'
          ..onDatachnage = (value) {
            fieldsData['last_name'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'age'
          ..type = 'number'
          ..validation =
              (FormValidationEntity()
                ..required = true
                ..max = 100)
          ..messages =
              (FormMessageEntity()
                ..maxEn = 'please enter age below 100'
                ..maxTe = 'please enter age below 100')
          ..placeholderEn = 'Age'
          ..placeholderTe = 'Age'
          ..labelEn = 'Age'
          ..labelTe = 'Age'
          ..onDatachnage = (value) {
            fieldsData['age'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'sex'
          ..labelEn = 'Sex'
          ..labelTe = 'Sex'
          ..type = 'collection'
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Select Sex'
          ..inputFieldData = {
            'items':
                gender
                    .map(
                      (item) =>
                          NameIDModel.fromIdNameJson(
                            item as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
            'doSort': false,
          }
          ..onDatachnage = (value) {
            final childs =
                step4formFields
                    .where(
                      (item) => [
                        'breastcancer',
                        'cervicalcancer',
                      ].contains(item.name),
                    )
                    .toList();
            for (var child in childs) {
              child.isHidden = value.id != 2;
              child.fieldValue = null;
            }
            fieldsData['sex'] = value.name;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'maritalstatus'
          ..label = 'Marital status'
          ..type = 'collection'
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Select Marital status'
          ..inputFieldData = {
            'items':
                maritalStatus
                    .map(
                      (item) =>
                          NameIDModel.fromIdNameJson(
                            item as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
            'doSort': false,
          }
          ..onDatachnage = (value) {
            fieldsData['maritalstatus'] = value.name;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'aadhar'
          ..labelEn = 'Aadhar No(optional)'
          ..labelTe = 'Aadhar No(optional)'
          ..type = 'number'
          ..validation =
              (FormValidationEntity()
                ..maxLength = 12
                ..regex = numberRegExp)
          ..messages =
              (FormMessageEntity()
                ..regexEn = 'Please Enter Valid Aadhar No'
                ..regexTe = 'Please Enter Valid Aadhar No')
          ..placeholderEn = 'Aadhar No(optional)'
          ..placeholderTe = 'Aadhar No(optional)'
          ..onDatachnage = (value) {
            fieldsData['aadher_number'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'contact_number'
          ..labelEn = 'Contact Number'
          ..labelTe = 'Contact Number'
          ..type = 'number'
          ..messages =
              (FormMessageEntity()
                ..regexEn = 'Please Enter Valid Mobile Number'
                ..regexTe = 'Please Enter Valid Mobile Number')
          ..validation =
              (FormValidationEntity()
                ..maxLength = 10
                ..regex = numberRegExp)
          ..placeholderEn = 'Contact Number'
          ..placeholderTe = 'Contact Number'
          ..onDatachnage = (value) {
            fieldsData['contact_number'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'client_address'
          ..labelEn = 'Residential Address'
          ..labelTe = 'Residential Address'
          ..type = 'textarea'
          ..validation = (FormValidationEntity()..required = true)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Address'
                ..requiredTe = 'Please Enter Address')
          ..placeholderEn = 'Street, Mandal, Village, Gram Panchayat (GP).'
          ..placeholderTe = 'Street, Mandal, Village, Gram Panchayat (GP).'
          ..onDatachnage = (value) {
            final fieldAadhar =
                step2formFields
                    .where((item) => item.name == 'aadhar')
                    .firstOrNull;
            final fieldNumber =
                step2formFields
                    .where((item) => item.name == 'contact_number')
                    .firstOrNull;
            if ((fieldAadhar?.fieldValue ?? '').isEmpty == true &&
                (fieldNumber?.fieldValue ?? '').isEmpty == true) {
              Dialogs.showInfoDialog(
                context,
                PopupType.fail,
                'Please Enter Addar or Contact Number',
              );
              return;
            }
            fieldsData['client_address'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'clientdistrict'
          ..labelEn = 'District'
          ..labelTe = 'District'
          ..type = 'collection'
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Select District'
          ..inputFieldData = {
            'items':
                districts
                    .map(
                      (item) =>
                          NameIDModel.fromDistrictsJson(
                            item as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
          }
          ..onDatachnage = (value) {
            final child =
                step2formFields
                    .where((item) => item.name == 'clientmandal')
                    .firstOrNull;
            if (child != null) {
              child.url = mandalListApiUrl;
              child.urlInputData = {'dist_id': value.id};
              child.inputFieldData = null;
              child.fieldValue = null;
            }
            fieldsData['client_district'] = value.id;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'clientmandal'
          ..labelEn = 'Mandal'
          ..labelTe = 'Mandal'
          ..type = 'collection'
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Select Mandal'
          ..onDatachnage = (value) {
            fieldsData['client_mandal'] = value.id;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'occupation'
          ..labelEn = 'Occupation'
          ..labelTe = 'Occupation'
          ..type = 'collection'
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Select Occupation'
          ..lkpChildren = [
            LKPchildrenEntity()
              ..childname = 'otheroccupation'
              ..parentValue = [10],
          ]
          ..inputFieldData = {
            'items':
                occupation
                    .map(
                      (item) =>
                          NameIDModel.fromDistrictsJson(
                            item as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
            'doSort': false,
          }
          ..onDatachnage = (value) {
            if (value.id == 10) {
              final child =
                  step2formFields
                      .where((item) => item.name == 'otheroccupation')
                      .firstOrNull;
              if (child != null) {
                child.isHidden = false;
              }
            } else {
              final child =
                  step2formFields
                      .where((item) => item.name == 'otheroccupation')
                      .firstOrNull;
              if (child != null) {
                child.isHidden = true;
                child.fieldValue = null;
              }
            }
            fieldsData['occupation'] = value.name;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'otheroccupation'
          ..type = 'text'
          ..isHidden = true
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Occupation'
          ..placeholderTe = 'Occupation'
          ..onDatachnage = (value) {
            fieldsData['occupation'] = value.name;
            _onDataChanged(false);
          },
      ]);
    }
    if (consentFormFields.isEmpty) {
      consentFormFields.addAll([
        FormEntity()
          ..name = 'consentheader'
          ..label = 'Consent Details'
          ..type = 'labelheader',
        FormEntity()
          ..name = 'pdfviewer'
          ..type = 'pdfviewer'
          ..inputFieldData = {
            'url':
                isSelectedLocalEn
                    ? 'assets/files/Consent_form_english.pdf'
                    : 'assets/files/Consent_form_telugu.pdf',
            'height': getScrrenSize(context).height * .55,
          },
        FormEntity()
          ..name = 'consent'
          ..type = 'confirmcheck'
          ..validation = (FormValidationEntity()..required = true)
          ..labelEn = 'I consent to check-up & tests'
          ..labelTe = 'I consent to check-up & tests'
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please consent check-up & tests'
                ..requiredTe = 'Please consent check-up & tests')
          ..onDatachnage = (value) {
            fieldsData['consent'] = value ? 1 : 0;
            _onDataChanged(false);
          },
      ]);
    }
    if (step3formFields.isEmpty) {
      step3formFields.addAll([
        FormEntity()
          ..name = 'step3header'
          ..labelEn = 'Medical History & Behaviors'
          ..labelTe = 'Medical History & Behaviors'
          ..type = 'labelheader',
        FormEntity()
          ..name = 'knowndiabetes'
          ..type = 'confirmcheck'
          ..labelEn = 'Known Diabetes'
          ..labelTe = 'Known Diabetes'
          ..onDatachnage = (value) {
            final child =
                step3formFields
                    .where((item) => item.name == 'ontreatmentknowndiabetes')
                    .firstOrNull;
            if (child != null) {
              child.isHidden = !value;
              child.fieldValue = null;
            }
            fieldsData['knowndiabetes'] = value == true ? 1 : 0;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'ontreatmentknowndiabetes'
          ..type = 'confirmcheck'
          ..verticalSpace = 0
          ..horizontalSpace = 25
          ..labelEn = 'On Treatment'
          ..labelTe = 'On Treatment'
          ..isHidden = true
          ..onDatachnage = (value) {
            fieldsData['ontreatmentknowndiabetes'] = value == true ? 1 : 0;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'knownhtn'
          ..type = 'confirmcheck'
          ..labelEn = 'Known HTN'
          ..labelTe = 'Known HTN'
          ..onDatachnage = (value) {
            final child =
                step3formFields
                    .where((item) => item.name == 'ontreatmentknownhtn')
                    .firstOrNull;
            if (child != null) {
              child.isHidden = !value;
              child.fieldValue = null;
            }
            fieldsData['knownhtn'] = value == true ? 1 : 0;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'ontreatmentknownhtn'
          ..type = 'confirmcheck'
          ..verticalSpace = 0
          ..horizontalSpace = 25
          ..labelEn = 'On Treatment'
          ..labelTe = 'On Treatment'
          ..isHidden = true
          ..onDatachnage = (value) {
            fieldsData['ontreatmentknownhtn'] = value == true ? 1 : 0;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'knownhepatitis'
          ..type = 'confirmcheck'
          ..labelEn = 'Known Hepatitis'
          ..labelTe = 'Known Hepatitis'
          ..onDatachnage = (value) {
            final child =
                step3formFields
                    .where((item) => item.name == 'ontreatmentknownhepatitis')
                    .firstOrNull;
            if (child != null) {
              child.isHidden = !value;
              child.fieldValue = null;
            }
            fieldsData['knownhepatitis'] = value == true ? 1 : 0;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'ontreatmentknownhepatitis'
          ..type = 'confirmcheck'
          ..verticalSpace = 5
          ..horizontalSpace = 25
          ..labelEn = 'On Treatment'
          ..labelTe = 'On Treatment'
          ..isHidden = true
          ..onDatachnage = (value) {
            fieldsData['ontreatmentknownhepatitis'] = value == true ? 1 : 0;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'tobaccouse'
          ..type = 'confirmcheck'
          ..labelEn = 'Tobacco use'
          ..labelTe = 'Tobacco use'
          ..onDatachnage = (value) {
            fieldsData['tobaccouse'] = value ? 1 : 0;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'alcoholuse'
          ..type = 'confirmcheck'
          ..labelEn = 'Alcohol use'
          ..labelTe = 'Alcohol use'
          ..onDatachnage = (value) {
            fieldsData['alcoholuse'] = value ? 1 : 0;
            _onDataChanged(false);
          },
      ]);
    }
    if (step4formFields.isEmpty) {
      step4formFields.addAll([
        FormEntity()
          ..name = 'step4header'
          ..labelEn = 'NCD Screening'
          ..labelTe = 'NCD Screening'
          ..type = 'labelheader',
        FormEntity()
          ..name = 'hypertension'
          ..type = 'ncdscreening'
          ..labelEn = 'Hypertension'
          ..labelTe = 'Hypertension'
          ..inputFieldData = [
            {'label': 'Screened', 'value': false},
            {'label': 'Abnormal', 'value': false},
            {'label': 'Referred', 'value': false},
          ]
          ..onDatachnage = (value) {
            fieldsData['hypertension'] = value;
          },
        FormEntity()
          ..name = 'diabetes'
          ..type = 'ncdscreening'
          ..labelEn = 'Diabetes'
          ..labelTe = 'Diabetes'
          ..inputFieldData = [
            {'label': 'Screened', 'value': false},
            {'label': 'Abnormal', 'value': false},
            {'label': 'Referred', 'value': false},
          ]
          ..onDatachnage = (value) {
            fieldsData['diabetes'] = value;
          },
        FormEntity()
          ..name = 'oralcancer'
          ..type = 'ncdscreening'
          ..labelEn = 'Oral Cancer'
          ..labelTe = 'Oral Cancer'
          ..inputFieldData = [
            {'label': 'Screened', 'value': false},
            {'label': 'Abnormal', 'value': false},
            {'label': 'Referred', 'value': false},
          ]
          ..onDatachnage = (value) {
            fieldsData['oral'] = value;
          },
        FormEntity()
          ..name = 'breastcancer'
          ..type = 'ncdscreening'
          ..labelEn = 'Breast Cancer'
          ..labelTe = 'Breast Cancer'
          ..inputFieldData = [
            {'label': 'Screened', 'value': false},
            {'label': 'Abnormal', 'value': false},
            {'label': 'Referred', 'value': false},
          ]
          ..onDatachnage = (value) {
            fieldsData['breast'] = value;
          },
        FormEntity()
          ..name = 'cervicalcancer'
          ..type = 'ncdscreening'
          ..labelEn = 'Cervical Cancer'
          ..labelTe = 'Cervical Cancer'
          ..inputFieldData = [
            {'label': 'Screened', 'value': false},
            {'label': 'Abnormal', 'value': false},
            {'label': 'Referred', 'value': false},
          ]
          ..onDatachnage = (value) {
            fieldsData['cervical'] = value;
          },
      ]);
    }
    if (step5formFields.isEmpty) {
      step5formFields.addAll([
        FormEntity()
          ..name = 'step5header'
          ..labelEn = 'HIV Screening'
          ..labelTe = 'HIV Screening'
          ..type = 'labelheader',
        FormEntity()
          ..name = 'rapidscreeningoffered'
          ..type = 'confirmcheck'
          ..labelEn = 'Rapid Screening Offered?'
          ..labelTe = 'Rapid Screening Offered'
          ..onDatachnage = (value) {
            final child =
                step5formFields
                    .where((item) => item.name == 'hiveresult')
                    .firstOrNull;
            if (child != null) {
              child.isHidden = !value;
              child.fieldValue = null;
            }
            fieldsData['hiv'] = {};
            fieldsData['hiv']['offered'] = value ? 1 : 0;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'hiveresult'
          ..labelEn = 'Result'
          ..labelTe = 'Result'
          ..type = 'collection'
          ..isHidden = true
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Select Result'
          ..inputFieldData = {
            'items':
                [
                      {'id': '1', 'name': 'Reactive'},
                      {'id': '2', 'name': 'Non‑Reactive'},
                      {'id': '3', 'name': 'Not Done'},
                    ]
                    .map(
                      (item) =>
                          NameIDModel.fromDistrictsJson(
                            item as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
            'doSort': false,
          }
          ..onDatachnage = (value) {
            final child =
                step5formFields
                    .where((item) => item.name == 'referredtoICTC')
                    .firstOrNull;
            if (child != null) {
              if (value.id == 1) {
                child.isHidden = false;
                child.fieldValue = null;
              } else {
                child.isHidden = true;
                child.fieldValue = null;
              }
            }
            fieldsData['hiv']['result'] = value.name;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'referredtoICTC'
          ..type = 'confirmcheck'
          ..labelEn = 'Referred to ICTC?'
          ..labelTe = 'Referred to ICTC?'
          ..isHidden = true
          ..onDatachnage = (value) {
            final child =
                step5formFields
                    .where((item) => item.name == 'confirmedatICTC')
                    .firstOrNull;
            final child2 =
                step5formFields
                    .where((item) => item.name == 'ictcnames')
                    .firstOrNull;
            if (child != null) {
              child.isHidden = !value;
              child.fieldValue = null;
            }
            if (child2 != null) {
              child2.isHidden = !value;
              child2.fieldValue = null;
            }
            fieldsData['hiv']['referredICTC'] = value ? 1 : 0;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'ictcnames'
          ..labelEn = 'ICTC Names'
          ..labelTe = 'ICTC Names'
          ..type = 'collection'
          ..isHidden = true
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Select ICTC Names'
          ..inputFieldData = {
            'items':
                [
                      {'id': '1', 'name': 'ICTC-1'},
                      {'id': '2', 'name': 'ICTC-2'},
                      {'id': '3', 'name': 'ICTC-3'},
                    ]
                    .map(
                      (item) =>
                          NameIDModel.fromDistrictsJson(
                            item as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
            'doSort': false,
          }
          ..onDatachnage = (value) {
            fieldsData['hiv']['nameOfICTC'] = value.name;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'confirmedatICTC'
          ..type = 'confirmcheck'
          ..labelEn = 'Confirmed at ICTC?'
          ..labelTe = 'Confirmed at ICTC?'
          ..isHidden = true
          ..onDatachnage = (value) {
            final childs = step5formFields.where(
              (item) => ['alreadAtART'].contains(item.name),
            );
            for (var child in childs) {
              child.isHidden = !value;
              child.fieldValue = null;
            }
            fieldsData['hiv']['confirmedICTC'] = value ? 1 : 0;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'alreadAtART'
          ..type = 'confirmcheck'
          ..label = 'Already on ART?'
          ..isHidden = true
          ..onDatachnage = (value) {
            final child =
                step5formFields
                    .where((item) => item.name == 'alreadAtARTName')
                    .firstOrNull;

            child?.isHidden = !value;
            child?.fieldValue = null;
            final child2 =
                step5formFields
                    .where((item) => item.name == 'referredtoART')
                    .firstOrNull;
            child2?.isHidden = value;
            child2?.fieldValue = null;
            fieldsData['hiv']['alreadAtART'] = value ? 1 : 0;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'alreadAtARTName'
          ..type = 'text'
          ..placeholder = 'ART Centre Name &amp; ART NO:'
          ..isHidden = true
          ..onDatachnage = (value) {
            fieldsData['hiv']['alreadAtARTName'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'referredtoART'
          ..type = 'confirmcheck'
          ..labelEn = 'Referred to ART?'
          ..labelTe = 'Referred to ART?'
          ..isHidden = true
          ..onDatachnage = (value) {
            fieldsData['hiv']['referredART'] = value ? 1 : 0;
            _onDataChanged(false);
          },
      ]);
    }
    if (indexTestingFormFields.isEmpty) {
      indexTestingFormFields.addAll([
        FormEntity()
          ..name = 'indexTestingheader'
          ..label = 'Offered Index (Spouse/Partner/Biological children)'
          ..type = 'labelheader',
        FormEntity()
          ..name = 'partnertesting'
          ..labelEn = 'Partner Testing'
          ..labelTe = 'Partner Testing'
          ..type = 'collection'
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Select Partner Testing'
          ..inputFieldData = {
            'items':
                [
                      {'id': '1', 'name': 'Yes'},
                      {'id': '2', 'name': 'No'},
                      {'id': '2', 'name': 'N/A'},
                    ]
                    .map(
                      (item) =>
                          NameIDModel.fromDistrictsJson(
                            item as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
            'doSort': false,
          }
          ..onDatachnage = (value) {
            final child =
                indexTestingFormFields
                    .where((item) => item.name == 'partnertestno')
                    .firstOrNull;
            final child2 =
                indexTestingFormFields
                    .where((item) => item.name == 'agreedtosharepartnerdetails')
                    .firstOrNull;
            if (child != null) {
              child.isHidden = !(value.id != 1);
              child.fieldValue = null;
            }
            if (child2 != null) {
              child2.isHidden = !(value.id == 1);
              child2.fieldValue = null;
            }
            fieldsData['hiv']?['partnertesting'] = value.name;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'partnertestno'
          ..label = 'Reason'
          ..placeholder = 'Reason'
          ..type = 'text'
          ..isHidden = true
          ..onDatachnage = (value) {
            fieldsData['hiv']['partnertestno'] = value;
            _onDataChanged(true);
          },

        FormEntity()
          ..name = 'agreedtosharepartnerdetails'
          ..type = 'confirmcheck'
          ..label = 'Agreed to share partner details?'
          ..isHidden = true
          ..onDatachnage = (value) {
            final childs = indexTestingFormFields.where(
              (item) => [
                'partnername',
                'partnerrelationship',
                'partnermobile',
              ].contains(item.name),
            );
            for (var child in childs) {
              child.isHidden = !value;
              child.fieldValue = null;
            }
            fieldsData['hiv']['agreedtosharepartnerdetails'] = value ? 1 : 0;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'partnername'
          ..isHidden = true
          ..labelEn = 'Partner Name'
          ..labelTe = 'Partner Name'
          ..type = 'text'
          ..validation =
              (FormValidationEntity()
                ..required = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Partner Name'
                ..requiredTe = 'Please Enter Partner Name'
                ..regexEn = 'Please Enter Valid Partner Name'
                ..regexTe = 'Please Enter Valid Partner Name')
          ..placeholderEn = 'Partner Name'
          ..placeholderTe = 'Partner Name'
          ..onDatachnage = (value) {
            fieldsData['hiv']['partnerName'] = value;
            _onDataChanged(false);
          },

        FormEntity()
          ..name = 'partnerrelationship'
          ..isHidden = true
          ..labelEn = 'Partner Relationship'
          ..labelTe = 'Partner Relationship'
          ..type = 'collection'
          ..validation = (FormValidationEntity()..required = true)
          ..placeholderEn = 'Select Partner Relationship'
          ..inputFieldData = {
            'items':
                [
                      {'id': '1', 'name': 'Spouse'},
                      {'id': '2', 'name': 'Partner'},
                      {'id': '3', 'name': 'Biological children'},
                    ]
                    .map(
                      (item) =>
                          NameIDModel.fromDistrictsJson(
                            item as Map<String, dynamic>,
                          ).toEntity(),
                    )
                    .toList(),
            'doSort': false,
          }
          ..onDatachnage = (value) {
            fieldsData['hiv']['partnerMandal'] = value.id;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'partnermobile'
          ..isHidden = true
          ..labelEn = 'Partner Mobile'
          ..labelTe = 'Partner Mobile'
          ..type = 'number'
          ..validation =
              (FormValidationEntity()
                ..required = true
                ..regex = numberRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Partner Mobile'
                ..requiredTe = 'Please Enter Partner Mobile'
                ..regexEn = 'Please Enter Valid Partner Mobile'
                ..regexTe = 'Please Enter Valid Partner Mobile')
          ..placeholderEn = 'Partner Mobile'
          ..placeholderTe = 'Partner Mobile'
          ..onDatachnage = (value) {
            fieldsData['hiv']['partnermobile'] = value;
            _onDataChanged(false);
          },
      ]);
    }
    fieldsData['sti'] ??= {};
    fieldsData['sti']['syphilis'] = {'done': 0, 'result': 'Non-Reactive'};
    fieldsData['sti']['hepB'] = {'done': 0, 'result': 'Non-Reactive'};
    fieldsData['sti']['hepC'] = {'done': 0, 'result': 'Non-Reactive'};
    if (step6formFields.isEmpty) {
      step6formFields.addAll([
        FormEntity()
          ..name = 'step7header'
          ..labelEn = 'Other Screening'
          ..labelTe = 'STI Screening'
          ..type = 'labelheader',
        FormEntity()
          ..name = 'syphilis'
          ..type = 'listcheckbox'
          ..labelEn = 'Syphilis'
          ..labelTe = 'Syphilis'
          ..fieldValue = {'done': 0, 'result': 'Non-Reactive'}
          ..inputFieldData = [
            {'label': 'Done', 'value': false},
            {'label': 'Result', 'value': false, 'type': 'collection'},
          ]
          ..onDatachnage = (value) {
            fieldsData['sti'] ??= {};
            fieldsData['sti']['syphilis'] = value;
          },
        FormEntity()
          ..name = 'hepatitisB'
          ..type = 'listcheckbox'
          ..labelEn = 'Hepatitis-B'
          ..labelTe = 'Hepatitis-B'
          ..fieldValue = {'done': 0, 'result': 'Non-Reactive'}
          ..inputFieldData = [
            {'label': 'Done', 'value': false},
            {'label': 'Result', 'value': false, 'type': 'collection'},
          ]
          ..onDatachnage = (value) {
            fieldsData['sti'] ??= {};
            fieldsData['sti']['hepB'] = value;
          },
        FormEntity()
          ..name = 'hepatitisC'
          ..type = 'listcheckbox'
          ..labelEn = 'Hepatitis-C'
          ..labelTe = 'Hepatitis-C'
          ..fieldValue = {'done': 0, 'result': 'Non-Reactive'}
          ..inputFieldData = [
            {'label': 'Done', 'value': false},
            {'label': 'Result', 'value': false, 'type': 'collection'},
          ]
          ..onDatachnage = (value) {
            fieldsData['sti'] ??= {};
            fieldsData['sti']['hepC'] = value;
          },

        FormEntity()
          ..name = 'notes'
          ..type = 'textarea'
          ..labelEn = 'Notes'
          ..labelTe = 'Notes'
          ..placeholderEn = 'Remarks / Notes'
          ..placeholderTe = 'Remarks / Notes'
          ..onDatachnage = (value) {
            fieldsData['remarks'] = value;
            _onDataChanged(false);
          },
      ]);
    }
    return [
      step1formFields,
      referralFormFields,
      step2formFields,
      consentFormFields,
      step3formFields,
      step4formFields,
      step5formFields,
      indexTestingFormFields,
      step6formFields,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    List<String> stepButtonTexts = [
      'Next',
      'Next',
      'Next',
      'Next',
      'Next',
      'Next',
      'Next',
      'Next',
      'Next',
      'Submit',
      resources.string.submit,
    ];
    final formFields = _getFormFields(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Dialogs.showDialogWithClose(
            context,
            DiscardChangesDialog(
              data: {
                'title': 'Discard Changes',
                'description': 'Do you want to discard this details',
                'action': 'Proceed',
              },
              callback: () {
                Navigator.pop(context);
              },
            ),
          );
        }
      },
      child: SafeArea(
        bottom: true,
        child: Scaffold(
          body: Container(
            color: resources.color.colorWhite,
            child: Column(
              children: [
                MSearchUserAppBarWidget(
                  title: 'Integrated Health Services (IHS)',
                  showBack: true,
                ),
                ValueListenableBuilder(
                  valueListenable: _stepNotifier,
                  builder: (context, step, child) {
                    Future.delayed(Duration.zero, () {
                      _doDatavalidation.value = !_doDatavalidation.value;
                    });
                    return StepMetterWidget(
                      stepCount: stepCount,
                      currentStep: step,
                    );
                  },
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _doFormRefresh,
                    builder: (context, doFormRefresh, child) {
                      final currentStepFormFields =
                          formFields[_stepNotifier.value - 1];
                      return Form(
                        key: _formKey,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: resources.dimen.dp20,
                          ),
                          itemBuilder: (context, index) {
                            return currentStepFormFields[index].getWidget(
                              context,
                            );
                          },
                          itemCount: currentStepFormFields.length,
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: resources.dimen.dp20),
                ValueListenableBuilder(
                  valueListenable: _doDatavalidation,
                  builder: (context, value, child) {
                    bool isDataValid = true;
                    if (isDataValid) {
                      for (var field in formFields[_stepNotifier.value - 1]) {
                        if ((field.fieldValue ?? '').toString().isEmpty &&
                            field.validation?.required == true &&
                            field.isHidden != true) {
                          isDataValid = false;
                          break;
                        }
                      }
                    }
                    var isLastStep = _stepNotifier.value == stepCount;
                    if (_stepNotifier.value == 4) {
                      final field =
                          consentFormFields
                              .where((item) => item.name == 'consent')
                              .firstOrNull;
                      if (field != null) {
                        isLastStep = field.fieldValue != true;
                      }
                    }
                    final nexButtonText =
                        isLastStep
                            ? resources.string.submit
                            : stepButtonTexts[_stepNotifier.value - 1];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_stepNotifier.value > 1) ...[
                          InkWell(
                            onTap: () {
                              _stepNotifier.value = _stepNotifier.value - 1;
                              _doFormRefresh.value = !_doFormRefresh.value;
                            },
                            child: ActionButtonWidget(
                              text: 'Previous',
                              width: 110,
                              padding: EdgeInsets.symmetric(
                                horizontal: context.resources.dimen.dp20,
                                vertical: context.resources.dimen.dp7,
                              ),
                            ),
                          ),
                          SizedBox(width: resources.dimen.dp10),
                        ],
                        InkWell(
                          onTap: () async {
                            if (!isDataValid ||
                                _formKey.currentState?.validate() != true) {
                              return;
                            }

                            if (!isLastStep) {
                              _stepNotifier.value = _stepNotifier.value + 1;
                              _doFormRefresh.value = !_doFormRefresh.value;
                            } else {
                              Dialogs.showContentHeightBottomSheetDialog(
                                context,
                                DiscardChangesDialog(
                                  data: {
                                    'title': 'Alert',
                                    'description':
                                        'Do you want to submit this details',
                                    'action': 'Proceed',
                                  },
                                  callback: () async {
                                    final requestParams = {
                                      "action": "insert",
                                      "date_of_camp":
                                          fieldsData['date_of_camp'],
                                      "mandal": fieldsData['mandal'],
                                      "district": fieldsData['district'],
                                      "camp_location":
                                          fieldsData['camp_location'],
                                      "state": "Andhra Pradesh",
                                      "first_name": fieldsData['first_name'],
                                      "last_name": fieldsData['last_name'],
                                      "age": fieldsData['age'],
                                      "sex": fieldsData['sex'],
                                      "contact_number":
                                          fieldsData['contact_number'],
                                      "aadher_number":
                                          fieldsData['aadher_number'],
                                      "client_address":
                                          fieldsData['client_address'],
                                      "client_mandal":
                                          fieldsData['client_mandal'],
                                      "occupation": fieldsData['occupation'],
                                      "consent": fieldsData['consent'],
                                      "medHistory": {
                                        "Diabetes":
                                            fieldsData['knowndiabetes'] ?? 0,
                                        "HTN": fieldsData['knownhtn'] ?? 0,
                                        "Hepatitis":
                                            fieldsData['knownhepatitis'] ?? 0,
                                      },
                                      "onTreatment": {
                                        "Diabetes":
                                            fieldsData['ontreatmentknowndiabetes'] ??
                                            0,
                                        "HTN":
                                            fieldsData['ontreatmentknownhtn'] ??
                                            0,
                                        "Hepatitis":
                                            fieldsData['ontreatmentknownhepatitis'] ??
                                            0,
                                      },
                                      "tobacco_user":
                                          fieldsData['tobaccouse'] ?? 0,
                                      "alcohol_user":
                                          fieldsData['alcoholuse'] ?? 0,
                                      "ncd": {
                                        "hypertension":
                                            fieldsData['hypertension'] ??
                                            {
                                              'screened': 0,
                                              'abnormal': 0,
                                              'referred': 0,
                                            },
                                        "diabetes":
                                            fieldsData['diabetes'] ??
                                            {
                                              'screened': 0,
                                              'abnormal': 0,
                                              'referred': 0,
                                            },
                                        "oral":
                                            fieldsData['oralcancer'] ??
                                            {
                                              'screened': 0,
                                              'abnormal': 0,
                                              'referred': 0,
                                            },
                                        "breast":
                                            fieldsData['breastcancer'] ??
                                            {
                                              'screened': 0,
                                              'abnormal': 0,
                                              'referred': 0,
                                            },
                                        "cervical":
                                            fieldsData['cervicalcancer'] ??
                                            {
                                              'screened': 0,
                                              'abnormal': 0,
                                              'referred': 0,
                                            },
                                      },
                                      "hiv": fieldsData['hiv'],
                                      "sti": fieldsData['sti'],
                                      "remarks": fieldsData['remarks'],
                                    };
                                    jsonEncode(requestParams);
                                    Dialogs.loader(context);
                                    final response = await sl<ServicesBloc>()
                                        .submitData(
                                          requestParams: requestParams,
                                        );

                                    if (!context.mounted) {
                                      return;
                                    }
                                    Dialogs.dismiss(context);
                                    //if (response is ServicesStateSuccess) {
                                    Dialogs.showInfoDialog(
                                      context,
                                      PopupType.success,
                                      'Successfully Submitted',
                                    ).then((value) {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    });
                                    // } else if (response
                                    //     is ServicesStateApiError) {
                                    //   Dialogs.showInfoDialog(
                                    //     context,
                                    //     PopupType.fail,
                                    //     response.message,
                                    //   );
                                    // }
                                  },
                                ),
                              );
                            }
                          },
                          child: ActionButtonWidget(
                            text: nexButtonText,
                            width: 120,
                            color:
                                isDataValid
                                    ? resources.color.viewBgColor
                                    : resources.iconBgColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.resources.dimen.dp20,
                              vertical: context.resources.dimen.dp7,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: resources.dimen.dp20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
