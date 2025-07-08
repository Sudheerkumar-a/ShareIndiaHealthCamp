import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/constants/data_constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/field_entity_extension.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/data/remote/api_urls.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
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

  _onDataChanged(bool doRefresh) {
    Future.delayed(Duration(milliseconds: 500), () {
      _formKey.currentState?.validate();
    });
    _doDatavalidation.value = !_doDatavalidation.value;
    if (doRefresh) {
      _doFormRefresh.value = !_doFormRefresh.value;
    }
  }

  List<List<FormEntity>> _getFormFields() {
    final step1formFields = List<FormEntity>.empty(growable: true);
    final step2formFields = List<FormEntity>.empty(growable: true);
    final step3formFields = List<FormEntity>.empty(growable: true);
    final step4formFields = List<FormEntity>.empty(growable: true);
    final step5formFields = List<FormEntity>.empty(growable: true);
    final step6formFields = List<FormEntity>.empty(growable: true);
    final step7formFields = List<FormEntity>.empty(growable: true);
    final step8formFields = List<FormEntity>.empty(growable: true);
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
          _onDataChanged(false);
        },
      FormEntity()
        ..name = 'campvillage'
        ..labelEn = 'Camp Village / Location'
        ..labelTe = 'Camp Village / Location'
        ..type = 'text'
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
          _onDataChanged(false);
        },
    ]);

    step2formFields.addAll([
      FormEntity()
        ..name = 'step2Header'
        ..labelEn = 'Personal Details'
        ..labelTe = 'Personal Details'
        ..type = 'labelheader',
      FormEntity()
        ..name = 'name'
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
          _onDataChanged(false);
        },
      FormEntity()
        ..name = 'surname'
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
          _onDataChanged(false);
        },
      FormEntity()
        ..name = 'adhar'
        ..labelEn = 'Adhar No(optional)'
        ..labelTe = 'Adhar No(optional)'
        ..type = 'number'
        ..validation = (FormValidationEntity()..maxLength = 12)
        ..placeholderEn = 'Adhar No(optional)'
        ..placeholderTe = 'Adhar No(optional)'
        ..onDatachnage = (value) {
          _onDataChanged(false);
        },
      FormEntity()
        ..name = 'mobilenumber'
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
              ..regex = mobileRegExp)
        ..placeholderEn = 'Contact Number'
        ..placeholderTe = 'Contact Number'
        ..onDatachnage = (value) {
          _onDataChanged(false);
        },
      FormEntity()
        ..name = 'address'
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
          _onDataChanged(false);
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
          _onDataChanged(false);
        },
    ]);
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
          _onDataChanged(true);
        },
      FormEntity()
        ..name = 'ontreatmentknowndiabetes'
        ..type = 'confirmcheck'
        ..labelEn = 'On Treatment'
        ..labelTe = 'On Treatment'
        ..isHidden = true
        ..onDatachnage = (value) {
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
          _onDataChanged(true);
        },
      FormEntity()
        ..name = 'ontreatmentknownhtn'
        ..type = 'confirmcheck'
        ..labelEn = 'On Treatment'
        ..labelTe = 'On Treatment'
        ..isHidden = true
        ..onDatachnage = (value) {
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
          _onDataChanged(true);
        },
      FormEntity()
        ..name = 'ontreatmentknownhepatitis'
        ..type = 'confirmcheck'
        ..labelEn = 'On Treatment'
        ..labelTe = 'On Treatment'
        ..isHidden = true
        ..onDatachnage = (value) {
          _onDataChanged(false);
        },
    ]);
    step4formFields.addAll([
      FormEntity()
        ..name = 'step4header'
        ..labelEn = 'Other Comorbidity'
        ..labelTe = 'Other Comorbidity'
        ..type = 'labelheader',
      FormEntity()
        ..name = 'othercomorbidity'
        ..type = 'text'
        ..validation = (FormValidationEntity()..required = true)
        ..labelEn = 'Specify'
        ..labelTe = 'Specify'
        ..placeholderEn = 'Specify'
        ..placeholderTe = 'Specify'
        ..onDatachnage = (value) {
          _onDataChanged(false);
        },
      FormEntity()
        ..name = 'tobaccouse'
        ..type = 'confirmcheck'
        ..labelEn = 'Tobacco use'
        ..labelTe = 'Tobacco use'
        ..onDatachnage = (value) {
          _onDataChanged(false);
        },
      FormEntity()
        ..name = 'alcoholuse'
        ..type = 'confirmcheck'
        ..labelEn = 'Alcohol use'
        ..labelTe = 'Alcohol use'
        ..onDatachnage = (value) {
          _onDataChanged(false);
        },
    ]);
    step5formFields.addAll([
      FormEntity()
        ..name = 'step5header'
        ..labelEn = 'NCD Screening'
        ..labelTe = 'NCD Screening'
        ..type = 'labelheader',
      FormEntity()
        ..name = 'hypertension'
        ..type = 'listcheckbox'
        ..labelEn = 'Hypertension'
        ..labelTe = 'Hypertension'
        ..inputFieldData = [
          {'label': 'Screened', 'value': false},
          {'label': 'Abnormal', 'value': false},
          {'label': 'Referred', 'value': false},
        ],
      FormEntity()
        ..name = 'diabetes'
        ..type = 'listcheckbox'
        ..labelEn = 'Diabetes'
        ..labelTe = 'Diabetes'
        ..inputFieldData = [
          {'label': 'Screened', 'value': false},
          {'label': 'Abnormal', 'value': false},
          {'label': 'Referred', 'value': false},
        ],
      FormEntity()
        ..name = 'oralcancer'
        ..type = 'listcheckbox'
        ..labelEn = 'Oral Cancer'
        ..labelTe = 'Oral Cancer'
        ..inputFieldData = [
          {'label': 'Screened', 'value': false},
          {'label': 'Abnormal', 'value': false},
          {'label': 'Referred', 'value': false},
        ],
      FormEntity()
        ..name = 'breastcancer'
        ..type = 'listcheckbox'
        ..labelEn = 'Breast Cancer'
        ..labelTe = 'Breast Cancer'
        ..inputFieldData = [
          {'label': 'Screened', 'value': false},
          {'label': 'Abnormal', 'value': false},
          {'label': 'Referred', 'value': false},
        ],
      FormEntity()
        ..name = 'cervicalcancer'
        ..type = 'listcheckbox'
        ..labelEn = 'Cervical Cancer'
        ..labelTe = 'Cervical Cancer'
        ..inputFieldData = [
          {'label': 'Screened', 'value': false},
          {'label': 'Abnormal', 'value': false},
          {'label': 'Referred', 'value': false},
        ],
    ]);
    step6formFields.addAll([
      FormEntity()
        ..name = 'step6header'
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
              step6formFields
                  .where((item) => item.name == 'hiveresult')
                  .firstOrNull;
          if (child != null) {
            child.isHidden = !value;
            child.fieldValue = null;
          }
          _onDataChanged(true);
        },
      FormEntity()
        ..name = 'hiveresult'
        ..labelEn = 'Result'
        ..labelTe = 'Result'
        ..type = 'collection'
        ..isHidden = true
        ..validation = (FormValidationEntity()..required = true)
        ..placeholderEn = 'Select Resuly'
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
              step6formFields
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
              step6formFields
                  .where((item) => item.name == 'confirmedatICTC')
                  .firstOrNull;
          if (child != null) {
            child.isHidden = !value;
            child.fieldValue = null;
          }
          _onDataChanged(true);
        },
      FormEntity()
        ..name = 'confirmedatICTC'
        ..type = 'confirmcheck'
        ..labelEn = 'Confirmed at ICTC?'
        ..labelTe = 'Confirmed at ICTC?'
        ..isHidden = true
        ..onDatachnage = (value) {
          final childs = step6formFields.where(
            (item) =>
                ['referredtoART', 'partnertestingdone'].contains(item.name),
          );
          for (var child in childs) {
            child.isHidden = !value;
            child.fieldValue = null;
          }
          _onDataChanged(true);
        },
      FormEntity()
        ..name = 'referredtoART'
        ..type = 'confirmcheck'
        ..labelEn = 'Referred to ART / Already on ART?'
        ..labelTe = 'Referred to ART / Already on ART?'
        ..isHidden = true
        ..onDatachnage = (value) {
          _onDataChanged(false);
        },
      FormEntity()
        ..name = 'partnertestingdone'
        ..type = 'confirmcheck'
        ..labelEn = 'Partner Testing Done?'
        ..labelTe = 'Partner Testing Done?'
        ..isHidden = true
        ..onDatachnage = (value) {
          final child =
              step6formFields
                  .where((item) => item.name == 'partnerresult')
                  .firstOrNull;
          if (child != null) {
            child.isHidden = !value;
            child.fieldValue = null;
          }
          _onDataChanged(true);
        },
      FormEntity()
        ..name = 'partnerresult'
        ..labelEn = 'Partner Result'
        ..labelTe = 'Partner Result'
        ..type = 'collection'
        ..isHidden = true
        ..validation = (FormValidationEntity()..required = true)
        ..placeholderEn = 'Select Partner Result'
        ..inputFieldData = {
          'items':
              [
                    {'id': '1', 'name': 'Reactive'},
                    {'id': '2', 'name': 'Negative'},
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
          _onDataChanged(false);
        },
    ]);
    step7formFields.addAll([
      FormEntity()
        ..name = 'step7header'
        ..labelEn = 'STI Screening'
        ..labelTe = 'STI Screening'
        ..type = 'labelheader',
      FormEntity()
        ..name = 'syphilis'
        ..type = 'listcheckbox'
        ..labelEn = 'Syphilis'
        ..labelTe = 'Syphilis'
        ..inputFieldData = [
          {'label': 'Done', 'value': false},
          {'label': 'Result', 'value': false, 'type': 'collection'},
        ],
      FormEntity()
        ..name = 'diabetes'
        ..type = 'listcheckbox'
        ..labelEn = 'Diabetes'
        ..labelTe = 'Diabetes'
        ..inputFieldData = [
          {'label': 'Done', 'value': false},
          {'label': 'Result', 'value': false, 'type': 'collection'},
        ],
      FormEntity()
        ..name = 'oralcancer'
        ..type = 'listcheckbox'
        ..labelEn = 'Oral Cancer'
        ..labelTe = 'Oral Cancer'
        ..inputFieldData = [
          {'label': 'Done', 'value': false},
          {'label': 'Result', 'value': false, 'type': 'collection'},
        ],
    ]);
    step8formFields.addAll([
      FormEntity()
        ..name = 'step8header'
        ..labelEn = 'Aditional Details'
        ..labelTe = 'Aditional Details'
        ..type = 'labelheader',
      FormEntity()
        ..name = 'reports'
        ..type = 'file'
        ..labelEn = 'Reports'
        ..labelTe = 'Reports'
        ..onDatachnage = (value) {
          _onDataChanged(false);
        },
      FormEntity()
        ..name = 'notes'
        ..type = 'textarea'
        ..labelEn = 'Notes'
        ..labelTe = 'Notes'
        ..placeholderEn = 'Remarks / Notes'
        ..placeholderTe = 'Remarks / Notes'
        ..onDatachnage = (value) {
          _onDataChanged(false);
        },
    ]);
    return [
      step1formFields,
      step2formFields,
      step3formFields,
      step4formFields,
      step5formFields,
      step6formFields,
      step7formFields,
      step8formFields,
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
      'Submit',
      resources.string.submit,
    ];
    final formFields = _getFormFields();
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
                  title: 'Health campaign screening',
                  showBack: true,
                ),
                ValueListenableBuilder(
                  valueListenable: _stepNotifier,
                  builder: (context, step, child) {
                    Future.delayed(Duration.zero, () {
                      _doDatavalidation.value = !_doDatavalidation.value;
                    });
                    return StepMetterWidget(stepCount: 8, currentStep: step);
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
                    var isLastStep = _stepNotifier.value == 8;
                    if (_stepNotifier.value == 2) {
                      final field =
                          formFields[1]
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
                            if (!isDataValid||_formKey.currentState?.validate()!=true) {
                              return;
                            }
                            if (_stepNotifier.value == 2) {
                              final fieldAdhar =
                                  formFields[1]
                                      .where((item) => item.name == 'consent')
                                      .firstOrNull;
                              final fieldNumber =
                                  formFields[1]
                                      .where((item) => item.name == 'consent')
                                      .firstOrNull;
                              if ((fieldAdhar?.fieldValue ?? '').isEmpty ==
                                      true &&
                                  (fieldNumber?.fieldValue ?? '').isEmpty ==
                                      true) {
                                Dialogs.showInfoDialog(
                                  context,
                                  PopupType.fail,
                                  'Please Enter Addar or Contact Number',
                                );
                                return;
                              }
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
                                  callback: () {
                                    Dialogs.showInfoDialog(
                                      context,
                                      PopupType.success,
                                      'Successfully Submitted',
                                    ).then((value) {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  },
                                ),
                              );
                            }
                          },
                          child: ActionButtonWidget(
                            text: nexButtonText,
                            width: 110,
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
