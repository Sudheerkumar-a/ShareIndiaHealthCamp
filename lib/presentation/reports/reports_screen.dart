import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/constants/data_constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/domain/entities/master_data_entities.dart';
import 'package:shareindia_health_camp/domain/entities/screening_entity.dart';
import 'package:shareindia_health_camp/domain/entities/services_entity.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/dropdown_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/report_list_widget.dart';
import 'package:shareindia_health_camp/presentation/reports/add_camp_form_screen.dart';
import 'package:shareindia_health_camp/presentation/reports/agent_list_screen.dart';
import 'package:shareindia_health_camp/presentation/reports/camp_list_screen.dart';
import 'package:shareindia_health_camp/presentation/reports/outreach_camp_form_screen.dart';
import 'package:shareindia_health_camp/presentation/reports/view_screening_details.dart';
import 'package:shareindia_health_camp/presentation/utils/dialogs.dart';
import '../../core/constants/constants.dart';
import '../../domain/entities/user_credentials_entity.dart';
import '../../injection_container.dart';
import '../../res/drawables/background_box_decoration.dart';
import '../common_widgets/alert_dialog_widget.dart';

// ignore: must_be_immutable
class ReportsScreen extends BaseScreenWidget {
  ReportsScreen({super.key});
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();
  // final _masterDataBloc = sl<MasterDataBloc>();
  ReportDataEntity? reportData;
  int? index;
  int? totalPagecount;
  final ValueNotifier<bool> _onFilterChange = ValueNotifier(false);
  // final ValueNotifier<UserEntity?> _selectedEmployee = ValueNotifier(null);
  int isAdmin = 1;
  int? districtId;
  int? mandalId;
  String? selectedStatus;
  Map<String, dynamic>? filteredData;
  final ValueNotifier<List<String>> filteredDates = ValueNotifier([]);
  final ValueNotifier<List<dynamic>> _mandalList = ValueNotifier([]);

  Widget _getFilters(BuildContext context) {
    final resources = context.resources;
    final districtsList =
        ListModel.fromDistrictsJson({'data': districts}).toEntity().items;
    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: resources.dimen.dp10,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: DropDownWidget(
                height: 40,
                hintText: 'District',
                errorMessage: "Select District",
                list: districtsList,
                selectedValue: null,
                iconSize: 20,
                fontStyle: context.textFontWeight400.onFontSize(
                  resources.fontSize.dp12,
                ),
                callback: (p0) async {
                  _mandalList.value = [];
                  filteredData ??= {};
                  filteredData?['dist_id'] = p0.id;
                  filteredData?['mandal_id'] = null;
                  final responseState = await _servicesBloc.getMandalList(
                    requestParams: {'dist_id': p0.id},
                  );
                  if (responseState is ServicesStateSuccess) {
                    _mandalList.value =
                        cast<ListEntity>(
                          responseState.responseEntity.entity,
                        ).items;
                  }
                },
              ),
            ),
          ],
        ),

        ValueListenableBuilder(
          valueListenable: _mandalList,
          builder: (context, list, child) {
            return SizedBox(
              width: 200,
              child: DropDownWidget(
                height: 40,
                hintText: 'Mandal',
                errorMessage: "Select Mandal",
                list: list,
                selectedValue: null,
                iconSize: 20,
                fontStyle: context.textFontWeight400.onFontSize(
                  resources.fontSize.dp12,
                ),
                callback: (p0) {
                  filteredData?['mandal_id'] = p0.id;
                },
              ),
            );
          },
        ),
        SizedBox(width: resources.dimen.dp10),
        InkWell(
          onTap: () async {
            index = 1;
            _updateReport(context);
          },
          child: ActionButtonWidget(
            text: 'Search',
            radious: resources.dimen.dp15,
            textSize: resources.fontSize.dp10,
            padding: EdgeInsets.symmetric(
              vertical: resources.dimen.dp5,
              horizontal: resources.dimen.dp15,
            ),
            color: resources.color.viewBgColorLight,
          ),
        ),
        SizedBox(width: resources.dimen.dp10),
        InkWell(
          onTap: () {
            index = 1;
            _updateReport(context);
          },
          child: ActionButtonWidget(
            text: resources.string.clear,
            padding: EdgeInsets.symmetric(
              vertical: resources.dimen.dp5,
              horizontal: resources.dimen.dp15,
            ),
            radious: resources.dimen.dp15,
            textSize: resources.fontSize.dp10,
            color: resources.color.colorGray9E9E9E,
          ),
        ),
      ],
    );
  }

  List<Widget> _getFilterBar(BuildContext context) {
    final resources = context.resources;
    return [
      Row(
        children: [
          Expanded(
            child: Text(
              resources.string.report,
              style: context.textFontWeight600,
            ),
          ),
        ],
      ),
      if (UserCredentialsEntity.details(context).user?.isAdmin != 1) ...[
        SizedBox(height: resources.dimen.dp20),
        Row(
          children: [
            if (UserCredentialsEntity.details(context).user?.isAdmin == 0) ...[
              InkWell(
                onTap: () async {
                  AgentListScreen.start(context);
                },
                child: ActionButtonWidget(
                  text: 'Add M-ICTC counsellor/LT',
                  radious: resources.dimen.dp15,
                  textSize: resources.fontSize.dp12,
                  padding: EdgeInsets.symmetric(
                    vertical: resources.dimen.dp5,
                    horizontal: resources.dimen.dp15,
                  ),
                  color: resources.color.viewBgColorLight,
                ),
              ),
            ],
            Spacer(),
            SizedBox(width: resources.dimen.dp10),
            InkWell(
              onTap: () async {
                CampListScreen.start(context).then((doRefresh) {
                  if (doRefresh && context.mounted) {
                    _updateReport(context);
                  }
                });
              },
              child: ActionButtonWidget(
                text: 'Add New Record',
                radious: resources.dimen.dp15,
                textSize: resources.fontSize.dp12,
                padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp5,
                  horizontal: resources.dimen.dp15,
                ),
                color: resources.color.viewBgColorLight,
              ),
            ),
          ],
        ),
      ],
      if (UserCredentialsEntity.details(context).user?.isAdmin == 1) ...[
        SizedBox(width: resources.dimen.dp20, height: resources.dimen.dp20),
        _getFilters(context),
      ],
      SizedBox(height: resources.dimen.dp20),
      Row(
        children: [
          Visibility(
            visible: true,
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
                  margin: EdgeInsets.only(right: resources.dimen.dp10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: resources.dimen.dp10),
                      InkWell(
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
                                  padding:
                                      isSelectedLocalEn
                                          ? const EdgeInsets.only(left: 5.0)
                                          : const EdgeInsets.only(right: 5.0),
                                  child: const Icon(
                                    Icons.calendar_month_sharp,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          style: context.textFontWeight400.onFontSize(
                            resources.fontSize.dp10,
                          ),
                        ),
                      ),
                      SizedBox(width: resources.dimen.dp10),
                      InkWell(
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
                                  _updateReport(context);
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
                                  padding:
                                      isSelectedLocalEn
                                          ? const EdgeInsets.only(left: 5.0)
                                          : const EdgeInsets.only(right: 5.0),
                                  child: const Icon(
                                    Icons.calendar_month_sharp,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          style: context.textFontWeight400.onFontSize(
                            resources.fontSize.dp10,
                          ),
                        ),
                      ),
                      SizedBox(width: resources.dimen.dp5),
                      InkWell(
                        onTap: () {
                          if (filteredDates.value.isNotEmpty) {
                            filteredDates.value = List.empty();
                            _updateReport(context);
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
          SizedBox(width: resources.dimen.dp10),
          InkWell(
            onTap: () async {
              Dialogs.loader(context);
              await exportToExcel(
                ExportDataEntity()
                  ..title = 'IHS_Clients_Report'
                  ..date = getDateByformat('dd-MM-yyyy', DateTime.now())
                  ..columns = ScreeningDetailsEntity().toJson().keys.toList()
                  ..rows = reportData?.reportList ?? [],
              );
              if (context.mounted) {
                Dialogs.dismiss(context);
              }
            },

            child: ActionButtonWidget(
              text: 'Export to Excel',
              radious: resources.dimen.dp15,
              textSize: resources.fontSize.dp12,
              padding: EdgeInsets.symmetric(
                vertical: resources.dimen.dp5,
                horizontal: resources.dimen.dp15,
              ),
              color: resources.color.viewBgColorLight,
            ),
          ),
        ],
      ),
    ];
  }

  _updateReport(BuildContext context) async {
    Dialogs.loader(context);
    final responseState = await _servicesBloc.getReportsData(
      requestParams: _getFilteredData(index ?? 1),
    );
    if (context.mounted) {
      Dialogs.dismiss(context);
      if (responseState is ServicesStateSuccess) {
        reportData = cast<ReportDataEntity>(
          responseState.responseEntity.entity,
        );
        totalPagecount = reportData?.total;
      }
      _onFilterChange.value = !_onFilterChange.value;
    }
  }

  Map<String, dynamic> _getFilteredData(int? index) {
    String? startDate;
    String? endDate;
    if (filteredDates.value.isNotEmpty) {
      var dateFormat = DateFormat('dd-MMM-yyyy HH:mm');
      var startTime = DateFormat('yyyy/MM/dd').parse(filteredDates.value[0]);
      var endTime = DateFormat('yyyy/MM/dd').parse(filteredDates.value[1]);
      startDate = dateFormat.format(startTime);
      endDate = dateFormat.format(endTime);
    }
    Map<String, dynamic> requestParams =
        isAdmin == 0
            ? {
              'limit': 10,
              'page': index,
              'district': districtId,
              'mandal': null,
              'state': 'Andhra Pradesh',
              'date_from': startDate,
              'date_to': endDate,
            }
            : isAdmin == 2
            ? {
              'limit': 10,
              'page': index,
              'district': districtId,
              'mandal': mandalId,
              'state': 'Andhra Pradesh',
              'date_from': startDate,
              'date_to': endDate,
            }
            : {
              'limit': 10,
              'page': index,
              'district': filteredData?['dist_id'],
              'mandal': filteredData?['mandal_id'],
              'state': 'Andhra Pradesh',
              'date_from': startDate,
              'date_to': endDate,
            };
    return requestParams;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    Future.delayed(Duration.zero, () {
      if (context.mounted) {
        _updateReport(context);
      }
    });

    isAdmin = UserCredentialsEntity.details(context).user?.isAdmin ?? 1;
    districtId = UserCredentialsEntity.details(context).user?.districtId;
    mandalId = UserCredentialsEntity.details(context).user?.mandalId;
    return Padding(
      padding: EdgeInsets.all(resources.dimen.dp20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getFilterBar(context),
            ),
            SizedBox(height: resources.dimen.dp20),
            ValueListenableBuilder(
              valueListenable: _onFilterChange,
              builder: (context, value, child) {
                return ValueListenableBuilder(
                  valueListenable: _onFilterChange,
                  builder: (context, value, child) {
                    final ticketsHeaderData =
                        ScreeningDetailsEntity().toJson().keys.toList();
                    final ticketsTableColunwidths = <int, FlexColumnWidth>{};
                    ticketsHeaderData.asMap().forEach((index, value) {
                      ticketsTableColunwidths[index] = const FlexColumnWidth(4);
                    });
                    return ReportListWidget(
                      reportData: reportData?.reportList ?? [],
                      ticketsHeaderData: ticketsHeaderData,
                      ticketsTableColunwidths: ticketsTableColunwidths,
                      page: reportData?.page ?? 1,
                      totalPagecount: reportData?.pages ?? 0,
                      onColumnClick: (key, ticket) {
                        ViewScreeningDetails.start(
                          context,
                          cast<ScreeningDetailsEntity>(ticket),
                        );
                      },
                      onPageChange: (page) {
                        index = page;
                        if (page <= (reportData?.pages ?? 0)) {
                          _updateReport(context);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
