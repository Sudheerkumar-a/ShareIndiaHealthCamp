
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/constants/data_constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/field_entity_extension.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/data/remote/api_urls.dart';
import 'package:shareindia_health_camp/domain/entities/master_data_entities.dart';
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

class AddCampFormScreen extends StatefulWidget {
  static Future<dynamic> start(
    BuildContext context) async {
    return await Navigator.of(context, rootNavigator: true).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: AddCampFormScreen(),
      ),
    );
  }

  const AddCampFormScreen({super.key});

  @override
  State<AddCampFormScreen> createState() => _AddCampFormScreenState();
}

class _AddCampFormScreenState extends State<AddCampFormScreen> {
  final ValueNotifier<int> _stepNotifier = ValueNotifier(1);

  final ValueNotifier<bool> _doDatavalidation = ValueNotifier(false);

  final ScrollController _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();

  final Map fieldsData = {};

  final step1formFields = List<FormEntity>.empty(growable: true);

  final stepCount = 1;

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
                {'id': '1', 'name': 'VHC'},
                {'id': '2', 'name': 'Sub centre'},
                {'id': '3', 'name': 'Anganwadi'},
                {'id': '4', 'name': 'PHC'},
                {'id': '5', 'name': 'UPHC'},
                {'id': '6', 'name': 'CHC'},
                {'id': '7', 'name': 'Other (specify)'},
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
                        (fieldsData['camp_location'] ?? '')) ||
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
                                (fieldsData['mandal'] ?? '')) ||
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
          ..name = 'image_camp'
          ..labelEn = 'Photo Of Camp'
          ..labelTe = 'Photo Of Camp'
          ..type = 'image'
          ..placeholderEn = 'Photo Of Camp'
          ..fieldValue = fieldsData['image_camp']
          ..validation = (FormValidationEntity()..isRequired = true)
          ..messages =
              (FormMessageEntity()..requiredEn = 'Please take Photo Of Camp')
          ..suffixIcon = DrawableAssets.icUpload
          ..onDatachnage = (value) {
            fieldsData['image_camp'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'district'
          ..labelEn = 'District'
          ..labelTe = 'District'
          ..type = 'collection'
          ..isEnabled = false
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
          ..canSearch = true
          ..onDatachnage = (value) {
            final child =
                step1formFields
                    .where((item) => item.name == 'village')
                    .firstOrNull;
            if (child != null) {
              child.inputFieldData?.remove('items');
              child.url = villageListApiUrl;
              child.urlInputData = {'mandal_id': value.id};
              child.inputFieldData = null;
              child.fieldValue = null;
            }
            fieldsData['mandal'] = value.id;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'village'
          ..labelEn = 'Village'
          ..labelTe = 'Village'
          ..type = 'collection'
          ..canSearch = true
          ..requestModel = ListModel.fromvillageJson
          ..validation = (FormValidationEntity()..isRequired = true)
          ..placeholderEn = 'Select Village'
          ..onDatachnage = (value) {
            fieldsData['village'] = value.id;
            _onDataChanged(false);
          },
        // FormEntity()
        //   ..name = 'village'
        //   ..labelEn = 'Village'
        //   ..labelTe = 'Village'
        //   ..type = 'text'
        //   // ..inputFieldData = {
        //   //   'items':
        //   //       [
        //   //             {'id': 1, 'name': 'Village1'},
        //   //             {'id': 2, 'name': 'Village2'},
        //   //             {'id': 3, 'name': 'Village3'},
        //   //             {'id': 4, 'name': 'Village4'},
        //   //           ]
        //   //           .map(
        //   //             (item) =>
        //   //                 NameIDModel.fromDistrictsJson(
        //   //                   item as Map<String, dynamic>,
        //   //                 ).toEntity(),
        //   //           )
        //   //           .toList(),
        //   // }
        //   ..fieldValue = fieldsData['village']
        //   ..validation =
        //       (FormValidationEntity()
        //         ..isRequired = true
        //         ..regex = nameRegExp)
        //   ..messages =
        //       (FormMessageEntity()
        //         ..requiredEn = 'Please Enter Village'
        //         ..requiredTe = 'Please Enter Village'
        //         ..regexEn = 'Please Enter Valid Village'
        //         ..regexTe = 'Please Enter Valid Village')
        //   ..placeholderEn = 'Enter Village'
        //   ..onDatachnage = (value) {
        //     fieldsData['village'] = value;
        //     _onDataChanged(false);
        //   },
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
            final child =
                step1formFields
                    .where((item) => item.name == 'camp_location_other')
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
            fieldsData['camp_location'] = value.name;
            _onDataChanged(true);
          },
        FormEntity()
          ..name = 'camp_location_other'
          ..type = 'text'
          ..isHidden = true
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
            fieldsData['camp_location_other'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'camp_local_poc_name'
          ..type = 'text'
          ..validation =
              (FormValidationEntity()
                ..isRequired = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Local POC (ASHA/ANM) Name'
                ..requiredTe = 'Please Enter Local POC (ASHA/ANM) Name'
                ..regexEn = 'Please Enter Valid Local POC (ASHA/ANM) Name'
                ..regexTe = 'Please Enter Valid Local POC (ASHA/ANM) Name')
          ..label = 'Local POC (ASHA/ANM) Name'
          ..placeholderEn = 'Local POC (ASHA/ANM) Name'
          ..placeholderTe = 'Local POC (ASHA/ANM) Name'
          ..fieldValue = fieldsData['camp_local_poc_name']
          ..onDatachnage = (value) {
            fieldsData['camp_local_poc_name'] = value;
            _onDataChanged(false);
          },
        FormEntity()
          ..name = 'camp_local_poc_number'
          ..type = 'number'
          ..validation =
              (FormValidationEntity()
                ..isRequired = true
                ..maxLength = 10
                ..regex = numberRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Local POC (ASHA/ANM) Number'
                ..requiredTe = 'Please Enter Local POC (ASHA/ANM) Number'
                ..regexEn = 'Please Enter Valid Local POC (ASHA/ANM) Number'
                ..regexTe = 'Please Enter Valid Local POC (ASHA/ANM) Number')
          ..label = 'Local POC (ASHA/ANM) Number'
          ..placeholderEn = 'Local POC (ASHA/ANM) Number'
          ..placeholderTe = 'Local POC (ASHA/ANM) Number'
          ..fieldValue = fieldsData['camp_local_poc_number']
          ..onDatachnage = (value) {
            fieldsData['camp_local_poc_number'] = value;
            _onDataChanged(false);
          },
      ]);
    }
    return [
      step1formFields,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    List<String> stepButtonTexts = [
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
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: resources.dimen.dp20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                    final nexButtonText =
                        isLastStep
                            ? resources.string.submit
                            : stepButtonTexts[_stepNotifier.value - 1];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          InkWell(
                            onTap: () {
                             Navigator.pop(context);
                            },
                            child: ActionButtonWidget(
                              text: 'Cancel',
                              width: 110,
                              padding: EdgeInsets.symmetric(
                                horizontal: context.resources.dimen.dp20,
                                vertical: context.resources.dimen.dp7,
                              ),
                            ),
                          ),
                          SizedBox(width: resources.dimen.dp10),
                        InkWell(
                          onTap: () async {
                            if (!isDataValid ||
                                _formKey.currentState?.validate() != true) {
                              return;
                            }

                            if (!isLastStep) {
                              _stepNotifier.value = _stepNotifier.value + 1;
                              setState(() {
                                _scrollController.jumpTo(0);
                              });
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
                                      "date_of_camp":
                                          fieldsData['date_of_camp'],
                                      "district": fieldsData['district'],
                                      "mandal": fieldsData['mandal'],
                                      "village": fieldsData['village'],
                                      "camp_location":
                                          fieldsData['camp_location'],
                                      "camp_village":
                                          fieldsData['camp_location_other'],
                                      "local_poc_number":
                                          fieldsData['camp_local_poc_number'],
                                      "local_poc_name":
                                          fieldsData['camp_local_poc_name'],
                                      "latitude":
                                          12.72,
                                      "longitude":
                                          72.23,
                                    };
                                    if(fieldsData['image_camp'] is UploadResponseEntity)
                                    {
                                     requestParams['photo_of_camp'] = MultipartFile.fromBytes(
                                        fieldsData['image_camp'].bytes,
                                        filename: fieldsData['image_camp'].documentName);
                                    }
                                    //jsonEncode(requestParams);
                                    Dialogs.loader(context);
                                    final response = await sl<ServicesBloc>()
                                        .submitMultipartData(
                                          apiUrl:
                                              campSubmitApiUrl,
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
                                          Navigator.pop(context, true);
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
