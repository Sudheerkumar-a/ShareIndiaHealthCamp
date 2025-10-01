import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/config/base_url_config.dart';
import 'package:shareindia_health_camp/core/config/flavor_config.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/domain/entities/screening_entity.dart';
import 'package:shareindia_health_camp/domain/entities/services_entity.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/document_preview_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/image_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/report_list_widget.dart';
import 'package:shareindia_health_camp/presentation/reports/outreach_camp_form_screen.dart';
import 'package:shareindia_health_camp/presentation/reports/view_screening_details.dart';
import 'package:shareindia_health_camp/presentation/utils/dialogs.dart';
import 'package:shareindia_health_camp/res/drawables/background_box_decoration.dart';
import '../../domain/entities/user_credentials_entity.dart';
import '../../injection_container.dart';

// ignore: must_be_immutable
class ClientsByCampScreen extends BaseScreenWidget {
  CampEntity campEntity;
  static start(BuildContext context, CampEntity campEntity) {
    Navigator.of(context, rootNavigator: true).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: ClientsByCampScreen(campEntity: campEntity),
      ),
    );
  }

  ClientsByCampScreen({required this.campEntity, super.key});
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

  List<Widget> _getFilterBar(BuildContext context) {
    final resources = context.resources;
    return [
      Row(
        children: [
          Expanded(
            child: Text(
              "${campEntity.village ?? ''} - ${campEntity.campLocation ?? ''}",
              style: context.textFontWeight600,
            ),
          ),

          SizedBox(width: resources.dimen.dp20),
          InkWell(
            onTap: () async {
              OutreachCampFormScreen.start(context, campId: campEntity.id);
            },

            child: ActionButtonWidget(
              text: 'Add New Client',
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
    Map<String, dynamic> requestParams = {
      'limit': 1000,
      'page': index,
      'camp_id': campEntity.id,
      'district': districtId,
      'mandal': mandalId,
      'state': 'Andhra Pradesh',
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
                Container(
                  padding: EdgeInsets.all(resources.dimen.dp10),
                  decoration:
                      BackgroundBoxDecoration(
                        boxColor: resources.color.colorWhite,
                        radious: resources.dimen.dp10,
                      ).roundedCornerBox,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Date Of Camp:\n',
                                style: context.textFontWeight400.onFontSize(
                                  resources.fontSize.dp12,
                                ),
                                children: [
                                  TextSpan(
                                    text: campEntity.dateOfCamp ?? '',
                                    style: context.textFontWeight600.onFontSize(
                                      resources.fontSize.dp12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: resources.dimen.dp10),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Camp Photo:\n',
                                style: context.textFontWeight400.onFontSize(
                                  resources.fontSize.dp12,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        (campEntity.photoOfCamp ?? '')
                                            .split('/')
                                            .last,
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp12)
                                        .copyWith(
                                          decoration: TextDecoration.underline,
                                        ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Dialogs.showDialogWithClose(
                                              context,
                                              maxWidth:
                                                  getScrrenSize(context).width -
                                                  40,
                                              ImageWidget(
                                                path:
                                                    'http://13.232.63.203/health/${campEntity.photoOfCamp ?? ''}',
                                              ).loadImage,
                                            );
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: resources.dimen.dp10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Distric:\n',
                                style: context.textFontWeight400.onFontSize(
                                  resources.fontSize.dp12,
                                ),
                                children: [
                                  TextSpan(
                                    text: campEntity.district ?? '',
                                    style: context.textFontWeight600.onFontSize(
                                      resources.fontSize.dp12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: resources.dimen.dp10),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Mandal:\n',
                                style: context.textFontWeight400.onFontSize(
                                  resources.fontSize.dp12,
                                ),
                                children: [
                                  TextSpan(
                                    text: campEntity.mandal ?? '',
                                    style: context.textFontWeight600.onFontSize(
                                      resources.fontSize.dp12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: resources.dimen.dp10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Village:\n',
                                style: context.textFontWeight400.onFontSize(
                                  resources.fontSize.dp12,
                                ),
                                children: [
                                  TextSpan(
                                    text: campEntity.village ?? '',
                                    style: context.textFontWeight600.onFontSize(
                                      resources.fontSize.dp12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: resources.dimen.dp10),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Camp Location:\n',
                                style: context.textFontWeight400.onFontSize(
                                  resources.fontSize.dp12,
                                ),
                                children: [
                                  TextSpan(
                                    text: campEntity.campLocation ?? '',
                                    style: context.textFontWeight600.onFontSize(
                                      resources.fontSize.dp12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: resources.dimen.dp10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Local Poc Name:\n',
                                style: context.textFontWeight400.onFontSize(
                                  resources.fontSize.dp12,
                                ),
                                children: [
                                  TextSpan(
                                    text: campEntity.localPocName ?? '',
                                    style: context.textFontWeight600.onFontSize(
                                      resources.fontSize.dp12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: resources.dimen.dp10),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Local Poc Number:\n',
                                style: context.textFontWeight400.onFontSize(
                                  resources.fontSize.dp12,
                                ),
                                children: [
                                  TextSpan(
                                    text: campEntity.localPocNumber ?? '',
                                    style: context.textFontWeight600.onFontSize(
                                      resources.fontSize.dp12,
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
                SizedBox(height: resources.dimen.dp20),
                ValueListenableBuilder(
                  valueListenable: _onFilterChange,
                  builder: (context, value, child) {
                    return ValueListenableBuilder(
                      valueListenable: _onFilterChange,
                      builder: (context, value, child) {
                        final ticketsHeaderData =
                            ScreeningDetailsEntity().toJson().keys.toList();
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
