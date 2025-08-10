import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/domain/entities/services_entity.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/report_list_widget.dart';
import 'package:shareindia_health_camp/presentation/reports/add_field_agent_screen.dart';
import 'package:shareindia_health_camp/presentation/utils/dialogs.dart';
import '../../domain/entities/user_credentials_entity.dart';
import '../../injection_container.dart';

// ignore: must_be_immutable
class AgentListScreen extends BaseScreenWidget {
  static start(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: AgentListScreen(),
      ),
    );
  }

  AgentListScreen({super.key});
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();
  // final _masterDataBloc = sl<MasterDataBloc>();
  ReportDataEntity? reportData;
  int? index;
  int? totalPagecount;
  final ValueNotifier<bool> _onFilterChange = ValueNotifier(false);
  // final ValueNotifier<UserEntity?> _selectedEmployee = ValueNotifier(null);
  String? selectedStatus;
  Map<String, dynamic>? filteredData;
  final ValueNotifier<List<String>> filteredDates = ValueNotifier([]);
  final ValueNotifier<List<dynamic>> _mandalList = ValueNotifier([]);

  List<Widget> _getFilterBar(BuildContext context) {
    final resources = context.resources;
    return [
      Row(
        children: [
          Expanded(child: Text('Agents', style: context.textFontWeight600)),

          InkWell(
            onTap: () async {
              AddFieldAgentScreen.start(context);
            },
            child: ActionButtonWidget(
              text: 'Add Field Agent',
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
      SizedBox(height: resources.dimen.dp20),
    ];
  }

  _updateTickets(BuildContext context) async {
    Dialogs.loader(context);
    final responseState = await _servicesBloc.getAgentsList(
      requestParams: {
        'district_id': UserCredentialsEntity.details(context).user?.districtId,
      },
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

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    Future.delayed(Duration.zero, () {
      if (context.mounted) {
        _updateTickets(context);
      }
    });
    final ticketsHeaderData = ['Name', 'Mobile Number', 'Action'];
    final ticketsTableColunwidths = {
      0: const FlexColumnWidth(4),
      1: const FlexColumnWidth(4),
      2: const FlexColumnWidth(2),
    };
    return SafeArea(
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
                        return ReportListWidget(
                          reportData: reportData?.reportList ?? [],
                          ticketsHeaderData: ticketsHeaderData,
                          ticketsTableColunwidths: ticketsTableColunwidths,
                          page: reportData?.page ?? 1,
                          totalPagecount: reportData?.pages ?? 0,
                          onTicketSelected: (ticket) {},
                          onPageChange: (page) {
                            index = page;
                            if (page <= (reportData?.pages ?? 0)) {
                              _updateTickets(context);
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
