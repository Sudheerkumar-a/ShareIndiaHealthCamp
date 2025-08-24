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
import 'package:shareindia_health_camp/domain/entities/screening_entity.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
import 'package:shareindia_health_camp/domain/entities/user_credentials_entity.dart';
import 'package:shareindia_health_camp/injection_container.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/discard_changes_dialog_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/step_meter_widget.dart';
import 'package:shareindia_health_camp/presentation/utils/dialogs.dart';
import 'package:shareindia_health_camp/res/drawables/drawable_assets.dart';

class OutreachCampFormScreen extends StatefulWidget {
  static start(
    BuildContext context, {
    ScreeningDetailsEntity? screeningDetails,
  }) {
    Navigator.of(context, rootNavigator: true).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: OutreachCampFormScreen(screeningDetails: screeningDetails),
      ),
    );
  }

  final ScreeningDetailsEntity? screeningDetails;
  const OutreachCampFormScreen({this.screeningDetails, super.key});

  @override
  State<OutreachCampFormScreen> createState() => _OutreachCampFormScreenState();
}

class _OutreachCampFormScreenState extends State<OutreachCampFormScreen> {
  final ValueNotifier<int> _stepNotifier = ValueNotifier(1);

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

  final stepCount = 7;

  _onDataChanged(bool doRefresh) {
    Future.delayed(Duration(milliseconds: 500), () {
      _formKey.currentState?.validate();
    });
    _doDatavalidation.value = !_doDatavalidation.value;
    if (doRefresh) {
      setState(() {});
    }
  }

  List<List<FormEntity>> _getFormFields(BuildContext context) {
    final resources = context.resources;
    if (step1formFields.isEmpty) {
      final campLocations =
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
              .toList();
      final selectedCamp =
          campLocations
              .where(
                (e) =>
                    (e.name?.toLowerCase() ==
                        (fieldsData['camp_location'] ??
                            UserCredentialsEntity.details(
                              context,
                            ).user?.mandal?.toLowerCase())) ||
                    (e.id ==
                        (int.tryParse(fieldsData['camp_location'] ?? '0'))),
              )
              .firstOrNull;
      final selectedDistrict =
          NameIDModel.fromDistrictsJson(
            districts
                .where(
                  (e) =>
                      e['name']?.toLowerCase() ==
                          UserCredentialsEntity.details(
                            context,
                          ).user?.district?.toLowerCase() ||
                      e['id']?.toLowerCase() ==
                          UserCredentialsEntity.details(
                            context,
                          ).user?.district?.toLowerCase(),
                )
                .first,
          ).toEntity();
      fieldsData['district'] = selectedDistrict.id;
      sl<ServicesBloc>()
          .getFieldInputData(
            apiUrl: mandalListApiUrl,
            requestParams: {'dist_id': selectedDistrict.id},
            requestModel: ListModel.fromMandalJson,
          )
          .then((response) {
            if (response is ServicesStateSuccess) {
              final items =
                  ((response).responseEntity.entity as ListEntity).items
                      .map((item) => item as NameIDEntity)
                      .toList();
              final mandal =
                  items
                      .where(
                        (e) =>
                            (e.name?.toLowerCase() ==
                                (fieldsData['mandal'] ??
                                    UserCredentialsEntity.details(
                                      context,
                                    ).user?.mandal?.toLowerCase())) ||
                            (e.id ==
                                (int.tryParse(fieldsData['mandal'] ?? '0'))),
                      )
                      .firstOrNull;
              final child =
                  step1formFields
                      .where((item) => item.name == 'mandal')
                      .firstOrNull;
              child?.inputFieldData = {'items': items};
              child?.fieldValue = mandal;
              fieldsData['mandal'] = mandal?.id;
              _onDataChanged(true);
            }
          });
      fieldsData['date_of_camp'] =
          fieldsData['date_of_camp'] ??
          getDateByformat('dd/MM/yyyy', DateTime.now());
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
          ..placeholderEn = 'dd/MM/yyyy'
          ..fieldValue = fieldsData['date_of_camp']
          ..validation = (FormValidationEntity()..isRequired = true)
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
          ..validation = (FormValidationEntity()..isRequired = true)
          ..placeholderEn = 'Select District'
          ..fieldValue = selectedDistrict
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
          ..validation = (FormValidationEntity()..isRequired = true)
          ..placeholderEn = 'Select Mandal'
          ..onDatachnage = (value) {
            fieldsData['mandal'] = value.id;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'village'
          ..labelEn = 'Village'
          ..labelTe = 'Village'
          ..type = 'text'
          // ..inputFieldData = {
          //   'items':
          //       [
          //             {'id': 1, 'name': 'Village1'},
          //             {'id': 2, 'name': 'Village2'},
          //             {'id': 3, 'name': 'Village3'},
          //             {'id': 4, 'name': 'Village4'},
          //           ]
          //           .map(
          //             (item) =>
          //                 NameIDModel.fromDistrictsJson(
          //                   item as Map<String, dynamic>,
          //                 ).toEntity(),
          //           )
          //           .toList(),
          // }
          ..fieldValue = fieldsData['village']
          ..validation =
              (FormValidationEntity()
                ..isRequired = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Village'
                ..requiredTe = 'Please Enter Village'
                ..regexEn = 'Please Enter Valid Village'
                ..regexTe = 'Please Enter Valid Village')
          ..placeholderEn = 'Enter Village'
          ..onDatachnage = (value) {
            fieldsData['village'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'camp_location'
          ..label = resources.string.locationoftheCamp
          ..type = 'collection'
          ..validation =
              (FormValidationEntity()
                ..isRequired = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Camp Village / Location'
                ..requiredTe = 'Please Enter Camp Village / Location'
                ..regexEn = 'Please Enter Valid Camp Village / Location'
                ..regexTe = 'Please Enter Valid Camp Village / Location')
          ..placeholderEn = 'Camp Village / Location'
          ..placeholderTe = 'Camp Village / Location'
          ..fieldValue = selectedCamp
          ..inputFieldData = {'items': campLocations, 'doSort': false}
          ..onDatachnage = (value) {
            // final child =
            //     step1formFields
            //         .where((item) => item.name == 'camp_location_other')
            //         .firstOrNull;
            // if (value.id == 6) {
            //   if (child != null) {
            //     child.isHidden = false;
            //   }
            // } else {
            //   if (child != null) {
            //     child.isHidden = true;
            //     child.fieldValue = null;
            //   }
            // }
            fieldsData['camp_location'] = value.name;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'camp_location_other'
          ..type = 'text'
          ..validation =
              (FormValidationEntity()
                ..isRequired = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Camp Village / Location'
                ..requiredTe = 'Please Enter Camp Village / Location'
                ..regexEn = 'Please Enter Valid Camp Village / Location'
                ..regexTe = 'Please Enter Valid Camp Village / Location')
          ..label = 'Camp Village / Location'
          ..placeholderEn = 'Camp Village / Location'
          ..placeholderTe = 'Camp Village / Location'
          ..fieldValue = fieldsData['camp_location']
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
                ..isRequired = true
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
                ..isRequired = true
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
                ..isRequired = true
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
      final selectedOccupation =
          occupation
              .where(
                (e) =>
                    (e.name?.toLowerCase() ==
                        (fieldsData['occupation'] ?? '')
                            .toString()
                            .toLowerCase()),
              )
              .firstOrNull;
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
          ..fieldValue = fieldsData['first_name']
          ..validation =
              (FormValidationEntity()
                ..isRequired = true
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
                ..isRequired = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Surname'
                ..requiredTe = 'Please Enter Surname'
                ..regexEn = 'Please Enter Valid Surname'
                ..regexTe = 'Please Enter Valid Surname')
          ..placeholderEn = 'Surname'
          ..placeholderTe = 'Surname'
          ..fieldValue = fieldsData['last_name']
          ..onDatachnage = (value) {
            fieldsData['last_name'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'age'
          ..type = 'number'
          ..validation =
              (FormValidationEntity()
                ..isRequired = true
                ..max = 100)
          ..messages =
              (FormMessageEntity()
                ..maxEn = 'please enter age below 100'
                ..maxTe = 'please enter age below 100')
          ..placeholderEn = 'Age'
          ..placeholderTe = 'Age'
          ..labelEn = 'Age'
          ..labelTe = 'Age'
          ..fieldValue = fieldsData['age']
          ..onDatachnage = (value) {
            fieldsData['age'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'sex'
          ..labelEn = 'Sex'
          ..labelTe = 'Sex'
          ..type = 'collection'
          ..validation = (FormValidationEntity()..isRequired = true)
          ..placeholderEn = 'Select Sex'
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'please Select Sex'
                ..requiredTe = 'please Select Sex')
          ..inputFieldData = {'items': gender, 'doSort': false}
          ..fieldValue =
              gender.where((e) => e.name == fieldsData['sex']).firstOrNull
          ..onDatachnage = (value) {
            final child1 =
                step2formFields
                    .where((item) => ['pregnancystatus'].contains(item.name))
                    .firstOrNull;
            child1?.isHidden = value.id != 2;
            child1?.fieldValue = null;
            final child2 =
                step2formFields
                    .where((item) => ['date_of_LMP'].contains(item.name))
                    .firstOrNull;
            child2?.isHidden = true;
            child2?.fieldValue = null;
            fieldsData['sex'] = value.name;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'pregnancystatus'
          ..type = 'confirmcheck'
          ..verticalSpace = 0
          ..horizontalSpace = 0
          ..labelEn = 'Pregnancy status'
          ..labelTe = 'Pregnancy status'
          ..isHidden = fieldsData['sex'] == 'F'
          ..fieldValue = fieldsData['pregnancystatus']
          ..onDatachnage = (value) {
            final child =
                step2formFields
                    .where((item) => item.name == 'date_of_LMP')
                    .firstOrNull;
            child?.isHidden = !value;
            fieldsData['pregnancystatus'] = value == true ? 1 : 0;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'date_of_LMP'
          ..labelEn = 'Date of LMP'
          ..labelTe = 'Date of LMP'
          ..type = 'date'
          ..isHidden = fieldsData['pregnancystatus'] != 1
          ..placeholderEn = 'dd/MM/yyyy'
          ..validation = (FormValidationEntity()..isRequired = true)
          ..messages =
              (FormMessageEntity()..requiredEn = 'Please Enter Date of LMP')
          ..suffixIcon = DrawableAssets.icCalendar
          ..fieldValue = fieldsData['date_of_LMP']
          ..onDatachnage = (value) {
            fieldsData['date_of_LMP'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'maritalstatus'
          ..label = 'Marital status'
          ..type = 'collection'
          ..validation = (FormValidationEntity()..isRequired = true)
          ..placeholderEn = 'Select Marital status'
          ..inputFieldData = {'items': maritalStatus, 'doSort': false}
          ..fieldValue =
              maritalStatus
                  .where((e) => e.name == fieldsData['maritalstatus'])
                  .firstOrNull
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
          ..fieldValue = fieldsData['aadher_number']
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
          ..fieldValue = fieldsData['contact_number']
          ..onDatachnage = (value) {
            fieldsData['contact_number'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'client_address'
          ..labelEn = 'Residential Address'
          ..labelTe = 'Residential Address'
          ..type = 'textarea'
          ..validation = (FormValidationEntity()..isRequired = true)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Address'
                ..requiredTe = 'Please Enter Address')
          ..placeholderEn = 'Street, Mandal, Village, Gram Panchayat (GP).'
          ..placeholderTe = 'Street, Mandal, Village, Gram Panchayat (GP).'
          ..fieldValue = fieldsData['client_address']
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
          ..validation = (FormValidationEntity()..isRequired = true)
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
          ..validation = (FormValidationEntity()..isRequired = true)
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
          ..validation = (FormValidationEntity()..isRequired = true)
          ..placeholderEn = 'Select Occupation'
          ..lkpChildren = [
            LKPchildrenEntity()
              ..childname = 'otheroccupation'
              ..parentValue = [10],
          ]
          ..inputFieldData = {'items': occupation, 'doSort': false}
          ..fieldValue = selectedOccupation
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
          ..isHidden = selectedOccupation?.id != 10
          ..validation = (FormValidationEntity()..isRequired = true)
          ..placeholderEn = 'Occupation'
          ..placeholderTe = 'Occupation'
          ..fieldValue = fieldsData['occupation']
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
          ..validation = (FormValidationEntity()..isRequired = true)
          ..labelEn = 'I give my consent'
          ..labelTe = 'I give my consent'
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'I give my consent'
                ..requiredTe = 'I give my consent')
          ..fieldValue = fieldsData['consent'] == 1
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
          ..fieldValue = fieldsData['knowndiabetes'] == 1
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
          ..isHidden = fieldsData['knowndiabetes'] != 1
          ..fieldValue = fieldsData['ontreatmentknowndiabetes'] == 1
          ..onDatachnage = (value) {
            fieldsData['ontreatmentknowndiabetes'] = value == true ? 1 : 0;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'knownhtn'
          ..type = 'confirmcheck'
          ..labelEn = 'Known HTN'
          ..labelTe = 'Known HTN'
          ..fieldValue = fieldsData['knownhtn'] == 1
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
          ..isHidden = fieldsData['knownhtn'] != 1
          ..fieldValue = fieldsData['ontreatmentknownhtn'] == 1
          ..onDatachnage = (value) {
            fieldsData['ontreatmentknownhtn'] = value == true ? 1 : 0;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'knownhepatitis'
          ..type = 'confirmcheck'
          ..labelEn = 'Known Hepatitis'
          ..labelTe = 'Known Hepatitis'
          ..fieldValue = fieldsData['knownhepatitis'] == 1
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
          ..isHidden = fieldsData['knownhepatitis'] != 1
          ..fieldValue = fieldsData['ontreatmentknownhepatitis'] == 1
          ..onDatachnage = (value) {
            fieldsData['ontreatmentknownhepatitis'] = value == true ? 1 : 0;
            _onDataChanged(false);
          },
        // FormEntity()
        //   ..name = 'tobaccouse'
        //   ..type = 'confirmcheck'
        //   ..labelEn = 'Tobacco use'
        //   ..labelTe = 'Tobacco use'
        //   ..onDatachnage = (value) {
        //     fieldsData['tobaccouse'] = value ? 1 : 0;
        //     _onDataChanged(false);
        //   },
        // FormEntity()
        //   ..name = 'alcoholuse'
        //   ..type = 'confirmcheck'
        //   ..labelEn = 'Alcohol use'
        //   ..labelTe = 'Alcohol use'
        //   ..onDatachnage = (value) {
        //     fieldsData['alcoholuse'] = value ? 1 : 0;
        //     _onDataChanged(false);
        //   },
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
          ..fieldValue = fieldsData['hypertension']
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
          ..fieldValue = fieldsData['diabetes']
          ..onDatachnage = (value) {
            fieldsData['diabetes'] = value;
          },
        // FormEntity()
        //   ..name = 'oralcancer'
        //   ..type = 'ncdscreening'
        //   ..labelEn = 'Oral Cancer'
        //   ..labelTe = 'Oral Cancer'
        //   ..inputFieldData = [
        //     {'label': 'Screened', 'value': false},
        //     {'label': 'Abnormal', 'value': false},
        //     {'label': 'Referred', 'value': false},
        //   ]
        //   ..onDatachnage = (value) {
        //     fieldsData['oral'] = value;
        //   },
        // FormEntity()
        //   ..name = 'breastcancer'
        //   ..type = 'ncdscreening'
        //   ..labelEn = 'Breast Cancer'
        //   ..labelTe = 'Breast Cancer'
        //   ..inputFieldData = [
        //     {'label': 'Screened', 'value': false},
        //     {'label': 'Abnormal', 'value': false},
        //     {'label': 'Referred', 'value': false},
        //   ]
        //   ..onDatachnage = (value) {
        //     fieldsData['breast'] = value;
        //   },
        // FormEntity()
        //   ..name = 'cervicalcancer'
        //   ..type = 'ncdscreening'
        //   ..labelEn = 'Cervical Cancer'
        //   ..labelTe = 'Cervical Cancer'
        //   ..inputFieldData = [
        //     {'label': 'Screened', 'value': false},
        //     {'label': 'Abnormal', 'value': false},
        //     {'label': 'Referred', 'value': false},
        //   ]
        //   ..onDatachnage = (value) {
        //     fieldsData['cervical'] = value;
        //   },
      ]);
    }
    if (step5formFields.isEmpty) {
      final hivResults =
          [
                {'id': '1', 'name': 'Reactive'},
                {'id': '2', 'name': 'Non Reactive'},
                {'id': '3', 'name': 'Not Done'},
              ]
              .map(
                (item) =>
                    NameIDModel.fromDistrictsJson(
                      item as Map<String, dynamic>,
                    ).toEntity(),
              )
              .toList();
      final selectHiv =
          hivResults
              .where((e) => e.name == fieldsData['hiv']?['result'])
              .firstOrNull;
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
          ..fieldValue = fieldsData['hiv']?['offered'] == 1
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
            fieldsData['hiv']?['offered'] = value ? 1 : 0;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'hiveresult'
          ..labelEn = 'Result'
          ..labelTe = 'Result'
          ..type = 'collection'
          ..isHidden = fieldsData['hiv']?['offered'] != 1
          ..validation = (FormValidationEntity()..isRequired = true)
          ..placeholderEn = 'Select Result'
          ..fieldValue = selectHiv
          ..inputFieldData = {'items': hivResults, 'doSort': false}
          ..onDatachnage = (value) {
            final child =
                step5formFields
                    .where((item) => item.name == 'alreadAtART')
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
          ..name = 'alreadAtART'
          ..type = 'confirmcheck'
          ..label = 'Already on ART?'
          ..isHidden = fieldsData['hiv']?['result'] != 'Reactive'
          ..fieldValue = fieldsData['hiv']?['alreadAtART'] == 1
          ..onDatachnage = (value) {
            final child =
                step5formFields
                    .where((item) => item.name == 'alreadAtARTName')
                    .firstOrNull;

            child?.isHidden = !value;
            child?.fieldValue = null;
            final child2 =
                step5formFields
                    .where((item) => item.name == 'referredtoICTC')
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
          ..isHidden = fieldsData['hiv']?['alreadAtART'] != 1
          ..fieldValue = fieldsData['hiv']?['alreadAtARTName']
          ..onDatachnage = (value) {
            fieldsData['hiv']['alreadAtARTName'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'referredtoICTC'
          ..type = 'confirmcheck'
          ..labelEn = 'Referred to ICTC?'
          ..labelTe = 'Referred to ICTC?'
          ..isHidden = fieldsData['hiv']?['alreadAtART'] != 0
          ..fieldValue = fieldsData['hiv']?['referredICTC'] == 1
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
          ..labelEn = 'ICTC Name'
          ..labelTe = 'ICTC Name'
          ..type = 'text'
          ..isHidden = fieldsData['hiv']?['referredICTC'] != 1
          ..validation = (FormValidationEntity()..isRequired = true)
          ..placeholderEn = 'ICTC Name'
          // ..inputFieldData = {
          //   'items':
          //       [
          //             {'id': '1', 'name': 'ICTC-1'},
          //             {'id': '2', 'name': 'ICTC-2'},
          //             {'id': '3', 'name': 'ICTC-3'},
          //           ]
          //           .map(
          //             (item) =>
          //                 NameIDModel.fromDistrictsJson(
          //                   item as Map<String, dynamic>,
          //                 ).toEntity(),
          //           )
          //           .toList(),
          //   'doSort': false,
          // }
          ..fieldValue = fieldsData['hiv']?['nameOfICTC']
          ..onDatachnage = (value) {
            fieldsData['hiv']['nameOfICTC'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'confirmedatICTC'
          ..type = 'confirmcheck'
          ..labelEn = 'Confirmed at ICTC?'
          ..labelTe = 'Confirmed at ICTC?'
          ..isHidden = fieldsData['hiv']?['referredICTC'] != 1
          ..fieldValue = fieldsData['hiv']?['confirmedICTC'] == 1
          ..onDatachnage = (value) {
            final childs = step5formFields.where(
              (item) => ['referredtoART'].contains(item.name),
            );
            for (var child in childs) {
              child.isHidden = !value;
              child.fieldValue = null;
            }
            fieldsData['hiv']['confirmedICTC'] = value ? 1 : 0;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'referredtoART'
          ..type = 'confirmcheck'
          ..labelEn = 'Referred to ART?'
          ..labelTe = 'Referred to ART?'
          ..isHidden = fieldsData['hiv']?['confirmedICTC'] != 1
          ..fieldValue = fieldsData['hiv']?['referredART'] == 1
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
          ..validation = (FormValidationEntity()..isRequired = true)
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
                ..isRequired = true
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
          ..validation = (FormValidationEntity()..isRequired = true)
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
                ..isRequired = true
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
    fieldsData['sti']['syphilis'] ??= {
      'done': 0,
      'result': 'Non Reactive',
      'referred': 0,
    };
    fieldsData['sti']['hepB'] ??= {
      'done': 0,
      'result': 'Non Reactive',
      'referred': 0,
    };
    fieldsData['sti']['hepC'] ??= {
      'done': 0,
      'result': 'Non Reactive',
      'referred': 0,
    };
    if (step6formFields.isEmpty) {
      step6formFields.addAll([
        FormEntity()
          ..name = 'step7header'
          ..labelEn = 'Other Screening'
          ..labelTe = 'STI Screening'
          ..type = 'labelheader',
        FormEntity()
          ..name = 'syndromiccases'
          ..labelEn = 'Syndromic case management'
          ..labelTe = 'Syndromic case management'
          ..type = 'collection'
          ..multi = true
          ..validation = (FormValidationEntity()..isRequired = true)
          ..placeholderEn = 'Select Partner Relationship'
          ..inputFieldData = {
            'items':
                syndromicCases
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
                step6formFields
                    .where((item) => item.name == 'syndromicreferred')
                    .firstOrNull;
            child?.isHidden = (value as List).firstOrNull?.id == 13;
            fieldsData['syndromiccases'] = value;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'syndromicreferred'
          ..type = 'confirmcheck'
          ..labelEn = 'Referred?'
          ..labelTe = 'Referred?'
          ..isHidden = fieldsData['syndromicreferred'] == null
          ..fieldValue = fieldsData['syndromicreferred'] == 1
          ..onDatachnage = (value) {
            fieldsData['syndromicreferred'] = value ? 1 : 0;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'syphilis'
          ..type = 'listcheckbox'
          ..labelEn = 'Syphilis'
          ..labelTe = 'Syphilis'
          ..fieldValue = fieldsData['sti']['syphilis']
          ..inputFieldData = [
            {'label': 'Done', 'value': false},
            {'label': 'Result', 'value': null, 'type': 'collection'},
            {'label': 'Referred?', 'value': null, 'type': 'confirmcheck'},
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
          ..fieldValue = fieldsData['sti']['hepB']
          ..inputFieldData = [
            {'label': 'Done', 'value': false},
            {'label': 'Result', 'value': null, 'type': 'collection'},
            {'label': 'Referred?', 'value': null, 'type': 'confirmcheck'},
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
          ..fieldValue = fieldsData['sti']['hepC']
          ..inputFieldData = [
            {'label': 'Done', 'value': false},
            {'label': 'Result', 'value': null, 'type': 'collection'},
            {'label': 'Referred?', 'value': null, 'type': 'confirmcheck'},
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
          ..fieldValue = fieldsData['remarks']
          ..onDatachnage = (value) {
            fieldsData['remarks'] = value;
            _onDataChanged(false);
          },
      ]);
    }
    return [
      step1formFields,
      //referralFormFields,
      step2formFields,
      consentFormFields,
      step3formFields,
      step4formFields,
      step5formFields,
      //indexTestingFormFields,
      step6formFields,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    fieldsData.addAll(widget.screeningDetails?.toEditJson() ?? {});
    List<String> stepButtonTexts = [
      'Next',
      //'Next',
      'Next',
      'Next',
      'Next',
      'Next',
      'Next',
      //'Next',
      'Next',
      'Submit',
      resources.string.submit,
    ];
    final formFields = _getFormFields(context);

    final currentStepFormFields = formFields[_stepNotifier.value - 1];
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        // if (didPop) {
        //   Dialogs.showDialogWithClose(
        //     context,
        //     DiscardChangesDialog(
        //       data: {
        //         'title': 'Discard Changes',
        //         'description': 'Do you want to discard this details',
        //         'action': 'Proceed',
        //       },
        //       callback: () {
        //         Navigator.pop(context);
        //       },
        //     ),
        //   );
        // }
        if (didPop) return;

        showDialog<bool>(
          context: context,
          builder:
              (context) => DiscardChangesDialog(
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
      },
      child: SafeArea(
        bottom: true,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            color: resources.color.colorWhite,
            child: Column(
              children: [
                MSearchUserAppBarWidget(
                  title: 'Integrated Health Services (IHS) - APSACS',
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
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: resources.dimen.dp20,
                      ),
                      child: Column(
                        children: List.generate(
                          currentStepFormFields.length,
                          (index) => KeyedSubtree(
                            key: ValueKey(
                              currentStepFormFields[index].name,
                            ), // unique identifier
                            child: currentStepFormFields[index].getWidget(
                              context,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                            field.validation?.isRequired == true &&
                            field.isHidden != true) {
                          isDataValid = false;
                          break;
                        }
                      }
                    }
                    var isLastStep = _stepNotifier.value == stepCount;
                    if (_stepNotifier.value == 3) {
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
                              setState(() {});
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
                              setState(() {});
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
                                      "pregnancystatus":
                                          fieldsData['pregnancystatus'],
                                      "date_of_LMP": fieldsData['date_of_LMP'],
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
                                      // "tobacco_user":
                                      //     fieldsData['tobaccouse'] ?? 0,
                                      // "alcohol_user":
                                      //     fieldsData['alcoholuse'] ?? 0,
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
                                        // "oral":
                                        //     fieldsData['oralcancer'] ??
                                        //     {
                                        //       'screened': 0,
                                        //       'abnormal': 0,
                                        //       'referred': 0,
                                        //     },
                                        // "breast":
                                        //     fieldsData['breastcancer'] ??
                                        //     {
                                        //       'screened': 0,
                                        //       'abnormal': 0,
                                        //       'referred': 0,
                                        //     },
                                        // "cervical":
                                        //     fieldsData['cervicalcancer'] ??
                                        //     {
                                        //       'screened': 0,
                                        //       'abnormal': 0,
                                        //       'referred': 0,
                                        //     },
                                      },
                                      "hiv": fieldsData['hiv'],
                                      "syndromiccases":
                                          fieldsData['syndromiccases'] is List
                                              ? (fieldsData['syndromiccases']
                                                  .map(
                                                    (syndrom) => syndrom.name,
                                                  )
                                                  .join(', '))
                                              : '',
                                      "syndromicreferred":
                                          fieldsData['syndromicreferred'],
                                      "sti": fieldsData['sti'],
                                      "remarks": fieldsData['remarks'],
                                    };
                                    jsonEncode(requestParams);
                                    Dialogs.loader(context);
                                    final response = await sl<ServicesBloc>()
                                        .submitData(
                                          apiUrl:
                                              widget.screeningDetails?.id !=
                                                      null
                                                  ? screenEditApiUrl
                                                  : submitApiUrl,
                                          requestParams: requestParams,
                                        );

                                    if (!context.mounted) {
                                      return;
                                    }
                                    Dialogs.dismiss(context);
                                    if (response is ServicesStateSuccess) {
                                      Dialogs.showInfoDialog(
                                        context,
                                        PopupType.success,
                                        'Successfully Submitted',
                                      ).then((value) {
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      });
                                    } else if (response
                                        is ServicesStateApiError) {
                                      Dialogs.showInfoDialog(
                                        context,
                                        PopupType.fail,
                                        response.message,
                                      );
                                    }
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
