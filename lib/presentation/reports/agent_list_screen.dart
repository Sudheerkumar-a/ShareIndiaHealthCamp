import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/domain/entities/services_entity.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/discard_changes_dialog_widget.dart';
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
  AgentDataEntity? agentData;
  int? index;
  int? totalPagecount;
  final ValueNotifier<bool> _onFilterChange = ValueNotifier(false);
  // final ValueNotifier<UserEntity?> _selectedEmployee = ValueNotifier(null);
  String? selectedStatus;
  Map<String, dynamic>? filteredData;
  final ValueNotifier<List<String>> filteredDates = ValueNotifier([]);

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
        agentData = cast<AgentDataEntity>(responseState.responseEntity.entity);
        totalPagecount = agentData?.total;
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
    final ticketsHeaderData = ['Name', 'Email', 'Mobile Number', 'Action'];
    final ticketsTableColunwidths = {
      0: const FlexColumnWidth(4),
      1: const FlexColumnWidth(4),
      2: const FlexColumnWidth(4),
      3: const FlexColumnWidth(3),
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
                          reportData: agentData?.agentsList ?? [],
                          ticketsHeaderData: ticketsHeaderData,
                          ticketsTableColunwidths: ticketsTableColunwidths,
                          page: agentData?.page ?? 1,
                          totalPagecount: agentData?.pages ?? 0,
                          onRowSelected: (ticket) {},
                          onColumnClick: (p0, p1) async {
                            if (p0 == 'action') {
                              Dialogs.showContentHeightBottomSheetDialog(
                                context,
                                DiscardChangesDialog(
                                  data: {
                                    'title': 'Alert',
                                    'description': 'Do you want delete Agent',
                                    'action': 'Proceed',
                                  },
                                  callback: () async {
                                    Dialogs.loader(context);
                                    final response = await _servicesBloc
                                        .deleteAgent(
                                          requestParams: {'agent_id': p1.id},
                                        );
                                    if (context.mounted) {
                                      Dialogs.dismiss(context);
                                      if (response is ServicesStateSuccess) {
                                        Dialogs.showInfoDialog(
                                          context,
                                          PopupType.success,
                                          'Deleted Successfuly',
                                        ).then((value) {
                                          if (context.mounted) {
                                            _updateTickets(context);
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
                                    }
                                  },
                                ),
                              );
                            }
                          },
                          onPageChange: (page) {
                            index = page;
                            if (page <= (agentData?.pages ?? 0)) {
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
