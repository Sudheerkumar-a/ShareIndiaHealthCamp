// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:dartz/dartz.dart' show cast;
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
import 'package:shareindia_health_camp/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/report_list_widget.dart';
import 'package:shareindia_health_camp/presentation/home/filter_by_category_screen.dart';
import 'package:shareindia_health_camp/presentation/reports/camp_list_screen.dart';
import 'package:shareindia_health_camp/presentation/utils/dialogs.dart';
import 'package:shareindia_health_camp/res/drawables/background_box_decoration.dart';
import 'package:shareindia_health_camp/res/resources.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final _serviceBloc = sl<ServicesBloc>();

  final _onMonthChanged = ValueNotifier('');

  final _onPageChanged = ValueNotifier(false);

  final _onDistrictChanged = ValueNotifier(0);

  final isapiCalled = false;

  int? districtId;

  int? mandalId;

  int pageIndex = 0;

  final ValueNotifier<ServicesState> _currentState = ValueNotifier(
    ServicesStateLoading(),
  );

  final ValueNotifier<List<String>> filteredDates = ValueNotifier([]);

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

  _requestDataRefresh() {
    Future.delayed(Duration(milliseconds: 500), () {
      pageIndex = 0;
      _serviceBloc.getDashboardData(
        requestParams: {
          'district': districtId == 0 ? null : districtId,
          'mandal': mandalId == 0 ? null : mandalId,
          'start_date':
              filteredDates.value.length > 1 ? filteredDates.value[0] : null,
          'end_date':
              filteredDates.value.length > 1 ? filteredDates.value[1] : null,
        },
        emitResponse: true,
      );
    });
  }

  List<Widget> _getHeaderData(
    BuildContext context,
    Resources resources,
    bool isAdmin,
  ) {
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
    return [
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
                ..name = 'district'
                ..placeholder = filterTitle
                ..canSearch = true
                ..verticalSpace = 5
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
                        ..insert(
                          0,
                          NameIDEntity()
                            ..id = 0
                            ..name = 'ALL',
                        ),
                }
                ..onDatachnage = (value) {
                  districtId = value.id;
                  //_onDistrictChanged.value = value.id;
                  _requestDataRefresh();
                })
              .getWidget(context)
          : FutureBuilder(
            future: _serviceBloc.getMandalList(
              requestParams: {
                'dist_id':
                    UserCredentialsEntity.details(context).user?.district,
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
                    cast<ListEntity>(responseState.responseEntity.entity).items;
                items.addAll(mandals.cast<NameIDEntity>());
              }
              return (FormEntity()
                    ..type = 'collection'
                    ..name = 'mandal'
                    ..placeholder = filterTitle
                    ..canSearch = true
                    ..inputFieldData = {'doSort': false, 'items': items}
                    ..onDatachnage = (value) {
                      mandalId = value.id;
                      //_onDistrictChanged.value = value.id;
                      _requestDataRefresh();
                    })
                  .getWidget(context);
            },
          ),
      SizedBox(height: resources.dimen.dp10),
      Row(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: filteredDates,
              builder: (context, value, child) {
                return Container(
                  height: resources.dimen.dp40,
                  decoration:
                      BackgroundBoxDecoration(
                        radious: resources.dimen.dp10,
                        boarderColor: resources.color.sideBarItemUnselected,
                        boarderWidth: 1,
                      ).roundedCornerBox,
                  padding: EdgeInsets.symmetric(vertical: resources.dimen.dp5),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: resources.dimen.dp10),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime.now().add(
                                const Duration(days: -365),
                              ),
                              lastDate: DateTime.now(),
                            ).then((dateTime) {
                              if (dateTime != null) {
                                filteredDates.value = List<String>.empty(
                                  growable: true,
                                )..add(getDateByformat('yyyy/MM/dd', dateTime));
                              }
                            });
                          },
                          child: Text.rich(
                            TextSpan(
                              text:
                                  value.isNotEmpty
                                      ? value[0]
                                      : resources.string.startDate,
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: const Icon(
                                      Icons.calendar_month_sharp,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            style: context.textFontWeight400.onFontSize(
                              resources.fontSize.dp12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: resources.dimen.dp10),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (value.isNotEmpty) {
                              showDatePicker(
                                context: context,
                                initialDate: getDateTimeByString(
                                  'yyyy/MM/dd',
                                  value[0],
                                ),
                                firstDate: getDateTimeByString(
                                  'yyyy/MM/dd',
                                  value[0],
                                ),
                                lastDate: DateTime.now(),
                              ).then((dateTime) {
                                if (dateTime != null) {
                                  filteredDates.value =
                                      List<String>.empty(growable: true)
                                        ..add(value[0])
                                        ..add(
                                          getDateByformat(
                                            'yyyy/MM/dd',
                                            dateTime.add(
                                              const Duration(hours: 24),
                                            ),
                                          ),
                                        );
                                  if (context.mounted) {
                                    //_updateReport(context);
                                    _requestDataRefresh();
                                  }
                                }
                              });
                            } else {
                              Dialogs.showInfoDialog(
                                context,
                                PopupType.fail,
                                resources.string.pleaseSelect +
                                    resources.string.startDate,
                              );
                            }
                          },
                          child: Text.rich(
                            TextSpan(
                              text:
                                  value.length > 1
                                      ? value[1]
                                      : resources.string.endDate,
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: const Icon(
                                      Icons.calendar_month_sharp,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            style: context.textFontWeight400.onFontSize(
                              resources.fontSize.dp12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: resources.dimen.dp5),
                      InkWell(
                        onTap: () {
                          if (filteredDates.value.isNotEmpty) {
                            filteredDates.value = List.empty();
                            // _updateReport(context);
                            _requestDataRefresh();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Icons.clear, size: 16),
                        ),
                      ),
                      SizedBox(width: resources.dimen.dp5),
                    ],
                  ),
                );
              },
            ),
          ),
          // SizedBox(width: resources.dimen.dp10),
          // InkWell(
          //   onTap: () async {},

          //   child: ActionButtonWidget(
          //     text: 'Search',
          //     radious: resources.dimen.dp15,
          //     textSize: resources.fontSize.dp12,
          //     padding: EdgeInsets.symmetric(
          //       vertical: resources.dimen.dp5,
          //       horizontal: resources.dimen.dp15,
          //     ),
          //     color: resources.color.viewBgColorLight,
          //   ),
          // ),
        ],
      ),

      SizedBox(height: resources.dimen.dp10),
    ];
  }

  @override
  void initState() {
    districtId = UserCredentialsEntity.details(context).user?.districtId ?? 0;
    Future.delayed(Duration.zero, () {
      _requestDataRefresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final isAdmin = UserCredentialsEntity.details(context).user?.isAdmin == 1;
    _onMonthChanged.value = getDateByformat('MM', DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: BlocProvider<ServicesBloc>(
        create: (newContext) => _serviceBloc,
        child: BlocListener<ServicesBloc, ServicesState>(
          listener: (context, state) {
            _currentState.value = state;
          },
          child: Column(
            children: [
              ..._getHeaderData(context, resources, isAdmin),
              ValueListenableBuilder(
                valueListenable: _currentState,
                builder: (newContext, state, child) {
                  if (state is ServicesStateLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ServicesStateApiError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: context.textFontWeight600,
                      ),
                    );
                  } else if (state is ServicesStateSuccess) {
                    final dashboardEntity = cast<DashboardEntity>(
                      state.responseEntity.entity,
                    );
                    final districtWiseMonthly =
                        dashboardEntity.districtWiseTotal ?? [];
                    (districtWiseMonthly).sort(
                      (a, b) => (a.districtName ?? '').compareTo(
                        b.districtName ?? '',
                      ),
                    );
                    final overalData = dashboardEntity.overallTotal;
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IntrinsicHeight(
                              child: Container(
                                height: double.infinity,
                                padding: EdgeInsets.all(resources.dimen.dp10),
                                decoration:
                                    BackgroundBoxDecoration(
                                      boxColor: resources.color.colorWhite,
                                      radious: resources.dimen.dp10,
                                    ).roundedCornerBox,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          // _navigateToFilterScreen(
                                          //   context,
                                          //   1,
                                          //   isAdmin,
                                          // );
                                          CampListScreen.start(
                                            context,
                                            districtId:
                                                districtId == 0
                                                    ? null
                                                    : districtId,
                                            mandalId:
                                                mandalId == 0 ? null : mandalId,
                                            startDate:
                                                filteredDates.value.length > 1
                                                    ? filteredDates.value[0]
                                                    : null,
                                            endDate:
                                                filteredDates.value.length > 1
                                                    ? filteredDates.value[1]
                                                    : null,
                                            canEdit: false,
                                          );
                                        },
                                        child: Text(
                                          textAlign: TextAlign.left,
                                          'Total Camps',
                                          style: context.textFontWeight600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: resources.dimen.dp20),
                                    InkWell(
                                      onTap: () {
                                        _navigateToFilterScreen(
                                          context,
                                          1,
                                          isAdmin,
                                        );
                                      },
                                      child: Text.rich(
                                        textAlign: TextAlign.center,
                                        TextSpan(
                                          text: overalData?.totalCamps ?? '0',
                                          style: context.textFontWeight600
                                              .onFontSize(22)
                                              .onColor(
                                                resources.color.viewBgColor,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                                  resources.color.colorWhite,
                                              radious: resources.dimen.dp10,
                                            ).roundedCornerBox,
                                        child: Text.rich(
                                          textAlign: TextAlign.center,
                                          TextSpan(
                                            text:
                                                '${resources.string.totalClient}\n',
                                            style: context.textFontWeight600,
                                            children: [
                                              TextSpan(
                                                text:
                                                    overalData?.totalClient ??
                                                    '',
                                                style: context.textFontWeight600
                                                    .onFontSize(
                                                      resources.fontSize.dp20,
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
                                                  resources.color.colorWhite,
                                              radious: resources.dimen.dp10,
                                            ).roundedCornerBox,
                                        child: Text.rich(
                                          textAlign: TextAlign.center,
                                          TextSpan(
                                            text:
                                                '${resources.string.totalScreened}\n',
                                            style: context.textFontWeight600,
                                            children: [
                                              TextSpan(
                                                text:
                                                    overalData?.totalScreened ??
                                                    '',
                                                style: context.textFontWeight600
                                                    .onFontSize(
                                                      resources.fontSize.dp20,
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
                                                  resources.color.colorWhite,
                                              radious: resources.dimen.dp10,
                                            ).roundedCornerBox,
                                        child: Text.rich(
                                          textAlign: TextAlign.center,
                                          TextSpan(
                                            text:
                                                '${resources.string.hypertension}\n',
                                            style: context.textFontWeight600,
                                            children: [
                                              TextSpan(
                                                text:
                                                    overalData?.hypertension ??
                                                    '',
                                                style: context.textFontWeight600
                                                    .onFontSize(
                                                      resources.fontSize.dp20,
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
                                                  resources.color.colorWhite,
                                              radious: resources.dimen.dp10,
                                            ).roundedCornerBox,
                                        child: Text.rich(
                                          textAlign: TextAlign.center,
                                          TextSpan(
                                            text:
                                                '${resources.string.diabetes}\n',
                                            style: context.textFontWeight600,
                                            children: [
                                              TextSpan(
                                                text:
                                                    overalData?.diabetes ?? '',
                                                style: context.textFontWeight600
                                                    .onFontSize(
                                                      resources.fontSize.dp20,
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
                                                  resources.color.colorWhite,
                                              radious: resources.dimen.dp10,
                                            ).roundedCornerBox,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              resources.string.hepatitis,
                                              style: context.textFontWeight600,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text.rich(
                                                    textAlign: TextAlign.center,
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
                                                    textAlign: TextAlign.center,
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
                                                  resources.color.colorWhite,
                                              radious: resources.dimen.dp10,
                                            ).roundedCornerBox,
                                        child: Text.rich(
                                          textAlign: TextAlign.center,
                                          TextSpan(
                                            text:
                                                '${resources.string.huvReactive}\n',
                                            style: context.textFontWeight600,
                                            children: [
                                              TextSpan(
                                                text:
                                                    overalData?.hivReactive ??
                                                    '',
                                                style: context.textFontWeight600
                                                    .onFontSize(
                                                      resources.fontSize.dp20,
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
                                                  resources.color.colorWhite,
                                              radious: resources.dimen.dp10,
                                            ).roundedCornerBox,
                                        child: Text.rich(
                                          textAlign: TextAlign.center,
                                          TextSpan(
                                            text: 'Syphilis\n',
                                            style: context.textFontWeight600,
                                            children: [
                                              TextSpan(
                                                text:
                                                    overalData?.syphilis ?? '',
                                                style: context.textFontWeight600
                                                    .onFontSize(
                                                      resources.fontSize.dp20,
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
                                                  resources.color.colorWhite,
                                              radious: resources.dimen.dp10,
                                            ).roundedCornerBox,
                                        child: Text.rich(
                                          textAlign: TextAlign.center,
                                          TextSpan(
                                            text: 'STI Cases\n',
                                            style: context.textFontWeight600,
                                            children: [
                                              TextSpan(
                                                text:
                                                    overalData?.stiCases ?? '',
                                                style: context.textFontWeight600
                                                    .onFontSize(
                                                      resources.fontSize.dp20,
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

                            // ValueListenableBuilder(
                            //   valueListenable: _onDistrictChanged,
                            //   builder: (context, value, child) {

                            //     return ;
                            //   },
                            // ),
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
                                // SizedBox(width: resources.dimen.dp10),
                                // Expanded(
                                //   flex: 1,
                                //   child: DropDownWidget<NameIDEntity>(
                                //     selectedValue: months.firstWhere(
                                //       (m) => m.id == DateTime.now().month,
                                //     ),
                                //     callback: (value) async {
                                //       _onMonthChanged.value =
                                //           (value?.id ?? 0) < 10
                                //               ? '0${value?.id}'
                                //               : '${value?.id}';
                                //     },
                                //     list: months,
                                //   ),
                                // ),
                              ],
                            ),
                            ValueListenableBuilder(
                              valueListenable: _onPageChanged,
                              builder: (context, value, child) {
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
                                  page: pageIndex + 1,
                                  totalPagecount:
                                      (districtWiseMonthly.length / 10).ceil(),
                                  reportData: districtWiseMonthly.sublist(
                                    pageIndex * 10,
                                    min(
                                      (pageIndex * 10 + 10),
                                      districtWiseMonthly.length,
                                    ),
                                  ),
                                  onPageChange: (index) {
                                    pageIndex = index - 1;
                                    _onPageChanged.value =
                                        !(_onPageChanged.value);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
