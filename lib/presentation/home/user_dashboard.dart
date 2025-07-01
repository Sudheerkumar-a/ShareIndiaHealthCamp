import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/domain/entities/dashboard_entity.dart';
import 'package:shareindia_health_camp/injection_container.dart';
import 'package:shareindia_health_camp/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/res/drawables/background_box_decoration.dart';

class UserDashboard extends BaseScreenWidget {
  const UserDashboard({super.key});

  Future<String> _getDashboradData() {
    return Future.delayed(Duration(seconds: 1), () {
      return "test";
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Column(
      children: [
        SizedBox(height: resources.dimen.dp20),
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
                  ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: resources.dimen.dp20,
                        ),
                        padding: EdgeInsets.all(resources.dimen.dp20),
                        decoration:
                            BackgroundBoxDecoration(
                              boxColor: resources.color.colorWhite,
                              radious: resources.dimen.dp10,
                            ).roundedCornerBox,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'Total Screened',
                                      style: context.textFontWeight600,
                                    ),
                                  ),
                                ),
                                Text(
                                  dashboardEntity?.totalScreened ?? '',
                                  style: context.textFontWeight600.onColor(
                                    resources.color.viewBgColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: resources.dimen.dp10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'IEC Participants',
                                    style: context.textFontWeight600,
                                  ),
                                ),
                                Text(
                                  dashboardEntity?.iecParticipants ?? '',
                                  style: context.textFontWeight600.onColor(
                                    resources.color.viewBgColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: resources.dimen.dp10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'HIV Reactive',
                                    style: context.textFontWeight600,
                                  ),
                                ),
                                Text(
                                  dashboardEntity?.hiv?.reactive ?? '',
                                  style: context.textFontWeight600.onColor(
                                    resources.color.viewBgColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: resources.dimen.dp10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Partners Reactive',
                                    style: context.textFontWeight600,
                                  ),
                                ),
                                Text(
                                  dashboardEntity?.partners?.reactive ?? '',
                                  style: context.textFontWeight600.onColor(
                                    resources.color.viewBgColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: resources.dimen.dp10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'TB Presumptive',
                                    style: context.textFontWeight600,
                                  ),
                                ),
                                Text(
                                  dashboardEntity?.tb?.presumptive ?? '',
                                  style: context.textFontWeight600.onColor(
                                    resources.color.viewBgColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: resources.dimen.dp10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'TB Diagnosed',
                                    style: context.textFontWeight600,
                                  ),
                                ),
                                Text(
                                  dashboardEntity?.tb?.diagnosed ?? '',
                                  style: context.textFontWeight600.onColor(
                                    resources.color.viewBgColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  : Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        ),
      ],
    );
  }
}
