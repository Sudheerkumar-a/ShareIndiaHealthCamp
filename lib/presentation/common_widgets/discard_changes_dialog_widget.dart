import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/image_widget.dart';
import 'package:shareindia_health_camp/res/drawables/background_box_decoration.dart';
import 'package:shareindia_health_camp/res/drawables/drawable_assets.dart';

class DiscardChangesDialog extends StatelessWidget {
  final Function(int) callback;
  final Map? data;
  const DiscardChangesDialog({this.data, required this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Container(
      decoration:
          BackgroundBoxDecoration(
            radious: resources.dimen.dp15,
            boxColor: resources.color.colorWhite,
          ).topCornersBox,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: resources.dimen.dp10),
          Align(
            alignment:
                isSelectedLocalEn ? Alignment.topRight : Alignment.topLeft,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child:
                  ImageWidget(
                    path: DrawableAssets.icCross,
                    padding: EdgeInsets.only(
                      left: isSelectedLocalEn ? resources.dimen.dp5 : 0,
                      top: resources.dimen.dp5,
                      right: isSelectedLocalEn ? 0 : resources.dimen.dp5,
                      bottom: resources.dimen.dp5,
                    ),
                  ).loadImageWithMoreTapArea,
            ),
          ),
          SizedBox(height: resources.dimen.dp30),
          Text(
            data?['title'],
            textAlign: TextAlign.center,
            style: context.textFontWeight700,
          ),
          SizedBox(height: resources.dimen.dp10),
          Text(
            data?['description'],
            textAlign: TextAlign.center,
            style: context.textFontWeight500.onFontSize(
              resources.fontSize.dp12,
            ),
          ),
          SizedBox(height: resources.dimen.dp20),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              callback.call(1);
            },
            child: ActionButtonWidget(
              text: data?['action'],
              padding: EdgeInsets.symmetric(
                horizontal: context.resources.dimen.dp30,
                vertical: context.resources.dimen.dp7,
              ),
            ),
          ),
          SizedBox(height: resources.dimen.dp20),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              callback.call(2);
            },
            child: Text(
              resources.string.cancel,
              style: context.textFontWeight700.onColor(
                resources.color.viewBgColor,
              ),
            ),
          ),
          SizedBox(height: resources.dimen.dp60),
        ],
      ),
    );
  }
}
