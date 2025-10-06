// ignore_for_file: must_be_immutable

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
import 'package:shareindia_health_camp/domain/entities/user_credentials_entity.dart';
import 'package:shareindia_health_camp/injection_container.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/report_list_widget.dart';
import 'package:shareindia_health_camp/presentation/home/filter_by_category_screen.dart';
import 'package:shareindia_health_camp/res/drawables/background_box_decoration.dart';

class UserDashboard extends BaseScreenWidget {
  UserDashboard({super.key});
  final _serviceBloc = sl<ServicesBloc>();
  final _onMonthChanged = ValueNotifier('');
  final _onDistrictChanged = ValueNotifier(0);
  int? districtId;
  int? mandalId;
  _navigateToFilterScreen(BuildContext context, int category, bool isAdmin) {
    FilterByCategoryScreen.start(
      context,
      category,
      districtId:
          isAdmin
              ? districtId
              : UserCredentialsEntity.details(context).user?.districtId,
      mandalId: mandalId,
    );
  }

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
              return Center(child: CircularProgressIndicator());
            } else if (state is ServicesStateApiError) {
              return Center(
                child: Text(state.message, style: context.textFontWeight600),
              );
            } else if (state is ServicesStateSuccess) {
              final dashboardEntity = cast<DashboardEntity>(
                state.responseEntity.entity,
              );

              final isAdmin =
                  UserCredentialsEntity.details(context).user?.isAdmin == 1;
              final title =
                  isAdmin
                      ? 'Andhra Pradesh'.toUpperCase()
                      : districts
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
                          .firstOrNull?['name']
                          ?.toUpperCase();
              final filterTitle =
                  isAdmin
                      ? resources.string.selectDistrict
                      : resources.string.selectMandal;

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
                                      ..label = resources.string.dashboard)
                                    .getWidget(context),
                              ),
                              SizedBox(width: resources.dimen.dp10),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: (FormEntity()
                                        ..type = 'labelheader'
                                        ..label = title)
                                      .getWidget(context),
                                ),
                              ),
                            ],
                          ),
                          isAdmin
                              ? (FormEntity()
                                    ..type = 'collection'
                                    ..placeholder = filterTitle
                                    ..inputFieldData = {
                                      'items':
                                          districts
                                              .map(
                                                (item) =>
                                                    NameIDModel.fromDistrictsJson(
                                                      item
                                                          as Map<
                                                            String,
                                                            dynamic
                                                          >,
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
                                      districtId = value.id;
                                      _onDistrictChanged.value = value.id;
                                    })
                                  .getWidget(context)
                              : FutureBuilder(
                                future: _serviceBloc.getMandalList(
                                  requestParams: {
                                    'dist_id':
                                        UserCredentialsEntity.details(
                                          context,
                                        ).user?.district,
                                  },
                                ),
                                builder: (context, snapShot) {
                                  final items = [
                                    NameIDEntity()
                                      ..id = 0
                                      ..name = 'ALL',
                                  ];
                                  final responseState = snapShot.data;
                                  if (responseState is ServicesStateSuccess) {
                                    final mandals =
                                        cast<ListEntity>(
                                          responseState.responseEntity.entity,
                                        ).items;
                                    items.addAll(mandals.cast<NameIDEntity>());
                                  }
                                  return (FormEntity()
                                        ..type = 'collection'
                                        ..placeholder = filterTitle
                                        ..inputFieldData = {
                                          'doSort': false,
                                          'items': items,
                                        }
                                        ..onDatachnage = (value) {
                                          mandalId = value.id;
                                          _onDistrictChanged.value = value.id;
                                        })
                                      .getWidget(context);
                                },
                              ),
                          SizedBox(height: resources.dimen.dp10),
                          ValueListenableBuilder(
                            valueListenable: _onDistrictChanged,
                            builder: (context, value, child) {
                              final overalData =
                                  value == 0
                                      ? dashboardEntity.overallTotal
                                      : dashboardEntity.districtWiseTotal
                                          ?.where(
                                            (e) =>
                                                isAdmin
                                                    ? (e.districtId == '$value')
                                                    : (e.mandalId == '$value'),
                                          )
                                          .firstOrNull;
                              return Column(
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _navigateToFilterScreen(
                                                context,
                                                1,
                                                isAdmin,
                                              );
                                            },
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
                                                    radious:
                                                        resources.dimen.dp10,
                                                  ).roundedCornerBox,
                                              child: Text.rich(
                                                textAlign: TextAlign.center,
                                                TextSpan(
                                                  text:
                                                      '${resources.string.totalClient}\n',
                                                  style:
                                                      context.textFontWeight600,
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          overalData
                                                              ?.totalClient ??
                                                          '',
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontSize(
                                                            resources
                                                                .fontSize
                                                                .dp20,
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
                                        ),
                                        SizedBox(width: resources.dimen.dp20),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _navigateToFilterScreen(
                                                context,
                                                2,
                                                isAdmin,
                                              );
                                            },
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
                                                    radious:
                                                        resources.dimen.dp10,
                                                  ).roundedCornerBox,
                                              child: Text.rich(
                                                textAlign: TextAlign.center,
                                                TextSpan(
                                                  text:
                                                      '${resources.string.totalScreened}\n',
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
                                                                .dp20,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: resources.dimen.dp10),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _navigateToFilterScreen(
                                                context,
                                                3,
                                                isAdmin,
                                              );
                                            },
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
                                                    radious:
                                                        resources.dimen.dp10,
                                                  ).roundedCornerBox,
                                              child: Text.rich(
                                                textAlign: TextAlign.center,
                                                TextSpan(
                                                  text:
                                                      '${resources.string.hypertension}\n',
                                                  style:
                                                      context.textFontWeight600,
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          overalData
                                                              ?.hypertension ??
                                                          '',
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontSize(
                                                            resources
                                                                .fontSize
                                                                .dp20,
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
                                        ),
                                        SizedBox(width: resources.dimen.dp10),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _navigateToFilterScreen(
                                                context,
                                                4,
                                                isAdmin,
                                              );
                                            },
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
                                                    radious:
                                                        resources.dimen.dp10,
                                                  ).roundedCornerBox,
                                              child: Text.rich(
                                                textAlign: TextAlign.center,
                                                TextSpan(
                                                  text:
                                                      '${resources.string.diabetes}\n',
                                                  style:
                                                      context.textFontWeight600,
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          overalData
                                                              ?.diabetes ??
                                                          '',
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontSize(
                                                            resources
                                                                .fontSize
                                                                .dp20,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: resources.dimen.dp10),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _navigateToFilterScreen(
                                                context,
                                                5,
                                                isAdmin,
                                              );
                                            },
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
                                                    radious:
                                                        resources.dimen.dp10,
                                                  ).roundedCornerBox,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    resources.string.hepatitis,
                                                    style:
                                                        context
                                                            .textFontWeight600,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Text.rich(
                                                          textAlign:
                                                              TextAlign.center,
                                                          TextSpan(
                                                            text: 'B',
                                                            style:
                                                                context
                                                                    .textFontWeight600,
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    '\n${overalData?.hepatitisA ?? '0'}',
                                                                style: context
                                                                    .textFontWeight600
                                                                    .onFontSize(
                                                                      resources
                                                                          .fontSize
                                                                          .dp20,
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
                                                            text: 'C',
                                                            style:
                                                                context
                                                                    .textFontWeight600,
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    '\n${overalData?.hepatitisB ?? '0'}',
                                                                style: context
                                                                    .textFontWeight600
                                                                    .onFontSize(
                                                                      resources
                                                                          .fontSize
                                                                          .dp20,
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
                                        ),
                                        SizedBox(width: resources.dimen.dp20),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _navigateToFilterScreen(
                                                context,
                                                6,
                                                isAdmin,
                                              );
                                            },
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
                                                    radious:
                                                        resources.dimen.dp10,
                                                  ).roundedCornerBox,
                                              child: Text.rich(
                                                textAlign: TextAlign.center,
                                                TextSpan(
                                                  text:
                                                      '${resources.string.huvReactive}\n',
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
                                                                .dp20,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: resources.dimen.dp20),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _navigateToFilterScreen(
                                                context,
                                                7,
                                                isAdmin,
                                              );
                                            },
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
                                                    radious:
                                                        resources.dimen.dp10,
                                                  ).roundedCornerBox,
                                              child: Text.rich(
                                                textAlign: TextAlign.center,
                                                TextSpan(
                                                  text: 'Syphilis\n',
                                                  style:
                                                      context.textFontWeight600,
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          overalData
                                                              ?.syphilis ??
                                                          '',
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontSize(
                                                            resources
                                                                .fontSize
                                                                .dp20,
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
                                        ),
                                        SizedBox(width: resources.dimen.dp20),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _navigateToFilterScreen(
                                                context,
                                                8,
                                                isAdmin,
                                              );
                                            },
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
                                                    radious:
                                                        resources.dimen.dp10,
                                                  ).roundedCornerBox,
                                              child: Text.rich(
                                                textAlign: TextAlign.center,
                                                TextSpan(
                                                  text: 'STI Cases\n',
                                                  style:
                                                      context.textFontWeight600,
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          overalData
                                                              ?.stiCases ??
                                                          '',
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontSize(
                                                            resources
                                                                .fontSize
                                                                .dp20,
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
                                      ..label =
                                          (isAdmin
                                                  ? resources
                                                      .string
                                                      .districtWiseData
                                                  : resources
                                                      .string
                                                      .mandalWiseData)
                                              .toUpperCase())
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
                                          ).districtWiseTotal ??
                                          [],
                                    );
                                    (districtWiseMonthly).sort(
                                      (a, b) => (a.districtName ?? '')
                                          .compareTo(b.districtName ?? ''),
                                    );
                                  }
                                  return ReportListWidget(
                                    ticketsHeaderData: [
                                      isAdmin
                                          ? resources.string.district
                                          : resources.string.mandal,
                                      resources.string.total,
                                      resources.string.hiv,
                                      resources.string.diabetes,
                                      resources.string.hypertension,
                                      'HepatitisB',
                                      'Syphilis',
                                      'HepatitisC',
                                      'StiCases',
                                    ],
                                    // ticketsTableColunwidths: {
                                    //   0: const FlexColumnWidth(4),
                                    //   1: const FlexColumnWidth(2),
                                    //   2: const FlexColumnWidth(2),
                                    //   3: const FlexColumnWidth(2),
                                    //   4: const FlexColumnWidth(2),
                                    //   5: const FlexColumnWidth(2),
                                    // },
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
