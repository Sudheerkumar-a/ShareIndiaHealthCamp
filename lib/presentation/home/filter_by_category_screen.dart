import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/string_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/domain/entities/master_data_entities.dart';
import 'package:shareindia_health_camp/domain/entities/screening_entity.dart';
import 'package:shareindia_health_camp/domain/entities/services_entity.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/report_list_widget.dart';
import 'package:shareindia_health_camp/presentation/reports/view_screening_details.dart';
import 'package:shareindia_health_camp/presentation/utils/dialogs.dart';
import '../../domain/entities/user_credentials_entity.dart';
import '../../injection_container.dart';

// ignore: must_be_immutable
class FilterByCategoryScreen extends BaseScreenWidget {
  int category;
  int? districtId;
  int? mandalId;
  static start(
    BuildContext context,
    int category, {
    int? districtId,
    int? mandalId,
  }) {
    Navigator.of(context, rootNavigator: true).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: FilterByCategoryScreen(
          category: category,
          districtId: districtId,
          mandalId: mandalId,
        ),
      ),
    );
  }

  FilterByCategoryScreen({
    required this.category,
    this.districtId,
    this.mandalId,
    super.key,
  });
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();
  // final _masterDataBloc = sl<MasterDataBloc>();
  ReportDataEntity? reportData;
  int? index;
  int? totalPagecount;
  final ValueNotifier<bool> _onFilterChange = ValueNotifier(false);
  // final ValueNotifier<UserEntity?> _selectedEmployee = ValueNotifier(null);
  int isAdmin = 1;
  String? selectedStatus;
  Map<String, dynamic>? filteredData;
  final ValueNotifier<List<String>> filteredDates = ValueNotifier([]);

  List<Widget> _getFilterBar(BuildContext context) {
    final resources = context.resources;
    String title = '';
    switch (category) {
      case 2:
        {
          title = resources.string.totalScreened;
        }
      case 3:
        {
          title = resources.string.hypertension;
        }
      case 4:
        {
          title = resources.string.diabetes;
        }
      case 5:
        {
          title = resources.string.hepatitis;
        }
      case 6:
        {
          title = resources.string.huvReactive;
        }
      case 7:
        {
          title = 'Syphilis';
        }
      case 8:
        {
          title = 'STI Cases';
        }
      default:
        {
          title = resources.string.totalClient;
        }
    }
    return [
      Row(
        children: [
          Expanded(child: Text(title, style: context.textFontWeight600)),

          SizedBox(width: resources.dimen.dp20),
          InkWell(
            onTap: () async {
              Dialogs.loader(context);
              await exportToExcel(
                ExportDataEntity()
                  ..title = 'IHS_Clients_Report'
                  ..date = getDateByformat('dd-MM-yyyy', DateTime.now())
                  ..columns =
                      ScreeningDetailsEntity()
                          .toFilterJson(category)
                          .keys
                          .map((e) => e.replaceAll('_', ' ').capitalize())
                          .toList()
                  ..rows = reportData?.reportList ?? [],
                category: category,
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
        switch (category) {
          case 2:
            {
              reportData?.reportList =
                  reportData?.reportList.where((e) => e.didConset).toList() ??
                  [];
            }
          case 3:
            {
              reportData?.reportList =
                  reportData?.reportList
                      .where((e) => e.isHypertension)
                      .toList() ??
                  [];
            }
          case 4:
            {
              reportData?.reportList =
                  reportData?.reportList.where((e) => e.isDiabitic).toList() ??
                  [];
            }
          case 5:
            {
              reportData?.reportList =
                  reportData?.reportList.where((e) => e.isHep).toList() ?? [];
            }
          case 6:
            {
              reportData?.reportList =
                  reportData?.reportList.where((e) => e.isHiv).toList() ?? [];
            }
          case 7:
            {
              reportData?.reportList =
                  reportData?.reportList.where((e) => e.isSyphilis).toList() ??
                  [];
            }
          case 8:
            {
              reportData?.reportList =
                  reportData?.reportList.where((e) => e.isSTICase).toList() ??
                  [];
            }
          default:
            {}
        }

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
    Map<String, dynamic> requestParams = {
      'limit': 1000,
      'page': index,
      'district': districtId,
      'mandal': mandalId,
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
    //districtId = UserCredentialsEntity.details(context).user?.districtId;
    //mandalId = UserCredentialsEntity.details(context).user?.mandalId;
    return SafeArea(
      bottom: true,
      child: Scaffold(
        appBar: MSearchUserAppBarWidget(
          title: 'Integrated Health Services (IHS)',
          showBack: true,
        ),
        body: Padding(
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
                            ScreeningDetailsEntity()
                                .toFilterJson(category)
                                .keys
                                .map((e) => e.replaceAll('_', ' ').capitalize())
                                .toList();
                        final ticketsTableColunwidths =
                            <int, FlexColumnWidth>{};
                        ticketsHeaderData.asMap().forEach((index, value) {
                          ticketsTableColunwidths[index] =
                              const FlexColumnWidth(4);
                        });
                        return ReportListWidget(
                          reportData: reportData?.reportList ?? [],
                          ticketsHeaderData: ticketsHeaderData,
                          ticketsTableColunwidths: ticketsTableColunwidths,
                          page: reportData?.page ?? 0,
                          totalPagecount: reportData?.pages ?? 0,
                          getRowData:
                              (rowEntity) => rowEntity.toFilterJson(category),
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
        ),
      ),
    );
  }
}
