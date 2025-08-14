import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/string_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/domain/entities/screening_entity.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/msearch_user_app_bar.dart';

class ViewScreeningDetails extends BaseScreenWidget {
  static start(BuildContext context, ScreeningDetailsEntity screeningDetails) {
    Navigator.of(context, rootNavigator: true).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: ViewScreeningDetails(screeningDetails: screeningDetails),
      ),
    );
  }

  final ScreeningDetailsEntity screeningDetails;
  const ViewScreeningDetails({required this.screeningDetails, super.key});
  @override
  Widget build(BuildContext context) {
    final resource = context.resources;
    final data = screeningDetails.toJson();
    return SafeArea(
      bottom: true,
      child: Scaffold(
        body: Container(
          color: resource.color.colorWhite,
          child: Column(
            children: [
              MSearchUserAppBarWidget(
                title: 'Integrated Health Services (IHS)',
                showBack: true,
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: resource.dimen.dp10,
                    vertical: resource.dimen.dp10,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: resource.dimen.dp15,
                        vertical: resource.dimen.dp10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              data.keys
                                  .elementAt(index)
                                  .replaceAll('_', ' ')
                                  .capitalize(),
                              style: context.textFontWeight600.onFontSize(
                                resource.fontSize.dp12,
                              ),
                            ),
                          ),
                          SizedBox(width: resource.dimen.dp5),
                          Text(
                            ':',
                            style: context.textFontWeight600.onFontSize(
                              resource.fontSize.dp12,
                            ),
                          ),
                          SizedBox(width: resource.dimen.dp5),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${data.values.elementAt(index)}',
                              style: context.textFontWeight600.onFontSize(
                                resource.fontSize.dp12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: resource.dimen.dp5);
                  },
                  itemCount: data.length,
                ),
              ),
              SizedBox(height: context.resources.dimen.dp10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: ActionButtonWidget(
                      text: 'Delete',
                      width: 110,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.resources.dimen.dp20,
                        vertical: context.resources.dimen.dp7,
                      ),
                    ),
                  ),
                  SizedBox(width: context.resources.dimen.dp20),
                  InkWell(
                    onTap: () async {},
                    child: ActionButtonWidget(
                      text: 'Edit',
                      width: 120,
                      color: context.resources.color.viewBgColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.resources.dimen.dp20,
                        vertical: context.resources.dimen.dp7,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.resources.dimen.dp20),
            ],
          ),
        ),
      ),
    );
  }
}
