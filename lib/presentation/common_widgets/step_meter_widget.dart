import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';

class StepMetterWidget extends StatelessWidget {
  final int stepCount;
  final int currentStep;
  const StepMetterWidget(
      {required this.stepCount, this.currentStep = 1, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
            stepCount,
            (index) => Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 4,
                        color: currentStep == index + 1
                            ? context.resources.color.viewBgColor
                            : context.resources.color.dividerColorB3B8BF,
                      ),
                      SizedBox(height: 5,),
                      Visibility(
                          visible: currentStep == index + 1,
                          child: Text(
                            '$currentStep/$stepCount',
                            style: context.textFontWeight400
                                .onFontSize(context.resources.fontSize.dp12)
                                .onFontFamily(fontFamily: fontFamilyEN),
                          ))
                    ],
                  ),
                )));
  }
}
