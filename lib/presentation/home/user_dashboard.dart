import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/constants/data_constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/field_entity_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/domain/entities/dashboard_entity.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
import 'package:shareindia_health_camp/injection_container.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/report_list_widget.dart';
import 'package:shareindia_health_camp/res/drawables/background_box_decoration.dart';

class UserDashboard extends BaseScreenWidget {
  UserDashboard({super.key});
  final _serviceBloc = sl<ServicesBloc>();
  final _onMonthChanged = ValueNotifier('');
  final _onDistrictChanged = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    _onMonthChanged.value = getDateByformat('MM', DateTime.now());
    Future.delayed(Duration.zero, () {
      _serviceBloc.getDashboardData(requestParams: {}, emitResponse: true);
    });
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: BlocProvider<ServicesBloc>(
        create: (newContext) => _serviceBloc,
        child: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (newContext, state) {
            if (state is ServicesStateLoading) {
              return Center(
                child: CircularProgressIndicator(
                  constraints: BoxConstraints(maxHeight: 40, maxWidth: 40),
                ),
              );
            } else if (state is ServicesStateApiError) {
              return Center(
                child: Text(state.message, style: context.textFontWeight600),
              );
            } else if (state is ServicesStateSuccess) {
              final dashboardEntity = cast<DashboardEntity>(
                state.responseEntity.entity,
              );

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: (FormEntity()
                                      ..type = 'labelheader'
                                      ..labelEn = 'Dashboard'.toUpperCase()
                                      ..labelTe = 'Dashboard'.toUpperCase())
                                    .getWidget(context),
                              ),
                              SizedBox(width: resources.dimen.dp10),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: (FormEntity()
                                        ..type = 'labelheader'
                                        ..labelEn =
                                            'Andhra Pradesh'.toUpperCase()
                                        ..labelTe =
                                            'Andhra Pradesh'.toUpperCase())
                                      .getWidget(context),
                                ),
                              ),
                            ],
                          ),
                          (FormEntity()
                                ..type = 'collection'
                                ..placeholderEn = 'Select District'
                                ..placeholderTe = 'Select District'
                                ..inputFieldData = {
                                  'items':
                                      districts
                                          .map(
                                            (item) =>
                                                NameIDModel.fromDistrictsJson(
                                                  item as Map<String, dynamic>,
                                                ).toEntity(),
                                          )
                                          .toList()
                                        ..add(
                                          NameIDEntity()
                                            ..id = 0
                                            ..name = 'ALL',
                                        ),
                                }
                                ..onDatachnage = (value) {
                                  _onDistrictChanged.value = value.id;
                                })
                              .getWidget(context),
                          SizedBox(height: resources.dimen.dp10),
                          ValueListenableBuilder(
                            valueListenable: _onDistrictChanged,
                            builder: (context, value, child) {
                              final overalData =
                                  value == 0
                                      ? dashboardEntity.overallTotal
                                      : dashboardEntity.districtWiseTotal
                                          ?.where((e) => e.district == '$value')
                                          .firstOrNull;
                              return Column(
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: double.infinity,
                                            padding: EdgeInsets.all(
                                              resources.dimen.dp10,
                                            ),
                                            decoration:
                                                BackgroundBoxDecoration(
                                                  boxColor:
                                                      resources
                                                          .color
                                                          .colorWhite,
                                                  radious: resources.dimen.dp10,
                                                ).roundedCornerBox,
                                            child: Text.rich(
                                              textAlign: TextAlign.end,
                                              TextSpan(
                                                text: 'Total participants\n',
                                                style:
                                                    context.textFontWeight600,
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        overalData
                                                            ?.totalScreened ??
                                                        '',
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontSize(
                                                          resources
                                                              .fontSize
                                                              .dp18,
                                                        )
                                                        .onColor(
                                                          resources
                                                              .color
                                                              .viewBgColor,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: resources.dimen.dp20),
                                        Expanded(
                                          child: Container(
                                            height: double.infinity,
                                            padding: EdgeInsets.all(
                                              resources.dimen.dp10,
                                            ),
                                            decoration:
                                                BackgroundBoxDecoration(
                                                  boxColor:
                                                      resources
                                                          .color
                                                          .colorWhite,
                                                  radious: resources.dimen.dp10,
                                                ).roundedCornerBox,
                                            child: Text.rich(
                                              textAlign: TextAlign.end,
                                              TextSpan(
                                                text: 'Total Screened\n',
                                                style:
                                                    context.textFontWeight600,
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        overalData
                                                            ?.totalScreened ??
                                                        '',
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontSize(
                                                          resources
                                                              .fontSize
                                                              .dp18,
                                                        )
                                                        .onColor(
                                                          resources
                                                              .color
                                                              .viewBgColor,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: resources.dimen.dp10),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: double.infinity,
                                            padding: EdgeInsets.all(
                                              resources.dimen.dp10,
                                            ),
                                            decoration:
                                                BackgroundBoxDecoration(
                                                  boxColor:
                                                      resources
                                                          .color
                                                          .colorWhite,
                                                  radious: resources.dimen.dp10,
                                                ).roundedCornerBox,
                                            child: Text.rich(
                                              textAlign: TextAlign.end,
                                              TextSpan(
                                                text: 'Hypertension\n',
                                                style:
                                                    context.textFontWeight600,
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        overalData
                                                            ?.hypertensionAbnormal ??
                                                        '',
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontSize(
                                                          resources
                                                              .fontSize
                                                              .dp18,
                                                        )
                                                        .onColor(
                                                          resources
                                                              .color
                                                              .viewBgColor,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: resources.dimen.dp10),
                                        Expanded(
                                          child: Container(
                                            height: double.infinity,
                                            padding: EdgeInsets.all(
                                              resources.dimen.dp10,
                                            ),
                                            decoration:
                                                BackgroundBoxDecoration(
                                                  boxColor:
                                                      resources
                                                          .color
                                                          .colorWhite,
                                                  radious: resources.dimen.dp10,
                                                ).roundedCornerBox,
                                            child: Text.rich(
                                              textAlign: TextAlign.end,
                                              TextSpan(
                                                text: 'Diabetes\n',
                                                style:
                                                    context.textFontWeight600,
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        overalData
                                                            ?.diabetesAbnormal ??
                                                        '',
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontSize(
                                                          resources
                                                              .fontSize
                                                              .dp18,
                                                        )
                                                        .onColor(
                                                          resources
                                                              .color
                                                              .viewBgColor,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: resources.dimen.dp10),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: double.infinity,
                                            padding: EdgeInsets.all(
                                              resources.dimen.dp10,
                                            ),
                                            decoration:
                                                BackgroundBoxDecoration(
                                                  boxColor:
                                                      resources
                                                          .color
                                                          .colorWhite,
                                                  radious: resources.dimen.dp10,
                                                ).roundedCornerBox,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Cancer',
                                                  style:
                                                      context.textFontWeight600,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text.rich(
                                                        textAlign:
                                                            TextAlign.center,
                                                        TextSpan(
                                                          text: 'oral',
                                                          style: context
                                                              .textFontWeight600
                                                              .onFontSize(
                                                                resources
                                                                    .fontSize
                                                                    .dp10,
                                                              ),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  '\n${overalData?.cancerAbnormal ?? ''}',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                    resources
                                                                        .fontSize
                                                                        .dp18,
                                                                  )
                                                                  .onColor(
                                                                    resources
                                                                        .color
                                                                        .viewBgColor,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text.rich(
                                                        textAlign:
                                                            TextAlign.center,
                                                        TextSpan(
                                                          text: 'Breast',
                                                          style: context
                                                              .textFontWeight600
                                                              .onFontSize(
                                                                resources
                                                                    .fontSize
                                                                    .dp10,
                                                              ),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  '\n${overalData?.cancerScreened ?? '10'}',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                    resources
                                                                        .fontSize
                                                                        .dp18,
                                                                  )
                                                                  .onColor(
                                                                    resources
                                                                        .color
                                                                        .viewBgColor,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text.rich(
                                                        textAlign:
                                                            TextAlign.center,
                                                        TextSpan(
                                                          text: 'Cervical',
                                                          style: context
                                                              .textFontWeight600
                                                              .onFontSize(
                                                                resources
                                                                    .fontSize
                                                                    .dp10,
                                                              ),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  '\n${overalData?.cancerReferred ?? '12'}',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                    resources
                                                                        .fontSize
                                                                        .dp18,
                                                                  )
                                                                  .onColor(
                                                                    resources
                                                                        .color
                                                                        .viewBgColor,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: resources.dimen.dp20),
                                        Expanded(
                                          child: Container(
                                            height: double.infinity,
                                            padding: EdgeInsets.all(
                                              resources.dimen.dp10,
                                            ),
                                            decoration:
                                                BackgroundBoxDecoration(
                                                  boxColor:
                                                      resources
                                                          .color
                                                          .colorWhite,
                                                  radious: resources.dimen.dp10,
                                                ).roundedCornerBox,
                                            child: Text.rich(
                                              textAlign: TextAlign.end,
                                              TextSpan(
                                                text: 'HIV Reactive\n',
                                                style:
                                                    context.textFontWeight600,
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        overalData
                                                            ?.hivReactive ??
                                                        '',
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontSize(
                                                          resources
                                                              .fontSize
                                                              .dp18,
                                                        )
                                                        .onColor(
                                                          resources
                                                              .color
                                                              .viewBgColor,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          SizedBox(height: resources.dimen.dp10),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: (FormEntity()
                                      ..type = 'labelheader'
                                      ..labelEn =
                                          'Distric Wise Data'.toUpperCase()
                                      ..labelTe =
                                          'Distric Wise Data'.toUpperCase())
                                    .getWidget(context),
                              ),
                              SizedBox(width: resources.dimen.dp10),
                              Expanded(
                                flex: 1,
                                child: (FormEntity()
                                      ..type = 'collection'
                                      ..fieldValue = months.firstWhere(
                                        (m) => m.id == DateTime.now().month,
                                      )
                                      ..inputFieldData = {
                                        'items': months,
                                        'doSort': false,
                                      }
                                      ..onDatachnage = (value) async {
                                        _onMonthChanged.value =
                                            value.id < 10
                                                ? '0${value.id}'
                                                : '${value.id}';
                                      })
                                    .getWidget(context),
                              ),
                            ],
                          ),
                          ValueListenableBuilder(
                            valueListenable: _onMonthChanged,
                            builder: (context, value, child) {
                              return FutureBuilder(
                                future: _serviceBloc.getMonthwiseData(
                                  requestParams: {
                                    'year': '2025',
                                    'month': value,
                                  },
                                ),
                                builder: (context, snapShot) {
                                  final districtWiseMonthly = List.empty(
                                    growable: true,
                                  );
                                  final state = snapShot.data;
                                  if (state is ServicesStateSuccess) {
                                    districtWiseMonthly.addAll(
                                      cast<DashboardEntity>(
                                            state.responseEntity.entity,
                                          ).districtWiseMonthly ??
                                          [],
                                    );
                                    (districtWiseMonthly).sort(
                                      (a, b) => (a.districtName ?? '')
                                          .compareTo(b.districtName ?? ''),
                                    );
                                  }
                                  return ReportListWidget(
                                    ticketsHeaderData: [
                                      'Distric',
                                      'HIV',
                                      'Cancer',
                                      'Diabetes',
                                      'Hypertension',
                                      'Total',
                                    ],
                                    ticketsTableColunwidths: {
                                      0: const FlexColumnWidth(4),
                                      1: const FlexColumnWidth(2),
                                      2: const FlexColumnWidth(2),
                                      3: const FlexColumnWidth(2),
                                      4: const FlexColumnWidth(2),
                                      5: const FlexColumnWidth(2),
                                    },
                                    totalPagecount:
                                        (districtWiseMonthly.length / 10)
                                            .ceil(),
                                    reportData: districtWiseMonthly.sublist(
                                      0,
                                      min(10, districtWiseMonthly.length),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
