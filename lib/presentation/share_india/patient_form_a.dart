import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:shareindia_health_camp/presentation/utils/date_time_util.dart';

import '../common_widgets/action_button_widget.dart';

class PatientFormA extends StatefulWidget {
  Function(dynamic) callback;
  PatientFormA({required this.callback, super.key});
  final formKey = GlobalKey<FormState>();
  final TextEditingController artNoController = TextEditingController();

  final TextEditingController dateOfEnController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController dateStartController = TextEditingController();

  final TextEditingController artRegistrationController =
      TextEditingController();

  final TextEditingController interruptionController = TextEditingController();
  final ValueNotifier<int> genderSelect = ValueNotifier(0);
  final monthlyData = [];
  final monthlySelfReportedAdherence = [];
  @override
  State<PatientFormA> createState() => _PatientFormAState();
}

class _PatientFormAState extends State<PatientFormA> {
  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    if (widget.monthlyData.isEmpty)
      // ignore: curly_braces_in_flow_control_structures
      for (int i = 0; i < 12; i++) {
        widget.monthlyData.add({
          'dateofvisit': TextEditingController(),
          'dueDate': TextEditingController(),
        });
      }
    if (widget.monthlySelfReportedAdherence.isEmpty) {
      for (int i = 0; i < 6; i++) {
        widget.monthlySelfReportedAdherence.add(TextEditingController());
      }
    }
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
                          'Part A',
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
                                labelText: 'ART No',
                                hintText: 'ART No',
                                textInputType: TextInputType.visiblePassword,
                                errorMessage: 'ART No',
                                textController: widget.artNoController,
                                onChanged: (value) {},
                              ),
                            ),
                            SizedBox(width: resources.dimen.dp20),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  selectDate(
                                    context,
                                    lastDate: DateTime.now(),
                                  ).then((dateTime) {
                                    if (dateTime != null) {
                                      widget
                                          .dateOfEnController
                                          .text = getDateByformat(
                                        'dd/MM/yyyy',
                                        dateTime,
                                      );
                                    }
                                  });
                                },
                                child: RightIconTextWidget(
                                  isEnabled: false,
                                  labelText: 'Date of Enrolment',
                                  hintText: 'Date of Enrolment',
                                  errorMessage: 'Date of Enrolment',
                                  textController: widget.dateOfEnController,
                                  disableColor: resources.color.colorWhite,
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RightIconTextWidget(
                                labelText: 'Age at UTTAR Enrolment (years)',
                                hintText: 'Age at UTTAR Enrolment (years)',
                                errorMessage: 'Age at UTTAR Enrolment (years)',
                                textController: widget.ageController,
                                onChanged: (value) {},
                              ),
                            ),
                            SizedBox(width: resources.dimen.dp20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Gender',
                                      style: context.textFontWeight400
                                          .onFontSize(
                                            context.resources.fontSize.dp14,
                                          ),
                                      children: [
                                        TextSpan(
                                          text: ' *',
                                          style: context.textFontWeight400
                                              .onFontSize(
                                                context.resources.fontSize.dp14,
                                              )
                                              .onColor(
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: widget.genderSelect,
                                    builder: (context, gender, child) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: CheckboxListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              dense: true,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              title: Text(
                                                'Male',
                                                style:
                                                    context.textFontWeight400,
                                              ),
                                              value: gender == 1,
                                              onChanged: (isChecked) {
                                                widget.genderSelect.value = 1;
                                              },
                                            ),
                                          ),
                                          SizedBox(width: resources.dimen.dp10),
                                          Expanded(
                                            child: CheckboxListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              dense: true,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              title: Text(
                                                'Female',
                                                style:
                                                    context.textFontWeight400,
                                              ),
                                              value: gender == 2,
                                              onChanged: (isChecked) {
                                                widget.genderSelect.value = 2;
                                              },
                                            ),
                                          ),
                                          SizedBox(width: resources.dimen.dp10),
                                          Expanded(
                                            child: CheckboxListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              dense: true,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              title: Text(
                                                'TG',
                                                style:
                                                    context.textFontWeight400,
                                              ),
                                              value: gender == 3,
                                              onChanged: (isChecked) {
                                                widget.genderSelect.value = 3;
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: resources.dimen.dp10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                          .dateStartController
                                          .text = getDateByformat(
                                        'dd/MM/yyyy',
                                        dateTime,
                                      );
                                    }
                                  });
                                },
                                child: RightIconTextWidget(
                                  isEnabled: false,
                                  labelText: 'Date of start of ART',
                                  hintText: 'Date of start of ART',
                                  errorMessage: 'Date of start of ART',
                                  textController: widget.dateStartController,
                                  disableColor: resources.color.colorWhite,
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                            SizedBox(width: resources.dimen.dp20),
                            Expanded(
                              child: RightIconTextWidget(
                                labelText: 'Age at ART Registration (years)',
                                hintText: 'Age at ART Registration (years)',
                                errorMessage: 'Age at ART Registration (years)',
                                textController:
                                    widget.artRegistrationController,
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
                          'Self-reported Adherence (6 months prior to UTTAR enrolment)',
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
                                  child: RightIconTextWidget(
                                    labelText: 'Month - ${(c * 3) + r + 1}',
                                    textController:
                                        widget.monthlySelfReportedAdherence[(c *
                                                3) +
                                            r],
                                    errorMessage:
                                        'Enter SR Adherence of Month - ${(c * 3) + r + 1}',
                                    onChanged: (p0) {},
                                  ),
                                ),
                                if (r < 2)
                                  SizedBox(width: resources.dimen.dp20),
                              ],
                            ],
                          ),
                          if (c < 3) SizedBox(height: resources.dimen.dp20),
                        ],
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
                          'Pill Pick up data (12 months prior to UTTAR enrolment)',
                          style: context.textFontWeight600.onColor(
                            resources.color.viewBgColor,
                          ),
                        ),
                        SizedBox(height: resources.dimen.dp20),
                        for (int c = 0; c < 4; c++) ...[
                          Row(
                            children: [
                              for (int r = 0; r < 3; r++) ...[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Month - ${(c * 3) + r + 1}',
                                        style: context.textFontWeight600,
                                      ),
                                      SizedBox(height: resources.dimen.dp5),
                                      InkWell(
                                        onTap: () {
                                          selectDate(
                                            context,
                                            lastDate: DateTime.now(),
                                          ).then((dateTime) {
                                            if (dateTime != null) {
                                              widget
                                                  .monthlyData[(c * 3) +
                                                      r]['dateofvisit']
                                                  .text = getDateByformat(
                                                'dd/MM/yyyy',
                                                dateTime,
                                              );
                                            }
                                          });
                                        },
                                        child: RightIconTextWidget(
                                          isEnabled: false,
                                          textController:
                                              widget.monthlyData[(c * 3) +
                                                  r]['dateofvisit'],
                                          disableColor:
                                              resources.color.colorWhite,
                                          hintText: 'Date of visit',
                                          errorMessage:
                                              'Enter Date of visit of Month - ${(c * 3) + r + 1}',
                                        ),
                                      ),
                                      SizedBox(height: resources.dimen.dp5),
                                      InkWell(
                                        onTap: () {
                                          selectDate(
                                            context,
                                            lastDate: DateTime.now(),
                                          ).then((dateTime) {
                                            if (dateTime != null) {
                                              widget
                                                  .monthlyData[(c * 3) +
                                                      r]['dueDate']
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
                                              widget.monthlyData[(c * 3) +
                                                  r]['dueDate'],
                                          hintText: 'Due date',
                                          errorMessage:
                                              'Enter Due date of Month - ${(c * 3) + r + 1}',
                                        ),
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
                        SizedBox(height: resources.dimen.dp20),
                        RightIconTextWidget(
                          labelText: '# of Episodes of treatment interruption',
                          hintText: 'of Episodes of treatment interruption',
                          errorMessage:
                              'Enter of Episodes of treatment interruption',
                          textController: widget.interruptionController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: resources.dimen.dp20),
                  InkWell(
                    onTap: () {
                      if (widget.formKey.currentState?.validate() == true) {}
                      widget.callback('B');
                    },
                    child: ActionButtonWidget(
                      text: 'Next',
                      padding: EdgeInsets.symmetric(
                        horizontal: context.resources.dimen.dp40,
                        vertical: context.resources.dimen.dp7,
                      ),
                    ),
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
