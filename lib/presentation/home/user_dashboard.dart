import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
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
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final districtsData =
        districts
            .map(
              (item) =>
                  DashboardEntity()
                    ..district = item['name']
                    ..totalScreened = '30'
                    ..hiv = (HivEntity()..reactive = '10')
                    ..iecParticipants = '20'
                    ..partners = (PartnersEntity()..reactive = '32'),
            )
            .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: sl<ServicesBloc>().getDashboardData(requestParams: {}),
              builder: (context, snapshot) {
                final data = snapshot.data;
                DashboardEntity? dashboardEntity = DashboardEntity();
                if (snapshot.hasData && data is ServicesStateSuccess) {
                  dashboardEntity = cast<DashboardEntity?>(
                    data.responseEntity.entity,
                  );
                }
                return snapshot.hasData
                    ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (FormEntity()
                                ..type = 'labelheader'
                                ..labelEn = 'Andhra Pradesh'.toUpperCase()
                                ..labelTe = 'Andhra Pradesh'.toUpperCase())
                              .getWidget(context),
                          (FormEntity()
                                ..type = 'collection'
                                ..placeholderEn = 'Select Distric'
                                ..placeholderTe = 'Select Distric'
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
                                ..onDatachnage = (value) {})
                              .getWidget(context),
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
                                          boxColor: resources.color.colorWhite,
                                          radious: resources.dimen.dp10,
                                        ).roundedCornerBox,
                                    child: Text.rich(
                                      textAlign: TextAlign.end,
                                      TextSpan(
                                        text: 'Total Screened\n',
                                        style: context.textFontWeight600,
                                        children: [
                                          TextSpan(
                                            text:
                                                dashboardEntity
                                                    ?.totalScreened ??
                                                '',
                                            style: context.textFontWeight600
                                                .onFontSize(
                                                  resources.fontSize.dp18,
                                                )
                                                .onColor(
                                                  resources.color.viewBgColor,
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
                                          boxColor: resources.color.colorWhite,
                                          radious: resources.dimen.dp10,
                                        ).roundedCornerBox,
                                    child: Text.rich(
                                      textAlign: TextAlign.end,
                                      TextSpan(
                                        text: 'HIV Reactive\n',
                                        style: context.textFontWeight600,
                                        children: [
                                          TextSpan(
                                            text:
                                                dashboardEntity
                                                    ?.iecParticipants ??
                                                '',
                                            style: context.textFontWeight600
                                                .onFontSize(
                                                  resources.fontSize.dp18,
                                                )
                                                .onColor(
                                                  resources.color.viewBgColor,
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
                                          boxColor: resources.color.colorWhite,
                                          radious: resources.dimen.dp10,
                                        ).roundedCornerBox,
                                    child: Text.rich(
                                      textAlign: TextAlign.end,
                                      TextSpan(
                                        text: 'Hypertension\n',
                                        style: context.textFontWeight600,
                                        children: [
                                          TextSpan(
                                            text:
                                                dashboardEntity
                                                    ?.hiv
                                                    ?.reactive ??
                                                '',
                                            style: context.textFontWeight600
                                                .onFontSize(
                                                  resources.fontSize.dp18,
                                                )
                                                .onColor(
                                                  resources.color.viewBgColor,
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
                                          boxColor: resources.color.colorWhite,
                                          radious: resources.dimen.dp10,
                                        ).roundedCornerBox,
                                    child: Text.rich(
                                      textAlign: TextAlign.end,
                                      TextSpan(
                                        text: 'Diabetes\n',
                                        style: context.textFontWeight600,
                                        children: [
                                          TextSpan(
                                            text:
                                                dashboardEntity
                                                    ?.partners
                                                    ?.reactive ??
                                                '',
                                            style: context.textFontWeight600
                                                .onFontSize(
                                                  resources.fontSize.dp18,
                                                )
                                                .onColor(
                                                  resources.color.viewBgColor,
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
                                          boxColor: resources.color.colorWhite,
                                          radious: resources.dimen.dp10,
                                        ).roundedCornerBox,
                                    child: Text.rich(
                                      textAlign: TextAlign.end,
                                      TextSpan(
                                        text: 'Cancer Abnormal\n',
                                        style: context.textFontWeight600,
                                        children: [
                                          TextSpan(
                                            text:
                                                dashboardEntity
                                                    ?.hiv
                                                    ?.reactive ??
                                                '',
                                            style: context.textFontWeight600
                                                .onFontSize(
                                                  resources.fontSize.dp18,
                                                )
                                                .onColor(
                                                  resources.color.viewBgColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: resources.dimen.dp10),
                                Expanded(child: SizedBox()),
                              ],
                            ),
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
                                      })
                                    .getWidget(context),
                              ),
                            ],
                          ),
                          ReportListWidget(
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
                            totalPagecount: (districtsData.length / 10).ceil(),
                            reportData: districtsData.sublist(1, 10),
                          ),
                        ],
                      ),
                    )
                    : Center(child: CircularProgressIndicator.adaptive());
              },
            ),
          ),
        ],
      ),
    );
  }
}
