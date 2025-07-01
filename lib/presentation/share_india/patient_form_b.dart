// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/dropdown_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:shareindia_health_camp/presentation/utils/date_time_util.dart';

import '../common_widgets/action_button_widget.dart';
import '../common_widgets/multi_upload_attachment_widget.dart';

class PatientFormB extends StatefulWidget {
  Function(dynamic) callback;
  PatientFormB({required this.callback, super.key});
  final formKey = GlobalKey<FormState>();

  final TextEditingController regimeController = TextEditingController();

  final TextEditingController lineOfTreatmentController =
      TextEditingController();

  final TextEditingController dateOfUnSuppressionController =
      TextEditingController();

  final TextEditingController vlCountController = TextEditingController();
  final TextEditingController dateOfVLEAC1Controller = TextEditingController();
  final TextEditingController vlCountEAC1Controller = TextEditingController();
  final TextEditingController dateOfVLEAC2Controller = TextEditingController();
  final TextEditingController vlCountEAC2Controller = TextEditingController();
  final TextEditingController dtgExposureController = TextEditingController();
  final TextEditingController tld1Controller = TextEditingController();
  final TextEditingController kcmOtherController = TextEditingController();
  final TextEditingController tdfSampleCollectionController =
      TextEditingController();
  final TextEditingController tdfResultController = TextEditingController();
  final TextEditingController hivdrSpecimenCollectionController =
      TextEditingController();
  final TextEditingController hivdrResultCollectionController =
      TextEditingController();

  final ValueNotifier<int> knownCoMorbiditiesSelect = ValueNotifier(0);
  final regimenData = [];
  final eac1Data = [];
  final eac2Data = [];
  @override
  State<PatientFormB> createState() => _PatientFormBState();
}

class _PatientFormBState extends State<PatientFormB> {
  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    final multiUploadAttachmentWidget = MultiUploadAttachmentWidget(
      hintText: resources.string.uploadFile,
      fillColor: resources.color.colorWhite,
      borderSide: BorderSide(
        color: context.resources.color.sideBarItemUnselected,
        width: 1,
      ),
      borderRadius: 0,
    );
    if (widget.regimenData.isEmpty) {
      for (int i = 0; i < 12; i++) {
        widget.regimenData.add({
          'regimen': TextEditingController(),
          'lineoftreatment': TextEditingController(),
          'fromDate': TextEditingController(),
          'toDate': TextEditingController(),
        });
      }
    }
    if (widget.eac1Data.isEmpty) {
      for (int i = 0; i < 3; i++) {
        widget.eac1Data.add({
          'dateOfEAC': TextEditingController(),
          'adherenceBarriers': '',
        });
      }
    }
    if (widget.eac2Data.isEmpty) {
      for (int i = 0; i < 3; i++) {
        widget.eac2Data.add({
          'dateOfEAC': TextEditingController(),
          'adherenceBarriers': '',
        });
      }
    }
    final adherenceBarriers = [
      'Forgot',
      'Beliefs/Myths',
      'Lack of knowledge about ART',
      'Adverse effects',
      'Physical illness',
      'Substance use',
      'Depression',
      'Pill burden',
      'Social functions',
      'Feeling healthy',
      'Child behaviour/refusing',
      'Timing',
      'Fear of disclosure',
      'Caregiver',
      'Financial/travel issues',
      'Drug stock out',
      'Long wait',
      'Stigma',
      'Other (Specify)',
    ];
    final knownCoMorbidities = [
      'TB',
      'Epilepsy',
      'Diabetes',
      'HBV',
      'HCV',
      'Hypertension',
    ];
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp15,
                      horizontal: resources.dimen.dp20,
                    ),
                    color: resources.color.colorWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Part B',
                          style: context.textFontWeight600.onColor(
                            resources.color.viewBgColor,
                          ),
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RightIconTextWidget(
                                labelText:
                                    'Regimen at the time of UTTAR enrolment',
                                hintText:
                                    'Regimen at the time of UTTAR enrolment',
                                textInputType: TextInputType.visiblePassword,
                                errorMessage:
                                    'Enter Regimen at the time of UTTAR enrolment',
                                textController: widget.regimeController,
                                onChanged: (value) {},
                              ),
                            ),
                            SizedBox(width: resources.dimen.dp20),
                            Expanded(
                              child: RightIconTextWidget(
                                labelText:
                                    'Line of treatment at the time of UTTAR enrolment',
                                hintText:
                                    'Line of treatment at the time of UTTAR enrolment',
                                errorMessage:
                                    'Enter Line of treatment at the time of UTTAR enrolment',
                                textController:
                                    widget.lineOfTreatmentController,
                                disableColor: resources.color.colorWhite,
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: resources.dimen.dp20),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp15,
                      horizontal: resources.dimen.dp20,
                    ),
                    color: resources.color.colorWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Regimen prior to enrolment (if any switch/Substitution)',
                          style: context.textFontWeight600.onColor(
                            resources.color.viewBgColor,
                          ),
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        for (int c = 0; c < 2; c++) ...[
                          Row(
                            children: [
                              for (int r = 0; r < 3; r++) ...[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Regimen - ${(c * 3) + r + 1}',
                                        style: context.textFontWeight600,
                                      ),
                                      SizedBox(height: resources.dimen.dp10),
                                      RightIconTextWidget(
                                        hintText:
                                            'Regimen - ${(c * 3) + r + 1}',
                                        errorMessage:
                                            'Regimen - ${(c * 3) + r + 1}',
                                        textController:
                                            widget.regimenData[(c * 3) +
                                                r]['regimen'],
                                        disableColor:
                                            resources.color.colorWhite,
                                        onChanged: (value) {},
                                      ),
                                      SizedBox(height: resources.dimen.dp5),
                                      RightIconTextWidget(
                                        isEnabled: false,
                                        textController:
                                            widget.regimenData[(c * 3) +
                                                r]['lineoftreatment'],
                                        disableColor:
                                            resources.color.colorWhite,
                                        hintText: 'Line of treatment',
                                        errorMessage:
                                            'Enter Line of treatment Month - ${(c * 3) + r + 1}',
                                      ),
                                      SizedBox(height: resources.dimen.dp5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                selectDate(
                                                  context,
                                                  lastDate: DateTime.now(),
                                                ).then((dateTime) {
                                                  if (dateTime != null) {
                                                    widget
                                                        .regimenData[(c * 3) +
                                                            r]['fromDate']
                                                        .text = getDateByformat(
                                                      'dd/MM/yyyy',
                                                      dateTime,
                                                    );
                                                  }
                                                });
                                              },
                                              child: RightIconTextWidget(
                                                isEnabled: false,
                                                disableColor:
                                                    resources.color.colorWhite,
                                                textController:
                                                    widget.regimenData[(c * 3) +
                                                        r]['fromDate'],
                                                hintText: 'From date',
                                                errorMessage:
                                                    'Enter From date of Regimen - ${(c * 3) + r + 1}',
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: resources.dimen.dp10),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                selectDate(
                                                  context,
                                                  lastDate: DateTime.now(),
                                                ).then((dateTime) {
                                                  if (dateTime != null) {
                                                    widget
                                                        .regimenData[(c * 3) +
                                                            r]['toDate']
                                                        .text = getDateByformat(
                                                      'dd/MM/yyyy',
                                                      dateTime,
                                                    );
                                                  }
                                                });
                                              },
                                              child: RightIconTextWidget(
                                                isEnabled: false,
                                                disableColor:
                                                    resources.color.colorWhite,
                                                textController:
                                                    widget.regimenData[(c * 3) +
                                                        r]['toDate'],
                                                hintText: 'To date',
                                                errorMessage:
                                                    'Enter To date of Regimen - ${(c * 3) + r + 1}',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (r < 2)
                                  SizedBox(width: resources.dimen.dp20),
                              ],
                            ],
                          ),
                          if (c < 2) SizedBox(height: resources.dimen.dp20),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  selectDate(
                                    context,
                                    lastDate: DateTime.now(),
                                  ).then((dateTime) {
                                    if (dateTime != null) {
                                      getDateByformat('dd/MM/yyyy', dateTime);
                                    }
                                  });
                                },
                                child: RightIconTextWidget(
                                  isEnabled: false,
                                  labelText: 'Date of 1st VL un-suppression',
                                  disableColor: resources.color.colorWhite,
                                  hintText: 'Date of 1st VL un-suppression',
                                  errorMessage:
                                      'Enter Date of 1st VL un-suppression',
                                  textController:
                                      widget.dateOfUnSuppressionController,
                                ),
                              ),
                            ),
                            SizedBox(width: resources.dimen.dp20),
                            Expanded(
                              child: RightIconTextWidget(
                                labelText: 'VL count',
                                disableColor: resources.color.colorWhite,
                                hintText: 'VL count',
                                errorMessage: 'VL count',
                                textController: widget.vlCountController,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: resources.dimen.dp20),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp15,
                      horizontal: resources.dimen.dp20,
                    ),
                    color: resources.color.colorWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EAC-1',
                          style: context.textFontWeight600.onColor(
                            resources.color.viewBgColor,
                          ),
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        for (int c = 0; c < 1; c++) ...[
                          Row(
                            children: [
                              for (int r = 0; r < 3; r++) ...[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          selectDate(
                                            context,
                                            lastDate: DateTime.now(),
                                          ).then((dateTime) {
                                            if (dateTime != null) {
                                              widget
                                                  .eac1Data[(c * 3) +
                                                      r]['dateOfEAC']
                                                  .text = getDateByformat(
                                                'dd/MM/yyyy',
                                                dateTime,
                                              );
                                            }
                                          });
                                        },
                                        child: RightIconTextWidget(
                                          isEnabled: false,
                                          labelText:
                                              'Date of EAC Month - ${(c * 3) + r + 1}',
                                          textController:
                                              widget.eac1Data[(c * 3) +
                                                  r]['dateOfEAC'],
                                          disableColor:
                                              resources.color.colorWhite,
                                          hintText:
                                              'Date of EAC Month - ${(c * 3) + r + 1}',
                                          errorMessage:
                                              'Enter Date of EAC of Month - ${(c * 3) + r + 1}',
                                        ),
                                      ),
                                      SizedBox(height: resources.dimen.dp5),
                                      DropDownWidget(
                                        list: adherenceBarriers,
                                        hintText: 'Adherence Barriers',
                                        errorMessage:
                                            'Enter Adherence Barriers of Month - ${(c * 3) + r + 1}',
                                        fillColor: resources.color.colorWhite,
                                        borderRadius: 0,
                                        callback: (p0) {
                                          widget.eac1Data[(c * 3) +
                                                  r]['adherenceBarriers'] =
                                              p0;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                if (r < 2)
                                  SizedBox(width: resources.dimen.dp20),
                              ],
                            ],
                          ),
                          if (c < 3) SizedBox(height: resources.dimen.dp20),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  selectDate(
                                    context,
                                    lastDate: DateTime.now(),
                                  ).then((dateTime) {
                                    if (dateTime != null) {
                                      widget
                                          .dateOfVLEAC1Controller
                                          .text = getDateByformat(
                                        'dd/MM/yyyy',
                                        dateTime,
                                      );
                                    }
                                  });
                                },
                                child: RightIconTextWidget(
                                  isEnabled: false,
                                  labelText: 'Date of VL test after EAC-1',
                                  disableColor: resources.color.colorWhite,
                                  hintText: 'Date of VL test after EAC-1',
                                  errorMessage:
                                      'Enter Date of VL test after EAC-1',
                                  textController: widget.dateOfVLEAC1Controller,
                                ),
                              ),
                            ),
                            SizedBox(width: resources.dimen.dp20),
                            Expanded(
                              child: RightIconTextWidget(
                                labelText: 'VL count after EAC-1',
                                disableColor: resources.color.colorWhite,
                                hintText: 'VL count after EAC-1',
                                errorMessage: 'VL count after EAC-1',
                                textController: widget.vlCountEAC1Controller,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: resources.dimen.dp20),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp15,
                      horizontal: resources.dimen.dp20,
                    ),
                    color: resources.color.colorWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EAC-2',
                          style: context.textFontWeight600.onColor(
                            resources.color.viewBgColor,
                          ),
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        for (int c = 0; c < 1; c++) ...[
                          Row(
                            children: [
                              for (int r = 0; r < 3; r++) ...[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          selectDate(
                                            context,
                                            lastDate: DateTime.now(),
                                          ).then((dateTime) {
                                            if (dateTime != null) {
                                              widget
                                                  .eac2Data[(c * 3) +
                                                      r]['dateOfEAC']
                                                  .text = getDateByformat(
                                                'dd/MM/yyyy',
                                                dateTime,
                                              );
                                            }
                                          });
                                        },
                                        child: RightIconTextWidget(
                                          isEnabled: false,
                                          labelText:
                                              'Date of EAC Month - ${(c * 3) + r + 1}',
                                          textController:
                                              widget.eac2Data[(c * 3) +
                                                  r]['dateOfEAC'],
                                          disableColor:
                                              resources.color.colorWhite,
                                          hintText:
                                              'Date of EAC Month - ${(c * 3) + r + 1}',
                                          errorMessage:
                                              'Enter Date of EAC of Month - ${(c * 3) + r + 1}',
                                        ),
                                      ),
                                      SizedBox(height: resources.dimen.dp5),
                                      DropDownWidget(
                                        list: adherenceBarriers,
                                        hintText: 'Adherence Barriers',
                                        errorMessage:
                                            'Enter Adherence Barriers of Month - ${(c * 3) + r + 1}',
                                        fillColor: resources.color.colorWhite,
                                        borderRadius: 0,
                                        callback: (p0) {
                                          widget.eac2Data[(c * 3) +
                                                  r]['adherenceBarriers'] =
                                              p0;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                if (r < 2)
                                  SizedBox(width: resources.dimen.dp20),
                              ],
                            ],
                          ),
                          if (c < 3) SizedBox(height: resources.dimen.dp20),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  selectDate(
                                    context,
                                    lastDate: DateTime.now(),
                                  ).then((dateTime) {
                                    if (dateTime != null) {
                                      widget
                                          .dateOfVLEAC2Controller
                                          .text = getDateByformat(
                                        'dd/MM/yyyy',
                                        dateTime,
                                      );
                                    }
                                  });
                                },
                                child: RightIconTextWidget(
                                  isEnabled: false,
                                  labelText: 'Date of VL test after EAC-2',
                                  disableColor: resources.color.colorWhite,
                                  hintText: 'Date of VL test after EAC-2',
                                  errorMessage:
                                      'Enter Date of VL test after EAC-2',
                                  textController: widget.dateOfVLEAC2Controller,
                                ),
                              ),
                            ),
                            SizedBox(width: resources.dimen.dp20),
                            Expanded(
                              child: RightIconTextWidget(
                                labelText: 'VL count after EAC-2',
                                disableColor: resources.color.colorWhite,
                                hintText: 'VL count after EAC-2',
                                errorMessage: 'VL count after EAC-2',
                                textController: widget.vlCountEAC2Controller,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        Row(
                          children: [
                            Expanded(
                              child: RightIconTextWidget(
                                labelText: 'Duration on DTG exposure',
                                disableColor: resources.color.colorWhite,
                                hintText: 'Duration on DTG exposure',
                                errorMessage: 'Enter Duration on DTG exposure',
                                textController: widget.dtgExposureController,
                              ),
                            ),
                            SizedBox(width: resources.dimen.dp20),
                            Expanded(
                              child: RightIconTextWidget(
                                labelText: 'TLD1/TLD2',
                                disableColor: resources.color.colorWhite,
                                hintText: 'TLD1/TLD2',
                                errorMessage: 'TLD1/TLD2',
                                textController: widget.tld1Controller,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: resources.dimen.dp20),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp15,
                      horizontal: resources.dimen.dp20,
                    ),
                    color: resources.color.colorWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Known Co-morbidities',
                          style: context.textFontWeight600.onColor(
                            resources.color.viewBgColor,
                          ),
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        ValueListenableBuilder(
                          valueListenable: widget.knownCoMorbiditiesSelect,
                          builder: (context, value, child) {
                            return Row(
                              children: [
                                for (
                                  int r = 0;
                                  r < knownCoMorbidities.length;
                                  r++
                                ) ...[
                                  Expanded(
                                    child: CheckboxListTile.adaptive(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(
                                        knownCoMorbidities[r],
                                        style: context.textFontWeight400,
                                      ),
                                      value: value == (r + 1),
                                      onChanged: (isChecked) {
                                        if (isChecked == true) {
                                          widget
                                              .knownCoMorbiditiesSelect
                                              .value = r + 1;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        RightIconTextWidget(
                          labelText: 'Other (specify)',
                          disableColor: resources.color.colorWhite,
                          hintText: 'Other (specify)',
                          errorMessage: 'Enter Other (specify)',
                          textController: widget.kcmOtherController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: resources.dimen.dp20),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp15,
                      horizontal: resources.dimen.dp20,
                    ),
                    color: resources.color.colorWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PART-C',
                          style: context.textFontWeight600.onColor(
                            resources.color.viewBgColor,
                          ),
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  selectDate(
                                    context,
                                    lastDate: DateTime.now(),
                                  ).then((dateTime) {
                                    if (dateTime != null) {
                                      widget
                                          .tdfSampleCollectionController
                                          .text = getDateByformat(
                                        'dd/MM/yyyy',
                                        dateTime,
                                      );
                                    }
                                  });
                                },
                                child: RightIconTextWidget(
                                  isEnabled: false,
                                  labelText:
                                      'Date of Urine TDF Sample Collection',
                                  disableColor: resources.color.colorWhite,
                                  hintText:
                                      'Date of Urine TDF Sample Collection',
                                  errorMessage:
                                      'Date of Urine TDF Sample Collection',
                                  textController:
                                      widget.tdfSampleCollectionController,
                                ),
                              ),
                            ),
                            SizedBox(width: resources.dimen.dp20),
                            Expanded(
                              child: RightIconTextWidget(
                                labelText: 'Result of Urine TDF',
                                disableColor: resources.color.colorWhite,
                                hintText: 'Result of Urine TDF',
                                errorMessage: 'Result of Urine TDF',
                                textController: widget.tdfResultController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  selectDate(
                                    context,
                                    lastDate: DateTime.now(),
                                  ).then((dateTime) {
                                    if (dateTime != null) {
                                      widget
                                          .hivdrSpecimenCollectionController
                                          .text = getDateByformat(
                                        'dd/MM/yyyy',
                                        dateTime,
                                      );
                                    }
                                  });
                                },
                                child: RightIconTextWidget(
                                  isEnabled: false,
                                  labelText:
                                      'Date of HIVDR specimen collection',
                                  disableColor: resources.color.colorWhite,
                                  hintText: 'Date of HIVDR specimen collection',
                                  errorMessage:
                                      'Date of HIVDR specimen collection',
                                  textController:
                                      widget.hivdrSpecimenCollectionController,
                                ),
                              ),
                            ),
                            SizedBox(width: resources.dimen.dp20),
                            Expanded(
                              child: RightIconTextWidget(
                                labelText: 'Result of HIVDR Status',
                                disableColor: resources.color.colorWhite,
                                hintText: 'Result of HIVDR Status',
                                errorMessage: 'Result of HIVDR Status',
                                textController:
                                    widget.hivdrResultCollectionController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        multiUploadAttachmentWidget,
                      ],
                    ),
                  ),
                  SizedBox(height: resources.dimen.dp20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          widget.callback('A');
                        },
                        child: ActionButtonWidget(
                          text: 'Previous',
                          color: resources.color.colorWhite,
                          textColor: resources.color.textColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.resources.dimen.dp40,
                            vertical: context.resources.dimen.dp7,
                          ),
                        ),
                      ),
                      SizedBox(width: resources.dimen.dp20),
                      InkWell(
                        onTap: () async {
                          if (widget.formKey.currentState?.validate() ==
                              true) {}
                        },
                        child: ActionButtonWidget(
                          text: resources.string.submit,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.resources.dimen.dp40,
                            vertical: context.resources.dimen.dp7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: resources.dimen.dp20),
        ],
      ),
    );
  }
}
