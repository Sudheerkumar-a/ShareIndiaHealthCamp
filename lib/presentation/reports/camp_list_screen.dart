import 'dart:async';

import 'package:dartz/dartz.dart' show cast;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/domain/entities/screening_entity.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/report_list_widget.dart';
import 'package:shareindia_health_camp/presentation/reports/add_camp_form_screen.dart';
import 'package:shareindia_health_camp/presentation/reports/clients_by_camp_screen.dart';
import 'package:shareindia_health_camp/presentation/reports/outreach_camp_form_screen.dart';
import '../../injection_container.dart';

// ignore: must_be_immutable
class CampListScreen extends StatefulWidget {
  static Future<dynamic> start(
    BuildContext context, {
    int? districtId,
    int? mandalId,
    String? startDate,
    String? endDate,
    bool canEdit = true,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: CampListScreen(
          districtId: districtId,
          mandalId: mandalId,
          startDate: startDate,
          endDate: endDate,
          canEdit: canEdit,
        ),
      ),
    );
  }

  final int? districtId;
  final int? mandalId;
  final String? startDate;
  final String? endDate;
  final bool canEdit;
  const CampListScreen({
    this.districtId,
    this.mandalId,
    this.startDate,
    this.endDate,
    this.canEdit = true,
    super.key,
  });

  @override
  State<CampListScreen> createState() => _CampListScreenState();
}

class _CampListScreenState extends State<CampListScreen> {
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();

  // final _masterDataBloc = sl<MasterDataBloc>();
  List<CampEntity> camps = [];

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
      if (widget.canEdit) ...[
        Row(
          children: [
            Expanded(child: SizedBox()),

            InkWell(
              onTap: () async {
                AddCampFormScreen.start(context).then((value) {
                  if (value is int && context.mounted) {
                    OutreachCampFormScreen.start(context, campId: value).then((
                      value,
                    ) {
                      if (value == true) {
                        _updateData(context);
                      }
                    });
                  }
                });
              },
              child: ActionButtonWidget(
                text: 'Add camp details',
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
        SizedBox(height: resources.dimen.dp15),
      ],
      Text(
        'Camps (*To check camp details ${widget.canEdit ? 'or Add New Client' : ''}, click on the respective Camp)',
        style: context.textFontWeight600,
      ),
    ];
  }

  _updateData(BuildContext context) async {
    // //Dialogs.loader(context);
    // _servicesBloc.getCampList(
    //   requestParams: {
    //     'district': widget.districtId,
    //     'mandal': widget.mandalId,
    //     'start_date': widget.startDate,
    //     'end_date': widget.endDate,
    //   },
    //   emitResponse: true,
    // );
    _servicesBloc.getLocalCampList(requestParams: {}, emitResponse: true);
    // if (context.mounted) {
    //   Dialogs.dismiss(context);
    //   if (responseState is ServicesStateSuccess) {
    //     camps =
    //         cast<ListEntity>(
    //           responseState.responseEntity.entity,
    //         ).items.cast<CampEntity>();
    //   }
    //   _onFilterChange.value = !_onFilterChange.value;
    // }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (context.mounted) {
        _updateData(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final ticketsHeaderData = ['Date Of Camp', 'District', 'Mandal', 'Village'];
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
                BlocProvider(
                  create: (context) => _servicesBloc,
                  child: BlocBuilder<ServicesBloc, ServicesState>(
                    builder: (context, responseState) {
                      if (responseState is ServicesStateSuccess) {
                        camps =
                            cast<ListEntity>(
                              responseState.responseEntity.entity,
                            ).items.cast<CampEntity>();
                        if (camps.isEmpty) {
                          return Center(
                            child: Text(
                              'No Camps Available',
                              style: context.textFontWeight600.onFontSize(
                                resources.fontSize.dp14,
                              ),
                            ),
                          );
                        }
                        return ReportListWidget(
                          reportData: camps,
                          ticketsHeaderData: ticketsHeaderData,
                          ticketsTableColunwidths: ticketsTableColunwidths,
                          page: 1,
                          totalPagecount: 1,
                          onRowSelected: (ticket) {},
                          onColumnClick: (p0, p1) async {
                            ClientsByCampScreen.start(context, p1).then((p0) {
                              if (context.mounted) {
                                _updateData(context);
                              }
                            });
                          },
                          onPageChange: (page) {
                            // index = page;
                            // if (page <= (agentData?.pages ?? 0)) {
                            //   _updateTickets(context);
                            // }
                          },
                        );
                      } else if (responseState is ServicesStateApiError) {
                        return Center(
                          child: Text(
                            responseState.message,
                            style: context.textFontWeight600.onFontSize(
                              resources.fontSize.dp14,
                            ),
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: resources.dimen.dp300,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
